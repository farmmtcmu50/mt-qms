import type { ItemStatus, Role } from './api';

// แสดงปี พ.ศ. ตามเวลาไทย (เก็บใน DB เป็น ค.ศ. / UTC)
const dateFmt = new Intl.DateTimeFormat('th-TH-u-ca-buddhist', { day: 'numeric', month: 'short', year: 'numeric', timeZone: 'Asia/Bangkok' });
const dateTimeFmt = new Intl.DateTimeFormat('th-TH-u-ca-buddhist', {
  day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', timeZone: 'Asia/Bangkok',
});

/** 'YYYY-MM-DD' หรือ ISO timestamp → "7 ต.ค. 2569" */
export function thDate(s: string | null | undefined) {
  if (!s) return '—';
  return dateFmt.format(new Date(s.length === 10 ? s + 'T00:00:00+07:00' : s));
}
export function thDateTime(s: string | null | undefined) {
  if (!s) return '—';
  return dateTimeFmt.format(new Date(s)) + ' น.';
}

export function daysUntil(date: string, today: string) {
  return Math.round((Date.parse(date) - Date.parse(today)) / 86400e3);
}

/** ชื่อสาขาแบบสั้นสำหรับแท็บ/หัวตาราง (ตาม docs/design) */
export const BRANCH_SHORT: Record<string, string> = {
  BSR: 'บ่อสร้าง',
  RPK: 'หางดง',
  IBL: 'หนองหอย',
  UP: 'ม.พะเยา',
  MOL: 'อณูชีววิทยา',
};

export const ROLE_LABEL: Record<Role, string> = {
  TOP_MGMT: 'Top Mgmt',
  QM: 'ผู้จัดการคุณภาพ',
  LAB_HEAD: 'หัวหน้าห้องปฏิบัติการ',
  STAFF: 'นักเทคนิคการแพทย์',
  INT_AUDITOR: 'ผู้ตรวจภายใน',
  SAFETY: 'ผู้รับผิดชอบความปลอดภัย',
  EXT_AUDITOR: 'ผู้ตรวจภายนอก',
};

export const STATUS: Record<ItemStatus, { label: string; tone: 'good' | 'warn' | 'crit' | 'neutral' }> = {
  READY: { label: 'หลักฐานครบ', tone: 'good' },
  PARTIAL: { label: 'เสี่ยง Obs', tone: 'warn' },
  MISSING: { label: 'เสี่ยง NC', tone: 'crit' },
  NA: { label: 'N/A', tone: 'neutral' },
};

/** ระดับสีของ % ความพร้อม: ≥ 90 ดี, 70–89 พอใช้, 50–69 เตือน, < 50 วิกฤต */
export function pctLevel(p: number | null) {
  if (p === null) return 'none';
  if (p >= 90) return 'good';
  if (p >= 70) return 'fair';
  if (p >= 50) return 'warn';
  return 'crit';
}

export function fileSize(n: number) {
  if (n < 1024) return `${n} B`;
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(0)} KB`;
  return `${(n / 1024 / 1024).toFixed(1)} MB`;
}
