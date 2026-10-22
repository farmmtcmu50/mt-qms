import { Hono } from 'hono';
import { addDays, todayBangkok } from '../lib/dates';
import { branchFilter, branchScope, inScope } from '../lib/rbac';
import { ACTIVE_BRANCH_EVIDENCE, readinessRows, summarize, topSection, type ReadinessRow } from '../lib/readiness';
import type { AppEnv } from '../types';

export const dashboard = new Hono<AppEnv>();

/** GET /dashboard/readiness?branch= — Readiness % รายสาขา และ heatmap 12 หมวด × สาขา */
dashboard.get('/dashboard/readiness', async (c) => {
  let scope = branchScope(c.get('user'));
  const branch = c.req.query('branch');
  if (branch) {
    if (!inScope(scope, branch)) return c.json({ error: 'forbidden_branch' }, 403);
    scope = [branch];
  }
  const rows = await readinessRows(c.env.DB, scope, todayBangkok());
  const group = (key: (r: ReadinessRow) => string) => {
    const m = new Map<string, ReadinessRow[]>();
    for (const r of rows) m.set(key(r), [...(m.get(key(r)) ?? []), r]);
    return m;
  };
  const byBranch = group((r) => r.branch_id);
  const byCell = group((r) => `${topSection(r.section_code)}|${r.branch_id}`);
  return c.json({
    overall: summarize(rows),
    branches: Object.fromEntries([...byBranch].map(([b, rs]) => [b, summarize(rs)])),
    cells: [...byCell].map(([k, rs]) => {
      const [section, branch_id] = k.split('|');
      return { section, branch_id, ...summarize(rs) };
    }),
  });
});

/** GET /dashboard/overview — หลักฐานใกล้หมดอายุใน 30 วัน (KPI NC/งานตามรอบเริ่มในระยะที่ 2–3) */
dashboard.get('/dashboard/overview', async (c) => {
  const scope = branchScope(c.get('user'));
  const today = todayBangkok();
  const bf = branchFilter('e.branch_id', scope, true);
  const { results: expiring } = await c.env.DB.prepare(
    `SELECT e.id, e.title, e.branch_id, e.valid_until,
            (SELECT GROUP_CONCAT(DISTINCT r.item_no) FROM evidence_links l JOIN requirements r ON r.id = l.requirement_id
              WHERE l.evidence_id = e.id) AS item_nos
     FROM evidence e
     WHERE e.deleted_at IS NULL AND e.valid_until IS NOT NULL AND e.valid_until >= ? AND e.valid_until <= ? AND ${bf.sql} AND ${ACTIVE_BRANCH_EVIDENCE}
     ORDER BY e.valid_until LIMIT 50`,
  ).bind(today, addDays(today, 30), ...bf.params).all();
  return c.json({ today, expiring });
});
