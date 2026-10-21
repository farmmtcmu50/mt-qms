import type { AuditRecorder } from './middleware/withAudit';

export const ROLES = ['TOP_MGMT', 'QM', 'LAB_HEAD', 'STAFF', 'INT_AUDITOR', 'SAFETY', 'EXT_AUDITOR'] as const;
export type Role = (typeof ROLES)[number];

/** "STAFF ขึ้นไป" ตาม spec หัวข้อ 7 */
export const WRITER_ROLES: Role[] = ['STAFF', 'LAB_HEAD', 'QM', 'TOP_MGMT'];
/** บทบาทที่เปิดไฟล์ติดธง contains_pii ได้ (CLAUDE.md ข้อ 7) */
export const PII_ROLES: Role[] = ['QM', 'LAB_HEAD'];

export interface Env {
  DB: D1Database;
  DOCS: R2Bucket;
  EVIDENCE: R2Bucket;
  BACKUP: R2Bucket;
  ASSETS: Fetcher;
  ACCESS_TEAM_DOMAIN: string;
  ACCESS_AUD: string;
  APP_TZ: string;
  /** ใช้เฉพาะ `wrangler dev` / test ผ่าน .dev.vars — ห้ามตั้งใน production */
  DEV_AUTH_EMAIL?: string;
}

export interface RoleGrant {
  role: Role;
  /** null = ทุกสาขา */
  branch_id: string | null;
}

export interface CurrentUser {
  id: string;
  email: string;
  full_name: string;
  position: string | null;
  roles: RoleGrant[];
}

export type AppEnv = {
  Bindings: Env;
  Variables: {
    email: string;
    user: CurrentUser;
    audit: AuditRecorder;
  };
};
