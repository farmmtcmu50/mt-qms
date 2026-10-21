-- Migration 0003: สาขา (CLAUDE.md หัวข้อ "ข้อมูลมาตรฐาน") + ขอบเขตข้อกำหนดรายสาขาตั้งต้น
-- ทุกข้อเริ่มต้นเป็น applicable = 1; การตั้ง N/A รายสาขาทำโดย QM ผ่าน PATCH /requirements/:id/scope/:branchId
-- (ขอบเขตยื่นรับรองและข้อ 77 ของห้องอณูชีววิทยายังรอตัดสินใจ — ไม่ตั้งค่าล่วงหน้า)
-- เลขใบอนุญาตสถานพยาบาลยังไม่มีข้อมูล ปล่อยเป็น NULL

INSERT INTO branches (id, code, name_th) VALUES
  ('br-BSR', 'BSR', 'ศูนย์แล็บเมดิคอลเทรนด์ (บ่อสร้าง สันกำแพง)'),
  ('br-RPK', 'RPK', 'ราชพฤกษ์แล็บเชียงใหม่ (หางดง)'),
  ('br-IBL', 'IBL', 'ไอบลิส สหคลินิก (หนองหอย)'),
  ('br-UP',  'UP',  'เมดิคอลเทรนด์ เฮลธ์แคร์ พะเยา'),
  ('br-MOL', 'MOL', 'ห้องปฏิบัติการอณูชีววิทยา');

INSERT INTO req_branch_scope (requirement_id, branch_id, applicable)
SELECT r.id, b.id, 1 FROM requirements r CROSS JOIN branches b;
