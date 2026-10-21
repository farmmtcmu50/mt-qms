import { env } from 'cloudflare:workers';
import { beforeEach, describe, expect, it } from 'vitest';
import { api, auditRows, evidenceForm, pdfFile, seedUsers, U } from './helpers';

beforeEach(seedUsers);

async function upload(as: string, fields: Record<string, string>, file?: File) {
  return api('/evidence', { as, method: 'POST', form: evidenceForm(fields, file) });
}

async function uploadOk(as: string, fields: Record<string, string>) {
  const res = await upload(as, fields);
  expect(res.status).toBe(201);
  return (await res.json<{ evidence: { id: string; r2_key: string; retain_until: string } }>()).evidence;
}

describe('POST /evidence', () => {
  it('stores the file in R2, writes evidence + link + audit in one batch', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001', criterion_id: 'crit-001-1', title: 'ใบอนุญาตสถานพยาบาล' });
    expect(ev.r2_key).toMatch(/^evidence\/BSR\/\d{4}\/\d{2}\/[0-9A-Z]{26}-evidence\.pdf$/);
    expect(await env.EVIDENCE.head(ev.r2_key)).not.toBeNull();
    const audits = await auditRows('evidence', ev.id);
    expect(audits.map((a) => a.action)).toEqual(['CREATE']);
    expect(JSON.parse(audits[0].after_json)).toMatchObject({ title: 'ใบอนุญาตสถานพยาบาล', uploaded_by: 'u-staff-bsr' });
    expect(await auditRows('evidence_links', `${ev.id}:req-001:crit-001-1`)).toHaveLength(1);
  });

  it('sets retain_until at least 4 years ahead', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001' });
    expect(Number(ev.retain_until.slice(0, 4))).toBeGreaterThanOrEqual(new Date().getUTCFullYear() + 4);
  });

  it('refuses uploads to another branch (403)', async () => {
    expect((await upload(U.staffBsr, { branch_id: 'br-RPK', requirement_id: 'req-001' })).status).toBe(403);
  });

  it('allows shared (all-branch) evidence only for all-branch roles', async () => {
    expect((await upload(U.staffBsr, { branch_id: '', requirement_id: 'req-001' })).status).toBe(403);
    expect((await upload(U.qm, { branch_id: '', requirement_id: 'req-001' })).status).toBe(201);
  });

  it('rejects disallowed file types and a criterion from another requirement', async () => {
    expect((await upload(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001' }, new File(['x'], 'run.exe'))).status).toBe(415);
    expect((await upload(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001', criterion_id: 'crit-006-1' })).status).toBe(422);
  });
});

describe('readiness from evidence', () => {
  it('item becomes READY when every criterion has valid evidence; expired evidence does not count', async () => {
    const status = async () =>
      (await (await api('/requirements/2', { as: U.staffBsr })).json<{ readiness: Record<string, { status: string; ok: number }> }>()).readiness['br-BSR'];
    expect((await status()).status).toBe('MISSING');
    await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-002', criterion_id: 'crit-002-1' });
    expect((await status()).status).toBe('PARTIAL');
    await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-002', criterion_id: 'crit-002-2' });
    await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-002', criterion_id: 'crit-002-3', valid_until: '2020-01-01' });
    expect(await status()).toMatchObject({ status: 'PARTIAL', ok: 2 });
    await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-002', criterion_id: 'crit-002-3', valid_until: '2099-12-31' });
    expect((await status()).status).toBe('READY');

    // หลักฐานของบ่อสร้างไม่นับให้หางดง
    const rpk = await (await api('/requirements/2', { as: U.qm })).json<{ readiness: Record<string, { status: string }> }>();
    expect(rpk.readiness['br-RPK'].status).toBe('MISSING');
  });
});

describe('GET /files/:evidenceId', () => {
  it('streams the file to a user of the same branch and logs DOWNLOAD', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001' });
    const res = await api(`/files/${ev.id}`, { as: U.staffBsr });
    expect(res.status).toBe(200);
    expect(await res.text()).toBe('%PDF-1.4 test');
    expect(res.headers.get('content-disposition')).toContain('attachment');
    expect((await auditRows('evidence', ev.id)).map((a) => a.action)).toEqual(['CREATE', 'DOWNLOAD']);
  });

  it('hides evidence of other branches (404)', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001' });
    expect((await api(`/files/${ev.id}`, { as: U.staffRpk })).status).toBe(404);
  });

  it('restricts contains_pii files to QM / LAB_HEAD', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-057', contains_pii: '1' });
    expect((await api(`/files/${ev.id}`, { as: U.staffBsr })).status).toBe(403);
    expect((await api(`/files/${ev.id}`, { as: U.headBsr })).status).toBe(200);
    expect((await api(`/files/${ev.id}`, { as: U.qm })).status).toBe(200);
  });
});

describe('POST /evidence/:id/links', () => {
  it('links existing evidence to another requirement and refuses duplicates and other branches', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-006', criterion_id: 'crit-006-1' });
    const link = (as: string) => api(`/evidence/${ev.id}/links`, { as, method: 'POST', json: { requirement_id: 'req-007' } });
    expect((await link(U.staffRpk)).status).toBe(404);
    expect((await link(U.staffBsr)).status).toBe(201);
    expect((await link(U.staffBsr)).status).toBe(409);
    expect(await auditRows('evidence_links', `${ev.id}:req-007:`)).toHaveLength(1);
  });
});

describe('DELETE /evidence/:id (soft delete)', () => {
  it('sets deleted_at, keeps the row and R2 object, and logs before/after', async () => {
    const ev = await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-001' });
    expect((await api(`/evidence/${ev.id}`, { as: U.staffRpk, method: 'DELETE' })).status).toBe(404);
    expect((await api(`/evidence/${ev.id}`, { as: U.staffBsr, method: 'DELETE' })).status).toBe(200);
    const row = await env.DB.prepare('SELECT deleted_at FROM evidence WHERE id = ?').bind(ev.id).first<{ deleted_at: string }>();
    expect(row?.deleted_at).toBeTruthy();
    expect(await env.EVIDENCE.head(ev.r2_key)).not.toBeNull();
    const del = (await auditRows('evidence', ev.id)).find((a) => a.action === 'DELETE')!;
    expect(JSON.parse(del.before_json).deleted_at).toBeNull();
    expect(JSON.parse(del.after_json).deleted_at).toBeTruthy();
    expect((await api(`/files/${ev.id}`, { as: U.staffBsr })).status).toBe(404);
  });
});

describe('dashboard', () => {
  it('lists evidence expiring within 30 days only for visible branches', async () => {
    const soon = new Date(Date.now() + 10 * 86400e3).toISOString().slice(0, 10);
    await uploadOk(U.staffBsr, { branch_id: 'br-BSR', requirement_id: 'req-042', valid_until: soon, title: 'ใบสอบเทียบ' });
    const mine = await (await api('/dashboard/overview', { as: U.staffBsr })).json<{ expiring: unknown[] }>();
    const other = await (await api('/dashboard/overview', { as: U.staffRpk })).json<{ expiring: unknown[] }>();
    expect(mine.expiring).toHaveLength(1);
    expect(other.expiring).toHaveLength(0);
  });

  it('readiness heatmap covers 12 sections × visible branches', async () => {
    const r = await (await api('/dashboard/readiness', { as: U.staffBsr })).json<{ cells: unknown[]; overall: { applicable: number } }>();
    expect(r.cells).toHaveLength(12);
    expect(r.overall.applicable).toBe(90);
    expect((await api('/dashboard/readiness?branch=br-RPK', { as: U.staffBsr })).status).toBe(403);
  });
});
