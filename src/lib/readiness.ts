import { branchFilter, type BranchScope } from './rbac';

// ตรรกะเดียวกับ view v_requirement_readiness (spec หัวข้อ 5) แต่ใช้ "วันนี้" ตามเวลาไทยแทน date('now') ของ UTC

export type ItemStatus = 'READY' | 'PARTIAL' | 'MISSING' | 'NA';

export interface ReadinessRow {
  branch_id: string;
  requirement_id: string;
  item_no: number;
  section_code: string;
  applicable: number;
  criteria_total: number;
  criteria_ok: number;
}

/** ครบทุกเกณฑ์ย่อย = พร้อม, ขาดบางส่วน = เสี่ยง Obs, ไม่มีหลักฐานเลย = เสี่ยง NC */
export function itemStatus(r: Pick<ReadinessRow, 'applicable' | 'criteria_total' | 'criteria_ok'>): ItemStatus {
  if (!r.applicable) return 'NA';
  if (r.criteria_total > 0 && r.criteria_ok >= r.criteria_total) return 'READY';
  return r.criteria_ok > 0 ? 'PARTIAL' : 'MISSING';
}

/** เกณฑ์ย่อยนับว่ามีหลักฐาน เมื่อมี evidence ที่ไม่ถูกลบ ยังไม่หมดอายุ และเป็นของสาขานั้นหรือหลักฐานกลาง */
const VALID_EVIDENCE = `e.deleted_at IS NULL
  AND (e.branch_id = s.branch_id OR e.branch_id IS NULL)
  AND (e.valid_until IS NULL OR e.valid_until >= ?)`;

export async function readinessRows(
  db: D1Database,
  scope: BranchScope,
  today: string,
  opts: { requirementId?: string } = {},
): Promise<ReadinessRow[]> {
  const bf = branchFilter('s.branch_id', scope);
  const reqFilter = opts.requirementId ? 'AND r.id = ?' : '';
  const sql = `
    SELECT s.branch_id, r.id AS requirement_id, r.item_no, sec.code AS section_code, s.applicable,
      (SELECT COUNT(*) FROM req_criteria c WHERE c.requirement_id = r.id) AS criteria_total,
      (SELECT COUNT(DISTINCT c.id) FROM req_criteria c
         JOIN evidence_links l ON l.criterion_id = c.id AND l.requirement_id = r.id
         JOIN evidence e ON e.id = l.evidence_id
       WHERE c.requirement_id = r.id AND ${VALID_EVIDENCE}) AS criteria_ok
    FROM requirements r
    JOIN req_sections sec ON sec.id = r.section_id
    JOIN req_branch_scope s ON s.requirement_id = r.id
    JOIN branches b ON b.id = s.branch_id AND b.is_active = 1
    WHERE ${bf.sql} ${reqFilter}
    ORDER BY r.item_no, b.code`;
  const params: unknown[] = [today, ...bf.params];
  if (opts.requirementId) params.push(opts.requirementId);
  const { results } = await db.prepare(sql).bind(...params).all<ReadinessRow>();
  return results;
}

/** หมวดหลัก 1–12 จากรหัสหมวดย่อย เช่น '9.6' → '9' */
export const topSection = (code: string) => code.split('.')[0];

export interface ReadinessSummary {
  applicable: number;
  ready: number;
  partial: number;
  missing: number;
  na: number;
  /** ข้อที่หลักฐานครบ ÷ (จำนวนข้อ − N/A) เป็น %, null ถ้าไม่มีข้อที่ใช้ได้ */
  pct: number | null;
}

export function summarize(rows: Pick<ReadinessRow, 'applicable' | 'criteria_total' | 'criteria_ok'>[]): ReadinessSummary {
  const s = { applicable: 0, ready: 0, partial: 0, missing: 0, na: 0 };
  for (const r of rows) {
    const st = itemStatus(r);
    if (st === 'NA') s.na++;
    else {
      s.applicable++;
      if (st === 'READY') s.ready++;
      else if (st === 'PARTIAL') s.partial++;
      else s.missing++;
    }
  }
  return { ...s, pct: s.applicable ? Math.round((s.ready / s.applicable) * 100) : null };
}
