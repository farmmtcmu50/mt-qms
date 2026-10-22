import { Hono } from 'hono';
import { addYears, isIsoDate, nowIso, todayBangkok } from '../lib/dates';
import { newId } from '../lib/ids';
import { canRead, hasRole } from '../lib/rbac';
import { PII_ROLES, WRITER_ROLES, type AppEnv } from '../types';

export const evidence = new Hono<AppEnv>();

/** ชนิดไฟล์ที่รับ (spec หัวข้อ 6) */
const ALLOWED: Record<string, string> = {
  pdf: 'application/pdf',
  jpg: 'image/jpeg',
  jpeg: 'image/jpeg',
  png: 'image/png',
  xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
};
export const MAX_BYTES = 25 * 1024 * 1024;
/** ระยะเก็บรักษาขั้นต่ำ (ข้อ 9, 13) */
const RETAIN_YEARS = 4;

interface EvidenceRow {
  id: string;
  branch_id: string | null;
  title: string;
  r2_key: string | null;
  sha256: string | null;
  mime: string | null;
  size_bytes: number | null;
  period_start: string | null;
  valid_until: string | null;
  retain_until: string | null;
  contains_pii: number;
  uploaded_by: string;
  uploaded_at: string;
  deleted_at: string | null;
}

function slugify(name: string) {
  const s = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '').slice(0, 40);
  return s || 'file';
}

async function sha256Hex(buf: ArrayBuffer) {
  const d = await crypto.subtle.digest('SHA-256', buf);
  return [...new Uint8Array(d)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

async function getEvidence(db: D1Database, id: string) {
  return db.prepare('SELECT * FROM evidence WHERE id = ?').bind(id).first<EvidenceRow>();
}

async function checkLinkTarget(db: D1Database, requirementId: string, criterionId: string | null) {
  if (criterionId) {
    return !!(await db.prepare('SELECT 1 FROM req_criteria WHERE id = ? AND requirement_id = ?').bind(criterionId, requirementId).first());
  }
  return !!(await db.prepare('SELECT 1 FROM requirements WHERE id = ?').bind(requirementId).first());
}

/**
 * POST /evidence (multipart): file, requirement_id, criterion_id?, branch_id ('' = หลักฐานกลางทุกสาขา),
 * title?, valid_until?, period_start?, contains_pii?
 */
evidence.post('/evidence', async (c) => {
  const user = c.get('user');
  const form = await c.req.formData().catch(() => null);
  if (!form) return c.json({ error: 'invalid_form' }, 400);
  const file = form.get('file');
  if (!(file instanceof File)) return c.json({ error: 'file_required' }, 400);

  const str = (k: string) => {
    const v = form.get(k);
    return typeof v === 'string' && v.trim() ? v.trim() : null;
  };
  const branchId = str('branch_id');
  const requirementId = str('requirement_id');
  const criterionId = str('criterion_id');
  const validUntil = str('valid_until');
  const periodStart = str('period_start');
  const containsPii = ['1', 'true', 'on'].includes(str('contains_pii') ?? '') ? 1 : 0;

  if (!hasRole(user, WRITER_ROLES, branchId)) return c.json({ error: 'forbidden_branch' }, 403);
  if (!requirementId) return c.json({ error: 'requirement_id_required' }, 400);
  if (validUntil && !isIsoDate(validUntil)) return c.json({ error: 'invalid_valid_until' }, 400);
  if (periodStart && !isIsoDate(periodStart)) return c.json({ error: 'invalid_period_start' }, 400);

  const ext = file.name.includes('.') ? file.name.split('.').pop()!.toLowerCase() : '';
  const mime = ALLOWED[ext];
  if (!mime) return c.json({ error: 'file_type_not_allowed', allowed: Object.keys(ALLOWED) }, 415);
  if (file.size > MAX_BYTES) return c.json({ error: 'file_too_large', max_bytes: MAX_BYTES }, 413);
  if (file.size === 0) return c.json({ error: 'file_empty' }, 400);

  let branchCode = 'ALL';
  if (branchId) {
    const b = await c.env.DB.prepare('SELECT code FROM branches WHERE id = ? AND is_active = 1').bind(branchId).first<{ code: string }>();
    if (!b) return c.json({ error: 'branch_not_found' }, 422);
    branchCode = b.code;
  }
  if (!(await checkLinkTarget(c.env.DB, requirementId, criterionId))) return c.json({ error: 'requirement_or_criterion_not_found' }, 422);

  const buf = await file.arrayBuffer();
  const sha256 = await sha256Hex(buf);
  const id = newId();
  const now = nowIso();
  const today = todayBangkok();
  const [yyyy, mm] = today.split('-');
  // ไฟล์ไม่ถูกเขียนทับ: ทุกการอัปโหลดได้ key ใหม่ (CLAUDE.md ข้อ 2)
  const r2Key = `evidence/${branchCode}/${yyyy}/${mm}/${id}-${slugify(file.name.replace(/\.[^.]+$/, ''))}.${ext}`;
  const retainUntil = addYears(validUntil && validUntil > today ? validUntil : today, RETAIN_YEARS);

  await c.env.EVIDENCE.put(r2Key, buf, {
    httpMetadata: { contentType: mime },
    customMetadata: { uploader: user.id, branch: branchCode, sha256, filename: encodeURIComponent(file.name) },
    sha256,
  });

  const row: EvidenceRow = {
    id,
    branch_id: branchId,
    title: str('title') ?? file.name,
    r2_key: r2Key,
    sha256,
    mime,
    size_bytes: file.size,
    period_start: periodStart,
    valid_until: validUntil,
    retain_until: retainUntil,
    contains_pii: containsPii,
    uploaded_by: user.id,
    uploaded_at: now,
    deleted_at: null,
  };
  const link = { evidence_id: id, requirement_id: requirementId, criterion_id: criterionId };
  const audit = c.get('audit');
  await c.env.DB.batch([
    c.env.DB.prepare(
      `INSERT INTO evidence (id, branch_id, title, r2_key, sha256, mime, size_bytes, period_start, valid_until, retain_until, contains_pii, uploaded_by, uploaded_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    ).bind(row.id, row.branch_id, row.title, row.r2_key, row.sha256, row.mime, row.size_bytes, row.period_start, row.valid_until, row.retain_until, row.contains_pii, row.uploaded_by, row.uploaded_at),
    c.env.DB.prepare('INSERT INTO evidence_links (evidence_id, requirement_id, criterion_id) VALUES (?, ?, ?)').bind(id, requirementId, criterionId),
    audit.stmt('CREATE', 'evidence', id, undefined, row),
    audit.stmt('CREATE', 'evidence_links', `${id}:${requirementId}:${criterionId ?? ''}`, undefined, link),
  ]);
  return c.json({ evidence: { ...row, contains_pii: !!row.contains_pii } }, 201);
});

/** GET /files/:evidenceId — ตรวจสิทธิ์ → บันทึก DOWNLOAD → stream จาก R2 */
evidence.get('/files/:evidenceId', async (c) => {
  const user = c.get('user');
  const ev = await getEvidence(c.env.DB, c.req.param('evidenceId'));
  if (!ev || ev.deleted_at || !ev.r2_key || !canRead(user, ev.branch_id)) return c.json({ error: 'not_found' }, 404);
  if (ev.contains_pii && !hasRole(user, PII_ROLES, ev.branch_id)) return c.json({ error: 'pii_restricted' }, 403);

  const obj = await c.env.EVIDENCE.get(ev.r2_key);
  if (!obj) return c.json({ error: 'file_missing' }, 404);
  await c.get('audit').stmt('DOWNLOAD', 'evidence', ev.id, undefined, { r2_key: ev.r2_key, sha256: ev.sha256 }).run();

  const filename = decodeURIComponent(obj.customMetadata?.filename ?? `${ev.id}`);
  const disposition = c.req.query('inline') === '1' ? 'inline' : 'attachment';
  return new Response(obj.body, {
    headers: {
      'Content-Type': ev.mime ?? 'application/octet-stream',
      'Content-Length': String(obj.size),
      'Content-Disposition': `${disposition}; filename="evidence-${ev.id}"; filename*=UTF-8''${encodeURIComponent(filename)}`,
      'Cache-Control': 'private, no-store',
      'X-Content-Type-Options': 'nosniff',
    },
  });
});

/** POST /evidence/:id/links — ผูกหลักฐานเดิมกับข้อกำหนด/เกณฑ์ย่อยเพิ่ม */
evidence.post('/evidence/:id/links', async (c) => {
  const user = c.get('user');
  const ev = await getEvidence(c.env.DB, c.req.param('id'));
  if (!ev || ev.deleted_at || !canRead(user, ev.branch_id)) return c.json({ error: 'not_found' }, 404);
  if (!hasRole(user, WRITER_ROLES, ev.branch_id)) return c.json({ error: 'forbidden_branch' }, 403);
  const body = await c.req.json<{ requirement_id?: string; criterion_id?: string | null }>().catch(() => null);
  if (!body?.requirement_id) return c.json({ error: 'requirement_id_required' }, 400);
  const criterionId = body.criterion_id || null;
  if (!(await checkLinkTarget(c.env.DB, body.requirement_id, criterionId))) return c.json({ error: 'requirement_or_criterion_not_found' }, 422);
  const dup = await c.env.DB.prepare(
    'SELECT 1 FROM evidence_links WHERE evidence_id = ? AND requirement_id = ? AND criterion_id IS ?',
  ).bind(ev.id, body.requirement_id, criterionId).first();
  if (dup) return c.json({ error: 'link_exists' }, 409);

  const link = { evidence_id: ev.id, requirement_id: body.requirement_id, criterion_id: criterionId };
  await c.env.DB.batch([
    c.env.DB.prepare('INSERT INTO evidence_links (evidence_id, requirement_id, criterion_id) VALUES (?, ?, ?)').bind(ev.id, body.requirement_id, criterionId),
    c.get('audit').stmt('CREATE', 'evidence_links', `${ev.id}:${body.requirement_id}:${criterionId ?? ''}`, undefined, link),
  ]);
  return c.json({ link }, 201);
});

/**
 * PATCH /evidence/:id — แก้ข้อมูลหลักฐาน (ตัวไฟล์เปลี่ยนไม่ได้ ต้องอัปโหลดเป็นหลักฐานใหม่)
 * body: title?, valid_until? (null = ไม่มีวันหมดอายุ), contains_pii?,
 *       relink? { requirement_id, from_criterion_id, to_criterion_id } ย้ายเกณฑ์ย่อยภายในข้อเดียวกัน
 */
evidence.patch('/evidence/:id', async (c) => {
  const user = c.get('user');
  const ev = await getEvidence(c.env.DB, c.req.param('id'));
  if (!ev || ev.deleted_at || !canRead(user, ev.branch_id)) return c.json({ error: 'not_found' }, 404);
  if (!hasRole(user, WRITER_ROLES, ev.branch_id)) return c.json({ error: 'forbidden_branch' }, 403);
  const body = await c.req
    .json<{
      title?: string;
      valid_until?: string | null;
      contains_pii?: boolean;
      relink?: { requirement_id?: string; from_criterion_id?: string | null; to_criterion_id?: string | null };
    }>()
    .catch(() => null);
  if (!body) return c.json({ error: 'invalid_json' }, 400);

  const after: EvidenceRow = { ...ev };
  if (body.title !== undefined) {
    const t = String(body.title).trim();
    if (!t || t.length > 200) return c.json({ error: 'invalid_title' }, 400);
    after.title = t;
  }
  if (body.valid_until !== undefined) {
    if (body.valid_until !== null && !isIsoDate(body.valid_until)) return c.json({ error: 'invalid_valid_until' }, 400);
    after.valid_until = body.valid_until;
    // ระยะเก็บรักษาขยายตามวันหมดอายุใหม่ได้ แต่ไม่หดสั้นลง (ข้อ 9, 13)
    const today = todayBangkok();
    const base = after.valid_until && after.valid_until > today ? after.valid_until : today;
    const wanted = addYears(base, RETAIN_YEARS);
    if (!after.retain_until || wanted > after.retain_until) after.retain_until = wanted;
  }
  if (body.contains_pii !== undefined) {
    const pii = body.contains_pii ? 1 : 0;
    // เอาธงข้อมูลส่วนบุคคลออกได้เฉพาะผู้ที่เปิดไฟล์ PII ได้ (QM / LAB_HEAD)
    if (ev.contains_pii && !pii && !hasRole(user, PII_ROLES, ev.branch_id)) return c.json({ error: 'pii_unflag_restricted' }, 403);
    after.contains_pii = pii;
  }

  const stmts: D1PreparedStatement[] = [];
  const audit = c.get('audit');
  if (body.relink) {
    const { requirement_id: reqId, from_criterion_id, to_criterion_id } = body.relink;
    const from = from_criterion_id || null;
    const to = to_criterion_id || null;
    if (!reqId) return c.json({ error: 'requirement_id_required' }, 400);
    if (from !== to) {
      const exists = (crit: string | null) =>
        c.env.DB.prepare('SELECT 1 FROM evidence_links WHERE evidence_id = ? AND requirement_id = ? AND criterion_id IS ?').bind(ev.id, reqId, crit).first();
      if (!(await exists(from))) return c.json({ error: 'link_not_found' }, 404);
      if (!(await checkLinkTarget(c.env.DB, reqId, to))) return c.json({ error: 'requirement_or_criterion_not_found' }, 422);
      if (await exists(to)) return c.json({ error: 'link_exists' }, 409);
      stmts.push(
        c.env.DB.prepare('UPDATE evidence_links SET criterion_id = ? WHERE evidence_id = ? AND requirement_id = ? AND criterion_id IS ?').bind(to, ev.id, reqId, from),
        audit.stmt('UPDATE', 'evidence_links', `${ev.id}:${reqId}`, { criterion_id: from }, { criterion_id: to }),
      );
    }
  }

  const changed = (['title', 'valid_until', 'retain_until', 'contains_pii'] as const).some((k) => after[k] !== ev[k]);
  if (changed) {
    stmts.unshift(
      c.env.DB.prepare('UPDATE evidence SET title = ?, valid_until = ?, retain_until = ?, contains_pii = ? WHERE id = ? AND deleted_at IS NULL')
        .bind(after.title, after.valid_until, after.retain_until, after.contains_pii, ev.id),
      audit.stmt('UPDATE', 'evidence', ev.id, ev, after),
    );
  }
  if (stmts.length === 0) return c.json({ error: 'no_changes' }, 400);
  await c.env.DB.batch(stmts);
  return c.json({ evidence: { ...after, contains_pii: !!after.contains_pii } });
});

/** DELETE /evidence/:id — soft delete เท่านั้น ไฟล์ใน R2 ยังอยู่จนถึง retain_until */
evidence.delete('/evidence/:id', async (c) => {
  const user = c.get('user');
  const ev = await getEvidence(c.env.DB, c.req.param('id'));
  if (!ev || ev.deleted_at || !canRead(user, ev.branch_id)) return c.json({ error: 'not_found' }, 404);
  if (!hasRole(user, WRITER_ROLES, ev.branch_id)) return c.json({ error: 'forbidden_branch' }, 403);
  const after = { ...ev, deleted_at: nowIso() };
  await c.env.DB.batch([
    c.env.DB.prepare('UPDATE evidence SET deleted_at = ? WHERE id = ? AND deleted_at IS NULL').bind(after.deleted_at, ev.id),
    c.get('audit').stmt('DELETE', 'evidence', ev.id, ev, after),
  ]);
  return c.json({ ok: true });
});
