import type { MiddlewareHandler } from 'hono';
import { todayBangkok } from '../lib/dates';
import type { AppEnv, CurrentUser, Role, RoleGrant } from '../types';

/** โหลดผู้ใช้ + คู่ (บทบาท, สาขา) ที่ยังไม่หมดอายุ; ไม่มีในระบบ = 403 */
export const loadUser: MiddlewareHandler<AppEnv> = async (c, next) => {
  const email = c.get('email');
  const user = await c.env.DB.prepare(
    'SELECT id, email, full_name, position FROM users WHERE email = ? AND is_active = 1',
  )
    .bind(email)
    .first<Omit<CurrentUser, 'roles'>>();
  if (!user) return c.json({ error: 'user_not_registered', email }, 403);

  const { results } = await c.env.DB.prepare(
    'SELECT role, branch_id FROM user_roles WHERE user_id = ? AND (valid_until IS NULL OR valid_until >= ?)',
  )
    .bind(user.id, todayBangkok())
    .all<RoleGrant>();
  if (results.length === 0) return c.json({ error: 'no_active_role' }, 403);

  c.set('user', { ...user, roles: results });
  await next();
};

/** ต้องมีบทบาทใดบทบาทหนึ่ง (สาขาใดก็ได้) — การตรวจรายสาขาทำใน handler */
export const requireRole =
  (...roles: Role[]): MiddlewareHandler<AppEnv> =>
  async (c, next) => {
    if (!c.get('user').roles.some((g) => roles.includes(g.role))) return c.json({ error: 'forbidden' }, 403);
    await next();
  };
