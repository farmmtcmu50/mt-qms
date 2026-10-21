import type { CurrentUser, Role } from '../types';

export const ALL = 'ALL' as const;
export type BranchScope = typeof ALL | string[];

/** สาขาที่ผู้ใช้มีบทบาทใดบทบาทหนึ่งใน `roles` (ไม่ระบุ = บทบาทใดก็ได้) */
export function branchScope(user: CurrentUser, roles?: Role[]): BranchScope {
  const grants = user.roles.filter((g) => !roles || roles.includes(g.role));
  if (grants.some((g) => g.branch_id === null)) return ALL;
  return [...new Set(grants.map((g) => g.branch_id as string))];
}

export function inScope(scope: BranchScope, branchId: string | null): boolean {
  if (scope === ALL) return true;
  // หลักฐานกลาง (branch_id NULL) ใช้ร่วมทุกสาขา: อ่านได้ทุกคนที่มีสิทธิ์อย่างน้อยหนึ่งสาขา แต่เขียนได้เฉพาะสิทธิ์ทุกสาขา
  return branchId !== null && scope.includes(branchId);
}

export function canRead(user: CurrentUser, branchId: string | null): boolean {
  const scope = branchScope(user);
  return branchId === null ? scope === ALL || scope.length > 0 : inScope(scope, branchId);
}

export function hasRole(user: CurrentUser, roles: Role[], branchId?: string | null): boolean {
  if (branchId === undefined) return user.roles.some((g) => roles.includes(g.role));
  return inScope(branchScope(user, roles), branchId);
}

/** คืน SQL fragment + params สำหรับกรองคอลัมน์สาขา (ต้องกรองทุก query — CLAUDE.md ข้อ 4) */
export function branchFilter(column: string, scope: BranchScope, includeShared = false): { sql: string; params: string[] } {
  const shared = includeShared ? ` OR ${column} IS NULL` : '';
  if (scope === ALL) return { sql: '1=1', params: [] };
  if (scope.length === 0) return { sql: includeShared ? `${column} IS NULL` : '0=1', params: [] };
  return { sql: `(${column} IN (${scope.map(() => '?').join(',')})${shared})`, params: scope };
}
