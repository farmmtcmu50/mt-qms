-- ข้อมูลผู้ใช้ตัวอย่างสำหรับรันบนเครื่องเท่านั้น (ห้ามใช้กับ --remote)
-- npx wrangler d1 execute mt-qms-db --local --file scripts/dev-seed.sql
INSERT OR IGNORE INTO users (id, email, full_name, position) VALUES
  ('dev-qm', 'qm@example.test', 'ผู้จัดการคุณภาพ (ตัวอย่าง)', 'ผู้จัดการคุณภาพ'),
  ('dev-staff-bsr', 'staff.bsr@example.test', 'นักเทคนิคการแพทย์ บ่อสร้าง (ตัวอย่าง)', 'นักเทคนิคการแพทย์'),
  ('dev-head-rpk', 'head.rpk@example.test', 'หัวหน้าห้องปฏิบัติการ หางดง (ตัวอย่าง)', 'หัวหน้าห้องปฏิบัติการ');
INSERT OR IGNORE INTO user_roles (user_id, role, branch_id) VALUES
  ('dev-qm', 'QM', NULL),
  ('dev-staff-bsr', 'STAFF', 'br-BSR'),
  ('dev-head-rpk', 'LAB_HEAD', 'br-RPK');
