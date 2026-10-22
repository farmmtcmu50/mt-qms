export type Role = 'TOP_MGMT' | 'QM' | 'LAB_HEAD' | 'STAFF' | 'INT_AUDITOR' | 'SAFETY' | 'EXT_AUDITOR';
export type ItemStatus = 'READY' | 'PARTIAL' | 'MISSING' | 'NA';
export type BranchScope = 'ALL' | string[];

export interface Me {
  id: string;
  email: string;
  full_name: string;
  position: string | null;
  roles: { role: Role; branch_id: string | null }[];
}
export interface Branch { id: string; code: string; name_th: string }
export interface Section { id: string; code: string; title: string; sort: number; first_item: number; last_item: number }
export interface BranchReadiness { applicable?: boolean; total: number; ok: number; status: ItemStatus }
export interface RequirementListItem {
  id: string;
  item_no: number;
  section_code: string;
  section_title: string;
  requirement_text: string;
  na_allowed: boolean;
  branches: Record<string, BranchReadiness>;
}
export interface Criterion { id: string; seq: number; text: string }
export interface EvidenceItem {
  id: string;
  branch_id: string | null;
  title: string;
  mime: string;
  size_bytes: number;
  valid_until: string | null;
  contains_pii: boolean;
  uploaded_at: string;
  uploaded_by_name: string | null;
  criterion_id: string | null;
  expired: boolean;
}
export interface ScopeRow { branch_id: string; branch_code: string; applicable: boolean; na_reason: string | null; owner_user_id: string | null; owner_name: string | null }
export interface RequirementDetail {
  requirement: RequirementListItem & { criteria_text: string; remark: string | null; frequency_months: number | null };
  parent_section: { code: string; title: string } | null;
  criteria: Criterion[];
  evidence: EvidenceItem[];
  scopes: ScopeRow[];
  readiness: Record<string, BranchReadiness>;
  neighbours: { prev: number | null; next: number | null };
  can: { upload_branches: BranchScope; edit_scope: boolean };
}
export interface Summary { applicable: number; ready: number; partial: number; missing: number; na: number; pct: number | null }
export interface ReadinessDashboard { overall: Summary; branches: Record<string, Summary>; cells: (Summary & { section: string; branch_id: string })[] }
export interface Overview { today: string; expiring: { id: string; title: string; branch_id: string | null; valid_until: string; item_nos: string | null }[] }
export interface AuditEntry { id: string; at: string; user_name: string | null; action: string; entity: string; entity_id: string; before_json: string | null; after_json: string | null }

export class ApiError extends Error {
  constructor(public status: number, public code: string) {
    super(code);
  }
}

export async function api<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`/api/v1${path}`, { credentials: 'same-origin', ...init });
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new ApiError(res.status, (body as { error?: string }).error ?? `http_${res.status}`);
  }
  return res.json() as Promise<T>;
}

export const fileUrl = (evidenceId: string, inline = false) => `/api/v1/files/${evidenceId}${inline ? '?inline=1' : ''}`;

const ERRORS: Record<string, string> = {
  unauthorized: 'ยังไม่ได้เข้าสู่ระบบ กรุณาโหลดหน้าใหม่เพื่อเข้าสู่ระบบผ่าน Cloudflare Access',
  user_not_registered: 'อีเมลนี้ยังไม่ได้ลงทะเบียนในระบบ กรุณาติดต่อผู้จัดการคุณภาพ',
  no_active_role: 'บัญชีนี้ยังไม่มีบทบาทที่ใช้งานได้ หรือสิทธิ์หมดอายุแล้ว',
  forbidden: 'ไม่มีสิทธิ์ทำรายการนี้',
  forbidden_branch: 'ไม่มีสิทธิ์ในสาขานี้',
  file_type_not_allowed: 'รับเฉพาะไฟล์ PDF, JPG, PNG, XLSX, DOCX',
  file_too_large: 'ไฟล์ต้องไม่เกิน 25 MB',
  na_not_allowed: 'ข้อนี้ตอบ N/A ไม่ได้ตามแนวทาง',
  na_reason_required: 'กรุณาระบุเหตุผลที่ไม่เกี่ยวข้อง (N/A)',
  pii_restricted: 'ไฟล์นี้มีข้อมูลส่วนบุคคล เปิดได้เฉพาะ QM / หัวหน้าห้องปฏิบัติการ',
  pii_unflag_restricted: 'เอาธงข้อมูลส่วนบุคคลออกได้เฉพาะ QM / หัวหน้าห้องปฏิบัติการ',
  invalid_title: 'ชื่อหลักฐานต้องไม่ว่างและยาวไม่เกิน 200 ตัวอักษร',
  no_changes: 'ไม่มีข้อมูลที่เปลี่ยน',
  link_exists: 'ผูกหลักฐานนี้ไว้แล้ว',
  not_found: 'ไม่พบข้อมูล',
};
export function errorText(e: unknown) {
  if (e instanceof ApiError) return ERRORS[e.code] ?? `เกิดข้อผิดพลาด (${e.code})`;
  return 'เชื่อมต่อระบบไม่ได้ กรุณาลองใหม่';
}
