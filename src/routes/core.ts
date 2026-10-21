import { Hono } from 'hono';
import { branchFilter, branchScope } from '../lib/rbac';
import { requireRole } from '../middleware/loadUser';
import type { AppEnv } from '../types';

export const core = new Hono<AppEnv>();

core.get('/me', (c) => c.json({ user: c.get('user') }));

/** สาขาที่ผู้ใช้มีสิทธิ์ */
core.get('/branches', async (c) => {
  const bf = branchFilter('id', branchScope(c.get('user')));
  const { results } = await c.env.DB.prepare(
    `SELECT id, code, name_th, license_no, license_expiry FROM branches WHERE is_active = 1 AND ${bf.sql} ORDER BY rowid`,
  ).bind(...bf.params).all();
  return c.json({ branches: results });
});

/** รายชื่อผู้ใช้สำหรับเลือกผู้รับผิดชอบ */
core.get('/users', requireRole('QM', 'LAB_HEAD', 'TOP_MGMT'), async (c) => {
  const { results } = await c.env.DB.prepare(
    'SELECT id, full_name, position FROM users WHERE is_active = 1 ORDER BY full_name',
  ).all();
  return c.json({ users: results });
});

/** GET /audit-log?entity=&id= — อ่านอย่างเดียว ไม่มี endpoint แก้/ลบ (CLAUDE.md ข้อ 1) */
core.get('/audit-log', requireRole('QM', 'TOP_MGMT'), async (c) => {
  const entity = c.req.query('entity');
  const id = c.req.query('id');
  const where: string[] = [];
  const params: string[] = [];
  if (entity) where.push('a.entity = ?'), params.push(entity);
  if (id) where.push('(a.entity_id = ? OR a.entity_id LIKE ?)'), params.push(id, `${id}:%`);
  const { results } = await c.env.DB.prepare(
    `SELECT a.*, u.full_name AS user_name FROM audit_log a LEFT JOIN users u ON u.id = a.user_id
     ${where.length ? 'WHERE ' + where.join(' AND ') : ''} ORDER BY a.at DESC LIMIT 200`,
  ).bind(...params).all();
  return c.json({ entries: results });
});
