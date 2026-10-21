import { env } from 'cloudflare:workers';
import { beforeEach, describe, expect, it } from 'vitest';
import { api, seedUsers, U } from './helpers';

// กติกาบันทึกคุณภาพอิเล็กทรอนิกส์ที่บังคับระดับ DB (CLAUDE.md ข้อ 1, 2, 5)
beforeEach(seedUsers);

const audit = () =>
  env.DB.prepare("INSERT INTO audit_log (id, at, action, entity, entity_id) VALUES ('a1', '2026-01-01T00:00:00Z', 'CREATE', 't', 'x')").run();

describe('audit_log is append-only', () => {
  it('blocks UPDATE and DELETE', async () => {
    await audit();
    await expect(env.DB.prepare("UPDATE audit_log SET action = 'DELETE' WHERE id = 'a1'").run()).rejects.toThrow(/append-only/);
    await expect(env.DB.prepare("DELETE FROM audit_log WHERE id = 'a1'").run()).rejects.toThrow(/append-only/);
  });

  it('exposes no API to modify or delete audit_log', async () => {
    for (const method of ['POST', 'PUT', 'PATCH', 'DELETE']) {
      expect((await api('/audit-log', { as: U.qm, method })).status).toBe(404);
    }
  });

  it('audit-log reading is QM / TOP_MGMT only', async () => {
    expect((await api('/audit-log', { as: U.staffBsr })).status).toBe(403);
    expect((await api('/audit-log', { as: U.top })).status).toBe(200);
  });
});

describe('evidence cannot be hard-deleted or have its file swapped', () => {
  beforeEach(async () => {
    await env.DB.prepare(
      "INSERT OR IGNORE INTO evidence (id, branch_id, title, r2_key, sha256, uploaded_by, uploaded_at) VALUES ('e1', 'br-BSR', 't', 'k1', 'h1', 'u-qm', '2026-01-01T00:00:00Z')",
    ).run();
  });

  it('blocks DELETE', async () => {
    await expect(env.DB.prepare("DELETE FROM evidence WHERE id = 'e1'").run()).rejects.toThrow(/soft delete/);
  });

  it('blocks changing r2_key or sha256', async () => {
    await expect(env.DB.prepare("UPDATE evidence SET r2_key = 'k2' WHERE id = 'e1'").run()).rejects.toThrow(/immutable/);
    await expect(env.DB.prepare("UPDATE evidence SET sha256 = 'h2' WHERE id = 'e1'").run()).rejects.toThrow(/immutable/);
  });
});

describe('segregation of duties constraints (spec หัวข้อ 5)', () => {
  it('document approver must differ from preparer', async () => {
    await env.DB.prepare("INSERT INTO documents (id, doc_code, title, level, status) VALUES ('d1', 'QP-QA-001', 't', 'QP', 'DRAFT')").run();
    await expect(
      env.DB.prepare(
        "INSERT INTO document_versions (id, document_id, revision, r2_key, sha256, prepared_by, approved_by) VALUES ('v1', 'd1', 1, 'k', 'h', 'u-staff-bsr', 'u-staff-bsr')",
      ).run(),
    ).rejects.toThrow(/CHECK/);
  });

  it('NC verifier must differ from the NC owner', async () => {
    await expect(
      env.DB.prepare(
        "INSERT INTO nc_records (id, nc_no, branch_id, source, category, description, owner_user_id, status, opened_by, verified_by) VALUES ('n1', 'NC-2569-001', 'br-BSR', 'SELF', 'C', 'd', 'u-head-bsr', 'OPEN', 'u-qm', 'u-head-bsr')",
      ).run(),
    ).rejects.toThrow(/CHECK/);
  });
});
