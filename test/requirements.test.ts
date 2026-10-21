import { env } from 'cloudflare:workers';
import { beforeEach, describe, expect, it } from 'vitest';
import { api, auditRows, seedUsers, U } from './helpers';

beforeEach(seedUsers);

describe('seed MOPH2568', () => {
  it('has 90 requirements in 12 top-level sections with the N/A rule on 23, 24, 25, 58, 77', async () => {
    const r = await env.DB.prepare('SELECT COUNT(*) n, SUM(na_allowed) na FROM requirements').first<{ n: number; na: number }>();
    expect(r).toEqual({ n: 90, na: 5 });
    const { results } = await env.DB.prepare('SELECT item_no FROM requirements WHERE na_allowed = 1 ORDER BY item_no').all<{ item_no: number }>();
    expect(results.map((x) => x.item_no)).toEqual([23, 24, 25, 58, 77]);
    const top = await env.DB.prepare("SELECT COUNT(*) n FROM req_sections WHERE code NOT LIKE '%.%'").first<{ n: number }>();
    expect(top?.n).toBe(12);
  });
});

describe('GET /requirements', () => {
  it('lists 90 items with readiness only for branches the user holds', async () => {
    const res = await api('/requirements', { as: U.staffBsr });
    expect(res.status).toBe(200);
    const { items } = await res.json<{ items: { item_no: number; branches: Record<string, unknown> }[] }>();
    expect(items).toHaveLength(90);
    expect(Object.keys(items[0].branches)).toEqual(['br-BSR']);
  });

  it('QM (all branches) sees all 5 branches', async () => {
    const { items } = await (await api('/requirements', { as: U.qm })).json<{ items: { branches: Record<string, unknown> }[] }>();
    expect(Object.keys(items[0].branches).sort()).toEqual(['br-BSR', 'br-IBL', 'br-MOL', 'br-RPK', 'br-UP']);
  });

  it('returns 403 when a user filters by a branch they do not hold', async () => {
    expect((await api('/requirements?branch=br-RPK', { as: U.staffBsr })).status).toBe(403);
  });
});

describe('GET /requirements/:key', () => {
  it('returns item 6 with its 9 sub-criteria and only the user branch scope', async () => {
    const res = await api('/requirements/6', { as: U.staffBsr });
    expect(res.status).toBe(200);
    const body = await res.json<{ criteria: unknown[]; scopes: { branch_id: string }[]; neighbours: { prev: number; next: number } }>();
    expect(body.criteria).toHaveLength(9);
    expect(body.scopes.map((s) => s.branch_id)).toEqual(['br-BSR']);
    expect(body.neighbours).toEqual({ prev: 5, next: 7 });
  });

  it('returns 404 for an unknown item', async () => {
    expect((await api('/requirements/91', { as: U.qm })).status).toBe(404);
  });
});

describe('PATCH /requirements/:id/scope/:branchId', () => {
  it('is QM only', async () => {
    const res = await api('/requirements/req-023/scope/br-BSR', { as: U.headBsr, method: 'PATCH', json: { applicable: false, na_reason: 'x' } });
    expect(res.status).toBe(403);
  });

  it('refuses N/A on items the guideline does not allow', async () => {
    const res = await api('/requirements/req-006/scope/br-BSR', { as: U.qm, method: 'PATCH', json: { applicable: false, na_reason: 'x' } });
    expect(res.status).toBe(422);
  });

  it('requires a reason for N/A', async () => {
    const res = await api('/requirements/req-023/scope/br-BSR', { as: U.qm, method: 'PATCH', json: { applicable: false } });
    expect(res.status).toBe(422);
  });

  it('sets N/A, writes before/after to audit_log and readiness shows NA', async () => {
    const res = await api('/requirements/req-023/scope/br-BSR', {
      as: U.qm, method: 'PATCH', json: { applicable: false, na_reason: 'ไม่มีบริการรับบริจาคโลหิต' },
    });
    expect(res.status).toBe(200);
    const [log] = await auditRows('req_branch_scope', 'req-023:br-BSR');
    expect(log).toMatchObject({ action: 'UPDATE', user_id: 'u-qm' });
    expect(JSON.parse(log.before_json)).toMatchObject({ applicable: 1, na_reason: null });
    expect(JSON.parse(log.after_json)).toMatchObject({ applicable: 0, na_reason: 'ไม่มีบริการรับบริจาคโลหิต' });

    const detail = await (await api('/requirements/23', { as: U.qm })).json<{ readiness: Record<string, { status: string }> }>();
    expect(detail.readiness['br-BSR'].status).toBe('NA');
    expect(detail.readiness['br-RPK'].status).toBe('MISSING');
  });
});
