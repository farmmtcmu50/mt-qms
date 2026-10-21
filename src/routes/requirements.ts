import { Hono } from 'hono';
import { todayBangkok } from '../lib/dates';
import { branchFilter, branchScope, hasRole, inScope } from '../lib/rbac';
import { itemStatus, readinessRows } from '../lib/readiness';
import { requireRole } from '../middleware/loadUser';
import { WRITER_ROLES, type AppEnv } from '../types';

export const requirements = new Hono<AppEnv>();

interface RequirementRow {
  id: string;
  item_no: number;
  section_id: string;
  section_code: string;
  section_title: string;
  requirement_text: string;
  criteria_text: string;
  remark: string | null;
  na_allowed: number;
  frequency_months: number | null;
}

const REQ_SELECT = `SELECT r.id, r.item_no, r.section_id, sec.code AS section_code, sec.title AS section_title,
  r.requirement_text, r.criteria_text, r.remark, r.na_allowed, r.frequency_months
  FROM requirements r JOIN req_sections sec ON sec.id = r.section_id`;

requirements.get('/sections', async (c) => {
  const { results } = await c.env.DB.prepare(
    `SELECT s.id, s.code, s.title, s.sort,
       (SELECT MIN(r.item_no) FROM requirements r JOIN req_sections x ON x.id = r.section_id
         WHERE x.code = s.code OR x.code LIKE s.code || '.%') AS first_item,
       (SELECT MAX(r.item_no) FROM requirements r JOIN req_sections x ON x.id = r.section_id
         WHERE x.code = s.code OR x.code LIKE s.code || '.%') AS last_item
     FROM req_sections s WHERE s.std_code = 'MOPH2568' ORDER BY s.sort`,
  ).all();
  return c.json({ sections: results });
});

/** GET /requirements?branch=&section= — รายการ 90 ข้อ พร้อมสถานะหลักฐานรายสาขาที่ผู้ใช้มีสิทธิ์ */
requirements.get('/requirements', async (c) => {
  const user = c.get('user');
  let scope = branchScope(user);
  const branch = c.req.query('branch');
  if (branch) {
    if (!inScope(scope, branch)) return c.json({ error: 'forbidden_branch' }, 403);
    scope = [branch];
  }
  const section = c.req.query('section');
  const where = section ? `WHERE sec.code = ? OR sec.code LIKE ? || '.%'` : '';
  const stmt = c.env.DB.prepare(`${REQ_SELECT} ${where} ORDER BY r.item_no`);
  const { results: reqs } = await (section ? stmt.bind(section, section) : stmt).all<RequirementRow>();
  const rows = await readinessRows(c.env.DB, scope, todayBangkok());
  const byReq = new Map<string, Record<string, unknown>>();
  for (const r of rows) {
    const m = byReq.get(r.requirement_id) ?? {};
    m[r.branch_id] = { applicable: !!r.applicable, total: r.criteria_total, ok: r.criteria_ok, status: itemStatus(r) };
    byReq.set(r.requirement_id, m);
  }
  return c.json({
    items: reqs.map((r) => ({ ...r, na_allowed: !!r.na_allowed, branches: byReq.get(r.id) ?? {} })),
  });
});

/** GET /requirements/:key — key = เลขข้อ (1–90) หรือ id; พร้อมเกณฑ์ย่อย + หลักฐาน + สถานะรายสาขา */
requirements.get('/requirements/:key', async (c) => {
  const user = c.get('user');
  const key = c.req.param('key');
  const req = /^\d+$/.test(key)
    ? await c.env.DB.prepare(`${REQ_SELECT} WHERE r.std_code = 'MOPH2568' AND r.item_no = ?`).bind(Number(key)).first<RequirementRow>()
    : await c.env.DB.prepare(`${REQ_SELECT} WHERE r.id = ?`).bind(key).first<RequirementRow>();
  if (!req) return c.json({ error: 'not_found' }, 404);

  const scope = branchScope(user);
  const today = todayBangkok();
  const bf = branchFilter('e.branch_id', scope, true);
  const sbf = branchFilter('s.branch_id', scope);
  const [criteria, evidence, scopes, parent, rows] = await Promise.all([
    c.env.DB.prepare('SELECT id, seq, text, evidence_kind FROM req_criteria WHERE requirement_id = ? ORDER BY seq').bind(req.id).all(),
    c.env.DB.prepare(
      `SELECT e.id, e.branch_id, e.title, e.mime, e.size_bytes, e.period_start, e.valid_until, e.contains_pii,
              e.uploaded_at, u.full_name AS uploaded_by_name, l.criterion_id,
              CASE WHEN e.valid_until IS NOT NULL AND e.valid_until < ? THEN 1 ELSE 0 END AS expired
       FROM evidence_links l
       JOIN evidence e ON e.id = l.evidence_id
       LEFT JOIN users u ON u.id = e.uploaded_by
       WHERE l.requirement_id = ? AND e.deleted_at IS NULL AND ${bf.sql}
       ORDER BY e.uploaded_at DESC`,
    ).bind(today, req.id, ...bf.params).all(),
    c.env.DB.prepare(
      `SELECT s.branch_id, b.code AS branch_code, s.applicable, s.na_reason, s.owner_user_id, u.full_name AS owner_name
       FROM req_branch_scope s JOIN branches b ON b.id = s.branch_id LEFT JOIN users u ON u.id = s.owner_user_id
       WHERE s.requirement_id = ? AND ${sbf.sql} ORDER BY b.rowid`,
    ).bind(req.id, ...sbf.params).all(),
    c.env.DB.prepare('SELECT code, title FROM req_sections WHERE code = ?').bind(req.section_code.split('.')[0]).first(),
    readinessRows(c.env.DB, scope, today, { requirementId: req.id }),
  ]);
  const neighbours = await c.env.DB.prepare(
    `SELECT (SELECT MAX(item_no) FROM requirements WHERE std_code = 'MOPH2568' AND item_no < ?1) AS prev,
            (SELECT MIN(item_no) FROM requirements WHERE std_code = 'MOPH2568' AND item_no > ?1) AS next`,
  ).bind(req.item_no).first();

  return c.json({
    requirement: { ...req, na_allowed: !!req.na_allowed },
    parent_section: parent,
    criteria: criteria.results,
    evidence: evidence.results.map((e) => ({ ...e, contains_pii: !!e.contains_pii, expired: !!e.expired })),
    scopes: scopes.results.map((s) => ({ ...s, applicable: !!s.applicable })),
    readiness: Object.fromEntries(
      rows.map((r) => [r.branch_id, { total: r.criteria_total, ok: r.criteria_ok, status: itemStatus(r) }]),
    ),
    neighbours,
    can: {
      upload_branches: branchScope(user, WRITER_ROLES),
      edit_scope: hasRole(user, ['QM']),
    },
  });
});

/** PATCH /requirements/:id/scope/:branchId — ตั้ง applicable / เหตุผล N/A / ผู้รับผิดชอบ (QM) */
requirements.patch('/requirements/:id/scope/:branchId', requireRole('QM'), async (c) => {
  const user = c.get('user');
  const { id, branchId } = c.req.param();
  if (!hasRole(user, ['QM'], branchId)) return c.json({ error: 'forbidden_branch' }, 403);
  const body = await c.req.json<{ applicable?: boolean; na_reason?: string | null; owner_user_id?: string | null }>().catch(() => null);
  if (!body) return c.json({ error: 'invalid_json' }, 400);

  const req = await c.env.DB.prepare('SELECT id, item_no, na_allowed FROM requirements WHERE id = ?').bind(id).first<{ id: string; item_no: number; na_allowed: number }>();
  if (!req) return c.json({ error: 'not_found' }, 404);
  const before = await c.env.DB.prepare('SELECT * FROM req_branch_scope WHERE requirement_id = ? AND branch_id = ?').bind(id, branchId).first<{
    applicable: number; na_reason: string | null; owner_user_id: string | null;
  }>();
  if (!before) return c.json({ error: 'not_found' }, 404);

  const after = {
    ...before,
    applicable: body.applicable === undefined ? before.applicable : body.applicable ? 1 : 0,
    na_reason: body.na_reason === undefined ? before.na_reason : body.na_reason?.trim() || null,
    owner_user_id: body.owner_user_id === undefined ? before.owner_user_id : body.owner_user_id,
  };
  if (!after.applicable) {
    // ตอบ N/A ได้เฉพาะข้อที่แนวทางอนุญาต (ข้อ 23, 24, 25, 58, 77) และต้องระบุเหตุผล
    if (!req.na_allowed) return c.json({ error: 'na_not_allowed', item_no: req.item_no }, 422);
    if (!after.na_reason) return c.json({ error: 'na_reason_required' }, 422);
  } else {
    after.na_reason = null;
  }
  if (after.owner_user_id) {
    const owner = await c.env.DB.prepare('SELECT id FROM users WHERE id = ? AND is_active = 1').bind(after.owner_user_id).first();
    if (!owner) return c.json({ error: 'owner_not_found' }, 422);
  }

  await c.env.DB.batch([
    c.env.DB.prepare('UPDATE req_branch_scope SET applicable = ?, na_reason = ?, owner_user_id = ? WHERE requirement_id = ? AND branch_id = ?')
      .bind(after.applicable, after.na_reason, after.owner_user_id, id, branchId),
    c.get('audit').stmt('UPDATE', 'req_branch_scope', `${id}:${branchId}`, before, after),
  ]);
  return c.json({ scope: { ...after, applicable: !!after.applicable } });
});
