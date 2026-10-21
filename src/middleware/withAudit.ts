import type { Context, MiddlewareHandler } from 'hono';
import { nowIso } from '../lib/dates';
import { newId } from '../lib/ids';
import type { AppEnv } from '../types';

export type AuditAction = 'CREATE' | 'UPDATE' | 'DELETE' | 'DOWNLOAD' | 'APPROVE' | 'LOGIN';

export interface AuditRecorder {
  /** คืน statement สำหรับใส่ใน `env.DB.batch([...])` เดียวกับการเขียนข้อมูล (atomic) */
  stmt(action: AuditAction, entity: string, entityId: string, before?: unknown, after?: unknown): D1PreparedStatement;
  readonly count: number;
}

const MUTATING = new Set(['POST', 'PUT', 'PATCH', 'DELETE']);

function recorder(c: Context<AppEnv>): AuditRecorder {
  let count = 0;
  return {
    stmt(action, entity, entityId, before, after) {
      count++;
      return c.env.DB.prepare(
        `INSERT INTO audit_log (id, at, user_id, action, entity, entity_id, before_json, after_json, ip, ray_id)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      ).bind(
        newId(),
        nowIso(),
        c.get('user')?.id ?? null,
        action,
        entity,
        entityId,
        before === undefined ? null : JSON.stringify(before),
        after === undefined ? null : JSON.stringify(after),
        c.req.header('cf-connecting-ip') ?? null,
        c.req.header('cf-ray') ?? null,
      );
    },
    get count() {
      return count;
    },
  };
}

/**
 * ทุกการเขียนและทุกการดาวน์โหลดต้องบันทึก audit_log (CLAUDE.md ข้อ 1)
 * handler ใช้ `c.get('audit').stmt(...)` ใส่ใน batch; ถ้า request เขียนสำเร็จโดยไม่มี audit จะถูกแจ้ง error
 */
export const withAudit = (): MiddlewareHandler<AppEnv> => async (c, next) => {
  const audit = recorder(c);
  c.set('audit', audit);
  await next();
  if (MUTATING.has(c.req.method) && c.res.status < 400 && audit.count === 0) {
    console.error(`audit missing for ${c.req.method} ${c.req.path}`);
    c.res = c.json({ error: 'audit_missing' }, 500);
  }
};
