-- Migration 0004: ขอบเขตยื่นรับรองเริ่มที่ศูนย์แล็บเมดิคอลเทรนด์ (บ่อสร้าง) สาขาเดียว (ตัดสินใจ 22 ต.ค. 2569)
-- ปิดใช้งานสาขาอื่นชั่วคราวด้วย is_active = 0 — ไม่ลบข้อมูล เปิดกลับได้ด้วย migration ใหม่ที่ตั้ง is_active = 1
INSERT INTO audit_log (id, at, user_id, action, entity, entity_id, before_json, after_json)
SELECT 'mig0004-' || id, strftime('%Y-%m-%dT%H:%M:%fZ', 'now'), NULL, 'UPDATE', 'branches', id,
       json_object('is_active', is_active), json_object('is_active', 0, 'via', 'migration 0004_scope_bsr_only')
FROM branches WHERE code <> 'BSR' AND is_active = 1;

UPDATE branches SET is_active = 0 WHERE code <> 'BSR';
