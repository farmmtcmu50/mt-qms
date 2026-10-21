import { env, exports } from 'cloudflare:workers';

export const U = {
  qm: 'qm@example.test',
  top: 'top@example.test',
  staffBsr: 'staff.bsr@example.test',
  staffRpk: 'staff.rpk@example.test',
  headBsr: 'head.bsr@example.test',
  extExpired: 'ext.old@example.test',
  nobody: 'nobody@example.test',
};

/** ผู้ใช้ตัวอย่าง (ข้อมูลทดสอบเท่านั้น) */
export async function seedUsers() {
  const rows: [string, string, string, string | null, string | null][] = [
    ['u-qm', U.qm, 'QM', null, null],
    ['u-top', U.top, 'TOP_MGMT', null, null],
    ['u-staff-bsr', U.staffBsr, 'STAFF', 'br-BSR', null],
    ['u-staff-rpk', U.staffRpk, 'STAFF', 'br-RPK', null],
    ['u-head-bsr', U.headBsr, 'LAB_HEAD', 'br-BSR', null],
    ['u-ext-old', U.extExpired, 'EXT_AUDITOR', 'br-BSR', '2020-01-01'],
  ];
  await env.DB.batch(
    rows.flatMap(([id, email, role, branch, until]) => [
      env.DB.prepare('INSERT OR IGNORE INTO users (id, email, full_name) VALUES (?, ?, ?)').bind(id, email, id),
      env.DB.prepare('INSERT OR IGNORE INTO user_roles (user_id, role, branch_id, valid_until) VALUES (?, ?, ?, ?)').bind(id, role, branch, until),
    ]),
  );
}

export function api(path: string, opts: { as?: string; method?: string; json?: unknown; form?: FormData; host?: string; headers?: Record<string, string> } = {}) {
  const headers: Record<string, string> = { ...(opts.headers ?? {}) };
  if (opts.as) headers['x-dev-user-email'] = opts.as;
  let body: BodyInit | undefined;
  if (opts.json !== undefined) {
    headers['content-type'] = 'application/json';
    body = JSON.stringify(opts.json);
  } else if (opts.form) body = opts.form;
  return (exports as unknown as { default: Fetcher }).default.fetch(new Request(`${opts.host ?? 'http://localhost'}/api/v1${path}`, { method: opts.method ?? 'GET', headers, body }));
}

export function pdfFile(name = 'evidence.pdf', content = '%PDF-1.4 test') {
  return new File([content], name, { type: 'application/pdf' });
}

export function evidenceForm(fields: Record<string, string>, file: File = pdfFile()) {
  const f = new FormData();
  f.set('file', file);
  for (const [k, v] of Object.entries(fields)) f.set(k, v);
  return f;
}

export async function auditRows(entity: string, entityId: string) {
  const { results } = await env.DB.prepare('SELECT * FROM audit_log WHERE entity = ? AND entity_id = ? ORDER BY at').bind(entity, entityId).all<Record<string, string>>();
  return results;
}
