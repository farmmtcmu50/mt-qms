import { env } from 'cloudflare:workers';
import { beforeEach, describe, expect, it } from 'vitest';
import { api, auditRows, evidenceForm, seedUsers, U } from './helpers';

// สถานะ production หลัง migration 0004: เปิดใช้เฉพาะศูนย์แล็บบ่อสร้าง (BSR)
beforeEach(() => seedUsers({ reactivateRpk: false }));

describe('migration 0004 — BSR only', () => {
  it('keeps other branches and their scope rows, only inactive, with audit rows', async () => {
    const { results } = await env.DB.prepare('SELECT code, is_active FROM branches ORDER BY rowid').all<{ code: string; is_active: number }>();
    expect(results).toEqual([
      { code: 'BSR', is_active: 1 }, { code: 'RPK', is_active: 0 }, { code: 'IBL', is_active: 0 }, { code: 'UP', is_active: 0 }, { code: 'MOL', is_active: 0 },
    ]);
    expect((await env.DB.prepare('SELECT COUNT(*) n FROM req_branch_scope').first<{ n: number }>())?.n).toBe(450);
    const [log] = await auditRows('branches', 'br-IBL');
    expect(JSON.parse(log.after_json)).toMatchObject({ is_active: 0 });
  });

  it('QM sees only BSR in branches, requirements, detail tabs and dashboard', async () => {
    const b = await (await api('/branches', { as: U.qm })).json<{ branches: { code: string }[] }>();
    expect(b.branches.map((x) => x.code)).toEqual(['BSR']);
    const list = await (await api('/requirements', { as: U.qm })).json<{ items: { branches: Record<string, unknown> }[] }>();
    expect(Object.keys(list.items[0].branches)).toEqual(['br-BSR']);
    const detail = await (await api('/requirements/6', { as: U.qm })).json<{ scopes: { branch_id: string }[] }>();
    expect(detail.scopes.map((s) => s.branch_id)).toEqual(['br-BSR']);
    const dash = await (await api('/dashboard/readiness', { as: U.qm })).json<{ overall: { applicable: number }; cells: unknown[] }>();
    expect(dash.overall.applicable).toBe(90);
    expect(dash.cells).toHaveLength(12);
  });

  it('refuses uploads and scope changes for an inactive branch', async () => {
    const up = await api('/evidence', { as: U.qm, method: 'POST', form: evidenceForm({ branch_id: 'br-RPK', requirement_id: 'req-001' }) });
    expect(up.status).toBe(422);
    const patch = await api('/requirements/req-023/scope/br-RPK', { as: U.qm, method: 'PATCH', json: { applicable: false, na_reason: 'x' } });
    expect(patch.status).toBe(404);
  });

  it('a user whose only branch is inactive sees no readiness rows', async () => {
    const r = await (await api('/requirements', { as: U.staffRpk })).json<{ items: { branches: Record<string, unknown> }[] }>();
    expect(Object.keys(r.items[0].branches)).toEqual([]);
  });
});
