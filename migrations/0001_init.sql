-- Migration 0001: ตารางหลักตาม docs/system-design-spec.md หัวข้อ 5
-- ห้ามแก้ไฟล์นี้หลัง apply แล้ว ให้เขียน migration ใหม่แทน

-- ===== องค์กรและผู้ใช้ =====
CREATE TABLE branches (
  id TEXT PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,          -- BSR, RPK, IBL, UP, MOL
  name_th TEXT NOT NULL,
  license_no TEXT,                    -- ใบอนุญาตสถานพยาบาล (ข้อ 1)
  license_expiry TEXT,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,         -- ตรงกับอีเมลใน Cloudflare Access
  full_name TEXT NOT NULL,
  position TEXT,
  pro_license_no TEXT,                -- ใบประกอบวิชาชีพ (ข้อ 19)
  pro_license_expiry TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now'))
);

CREATE TABLE user_roles (
  user_id TEXT NOT NULL REFERENCES users(id),
  role TEXT NOT NULL CHECK (role IN ('TOP_MGMT','QM','LAB_HEAD','STAFF','INT_AUDITOR','SAFETY','EXT_AUDITOR')),
  branch_id TEXT REFERENCES branches(id),   -- NULL = ทุกสาขา
  valid_until TEXT,                          -- ใช้กับ EXT_AUDITOR
  PRIMARY KEY (user_id, role, branch_id)
);

CREATE TABLE trainings (                   -- ข้อ 17, 41, 89
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  kind TEXT NOT NULL CHECK (kind IN ('GENERAL','EQUIPMENT','COMPETENCY','INTERNAL_AUDIT','SAFETY','VACCINE','HEALTH_CHECK','INCIDENT')),
  title TEXT NOT NULL,
  event_date TEXT NOT NULL,
  result TEXT,
  evidence_id TEXT REFERENCES evidence(id),
  next_due TEXT
);

-- ===== มาตรฐาน =====
CREATE TABLE req_sections (
  id TEXT PRIMARY KEY,
  std_code TEXT NOT NULL DEFAULT 'MOPH2568',
  code TEXT NOT NULL,                 -- '1', '2.1', '9.6'
  title TEXT NOT NULL,
  sort INTEGER NOT NULL
);

CREATE TABLE requirements (
  id TEXT PRIMARY KEY,
  std_code TEXT NOT NULL DEFAULT 'MOPH2568',
  item_no INTEGER NOT NULL,           -- 1..90
  section_id TEXT NOT NULL REFERENCES req_sections(id),
  requirement_text TEXT NOT NULL,     -- คอลัมน์ "ข้อกำหนด"
  criteria_text TEXT NOT NULL,        -- คอลัมน์ "เกณฑ์การตรวจประเมิน"
  remark TEXT,                        -- คอลัมน์ "หมายเหตุ"
  na_allowed INTEGER NOT NULL DEFAULT 0,
  frequency_months INTEGER,           -- เช่น 12 สำหรับข้อ 8, 67, 88, 90
  UNIQUE (std_code, item_no)
);

CREATE TABLE req_criteria (             -- เกณฑ์ย่อยที่ต้องมีหลักฐานครบ
  id TEXT PRIMARY KEY,
  requirement_id TEXT NOT NULL REFERENCES requirements(id),
  seq INTEGER NOT NULL,
  text TEXT NOT NULL,
  evidence_kind TEXT CHECK (evidence_kind IN ('PROCEDURE','RECORD','PLAN','REPORT','PHOTO','LICENSE','OTHER'))
);

CREATE TABLE req_branch_scope (
  requirement_id TEXT NOT NULL REFERENCES requirements(id),
  branch_id TEXT NOT NULL REFERENCES branches(id),
  applicable INTEGER NOT NULL DEFAULT 1,
  na_reason TEXT,
  owner_user_id TEXT REFERENCES users(id),
  PRIMARY KEY (requirement_id, branch_id)
);

-- ===== เอกสารและหลักฐาน =====
CREATE TABLE documents (                -- Master List (ข้อ 6-7)
  id TEXT PRIMARY KEY,
  doc_code TEXT UNIQUE NOT NULL,      -- QM-001, QP-LAB-005, WI-LAB-012, FM-...
  title TEXT NOT NULL,
  level TEXT NOT NULL CHECK (level IN ('QM','QP','WI','FM','EXT')),
  branch_id TEXT REFERENCES branches(id),
  owner_user_id TEXT REFERENCES users(id),
  status TEXT NOT NULL CHECK (status IN ('DRAFT','IN_REVIEW','EFFECTIVE','OBSOLETE')),
  current_version_id TEXT,
  next_review_date TEXT               -- ทบทวนอย่างน้อยปีละครั้ง (ข้อ 8)
);

CREATE TABLE document_versions (
  id TEXT PRIMARY KEY,
  document_id TEXT NOT NULL REFERENCES documents(id),
  revision INTEGER NOT NULL,
  change_note TEXT,
  r2_key TEXT NOT NULL,
  sha256 TEXT NOT NULL,
  prepared_by TEXT REFERENCES users(id),
  reviewed_by TEXT REFERENCES users(id),
  approved_by TEXT REFERENCES users(id),
  effective_date TEXT,
  obsoleted_at TEXT,
  retain_until TEXT,                  -- obsoleted_at + 4 ปี (ข้อ 9)
  UNIQUE (document_id, revision),
  CHECK (approved_by IS NULL OR approved_by <> prepared_by)
);

CREATE TABLE evidence (
  id TEXT PRIMARY KEY,
  branch_id TEXT REFERENCES branches(id),
  title TEXT NOT NULL,
  r2_key TEXT,                        -- NULL ได้ ถ้าเป็นหลักฐานที่อ้างถึงเอกสารควบคุม
  document_version_id TEXT REFERENCES document_versions(id),
  sha256 TEXT,
  mime TEXT,
  size_bytes INTEGER,
  period_start TEXT,
  valid_until TEXT,                   -- หลักฐานหมดอายุ = เกณฑ์ย่อยกลับเป็น "ขาด"
  retain_until TEXT,                  -- ≥ 4 ปี (ข้อ 13)
  contains_pii INTEGER NOT NULL DEFAULT 0,  -- จำกัดการเข้าถึง (PDPA, ข้อ 4)
  uploaded_by TEXT NOT NULL REFERENCES users(id),
  uploaded_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE TABLE evidence_links (
  evidence_id TEXT NOT NULL REFERENCES evidence(id),
  requirement_id TEXT NOT NULL REFERENCES requirements(id),
  criterion_id TEXT REFERENCES req_criteria(id),
  PRIMARY KEY (evidence_id, requirement_id, criterion_id)
);

-- ===== การประเมิน =====
CREATE TABLE assessment_templates (
  id TEXT PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,          -- MOPH90, SAFETY55
  name TEXT NOT NULL
);

CREATE TABLE template_items (
  id TEXT PRIMARY KEY,
  template_id TEXT NOT NULL REFERENCES assessment_templates(id),
  item_no INTEGER NOT NULL,
  group_title TEXT,
  text TEXT NOT NULL,
  requirement_id TEXT REFERENCES requirements(id),
  UNIQUE (template_id, item_no)
);

CREATE TABLE assessments (
  id TEXT PRIMARY KEY,
  template_id TEXT NOT NULL REFERENCES assessment_templates(id),
  branch_id TEXT NOT NULL REFERENCES branches(id),
  kind TEXT NOT NULL CHECK (kind IN ('SELF','INTERNAL','EXTERNAL','SAFETY')),
  title TEXT NOT NULL,
  planned_date TEXT,
  lead_auditor_id TEXT REFERENCES users(id),
  status TEXT NOT NULL CHECK (status IN ('PLANNED','IN_PROGRESS','REPORTED','CLOSED')),
  opened_at TEXT, closed_at TEXT,
  reported_to_top_mgmt_at TEXT        -- ข้อ 88
);

CREATE TABLE assessment_items (
  id TEXT PRIMARY KEY,
  assessment_id TEXT NOT NULL REFERENCES assessments(id),
  template_item_id TEXT NOT NULL REFERENCES template_items(id),
  result TEXT CHECK (result IN ('NO_NC','NC','OBS','NA','YES','NO')),  -- YES/NO สำหรับ Safety 55 ข้อ
  finding TEXT,                       -- หลักฐานและรายละเอียดที่ตรวจพบ
  assessed_by TEXT REFERENCES users(id),
  assessed_at TEXT,
  UNIQUE (assessment_id, template_item_id)
);

-- ===== NC / ข้อร้องเรียน / ความเสี่ยง =====
CREATE TABLE nc_records (
  id TEXT PRIMARY KEY,
  nc_no TEXT UNIQUE NOT NULL,         -- NC-2569-001
  branch_id TEXT NOT NULL REFERENCES branches(id),
  source TEXT NOT NULL CHECK (source IN ('EXT_AUDIT','INT_AUDIT','SELF','IQC','EQA','COMPLAINT','EVENT','SAFETY')),
  category TEXT NOT NULL CHECK (category IN ('C','O')),   -- ข้อบกพร่อง / ข้อสังเกต (ข้อ 6.9)
  requirement_id TEXT REFERENCES requirements(id),
  assessment_item_id TEXT REFERENCES assessment_items(id),
  description TEXT NOT NULL,
  immediate_action TEXT,
  impact_assessment TEXT,
  root_cause TEXT,
  corrective_action TEXT,
  owner_user_id TEXT REFERENCES users(id),
  due_date TEXT,
  status TEXT NOT NULL CHECK (status IN ('OPEN','CONTAINED','RCA_DONE','ACTION_DONE','VERIFIED','CLOSED')),
  opened_by TEXT NOT NULL REFERENCES users(id),
  verified_by TEXT REFERENCES users(id),
  closed_at TEXT,
  CHECK (verified_by IS NULL OR verified_by <> owner_user_id)
);

CREATE TABLE complaints (               -- ข้อ 79-80
  id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL REFERENCES branches(id),
  received_at TEXT NOT NULL,
  channel TEXT NOT NULL,              -- LINE OA, โทร, หน้าร้าน, เว็บไซต์
  summary TEXT NOT NULL,
  nc_id TEXT REFERENCES nc_records(id),
  reply_to_complainant TEXT,
  status TEXT NOT NULL
);

CREATE TABLE risks (                    -- ข้อ 82
  id TEXT PRIMARY KEY,
  branch_id TEXT REFERENCES branches(id),
  stage TEXT NOT NULL CHECK (stage IN ('PRE','ANALYTIC','POST','SUPPORT')),
  hazard TEXT NOT NULL,
  likelihood INTEGER CHECK (likelihood BETWEEN 1 AND 5),
  severity INTEGER CHECK (severity BETWEEN 1 AND 5),
  score INTEGER GENERATED ALWAYS AS (likelihood * severity) VIRTUAL,
  control_plan TEXT,
  residual_likelihood INTEGER, residual_severity INTEGER,
  owner_user_id TEXT REFERENCES users(id),
  target_date TEXT,
  review_date TEXT
);

-- ===== เครื่องมือ =====
CREATE TABLE equipment (                -- ข้อ 39-43
  id TEXT PRIMARY KEY,
  branch_id TEXT NOT NULL REFERENCES branches(id),
  asset_code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL, brand TEXT, model TEXT, serial_no TEXT,
  vendor TEXT,
  needs_calibration INTEGER NOT NULL DEFAULT 0,
  needs_backup_power INTEGER NOT NULL DEFAULT 0,  -- ข้อ 32
  status TEXT NOT NULL CHECK (status IN ('IN_USE','OUT_OF_SERVICE','CAL_OVERDUE','RETIRED'))
);

CREATE TABLE equipment_events (
  id TEXT PRIMARY KEY,
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  kind TEXT NOT NULL CHECK (kind IN ('CALIBRATION','MAINTENANCE','REPAIR','VERIFICATION','COMPARISON','MALFUNCTION')),
  parameter TEXT, mpe TEXT,
  due_date TEXT, done_date TEXT,
  result TEXT CHECK (result IN ('PASS','FAIL','PENDING')),
  action_taken TEXT,
  evidence_id TEXT REFERENCES evidence(id)
);

-- ===== ปฏิทินงานตามรอบ / KPI =====
CREATE TABLE task_rules (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,                 -- 'ทบทวนเอกสารประจำปี'
  requirement_id TEXT REFERENCES requirements(id),
  frequency_months INTEGER NOT NULL,
  lead_days INTEGER NOT NULL DEFAULT 30,
  per_branch INTEGER NOT NULL DEFAULT 1,
  default_role TEXT
);

CREATE TABLE compliance_tasks (
  id TEXT PRIMARY KEY,
  rule_id TEXT REFERENCES task_rules(id),
  branch_id TEXT REFERENCES branches(id),
  ref_entity TEXT, ref_id TEXT,        -- เช่น equipment/<id>, documents/<id>
  title TEXT NOT NULL,
  due_date TEXT NOT NULL,
  assignee_user_id TEXT REFERENCES users(id),
  status TEXT NOT NULL CHECK (status IN ('UPCOMING','DUE','OVERDUE','DONE','SKIPPED')),
  done_evidence_id TEXT REFERENCES evidence(id)
);

CREATE TABLE kpis (                     -- ข้อ 85-86
  id TEXT PRIMARY KEY,
  stage TEXT NOT NULL CHECK (stage IN ('PRE','ANALYTIC','POST','MGMT')),
  name TEXT NOT NULL, formula TEXT, unit TEXT,
  target_value REAL, direction TEXT CHECK (direction IN ('>=','<=')),
  review_date TEXT
);

CREATE TABLE kpi_values (
  kpi_id TEXT NOT NULL REFERENCES kpis(id),
  branch_id TEXT NOT NULL REFERENCES branches(id),
  period TEXT NOT NULL,               -- '2026-09'
  value REAL NOT NULL,
  note TEXT,
  PRIMARY KEY (kpi_id, branch_id, period)
);

-- ===== Audit trail (append-only) =====
CREATE TABLE audit_log (
  id TEXT PRIMARY KEY,
  at TEXT NOT NULL,
  user_id TEXT,
  action TEXT NOT NULL,               -- CREATE / UPDATE / DELETE / DOWNLOAD / APPROVE / LOGIN
  entity TEXT NOT NULL, entity_id TEXT NOT NULL,
  before_json TEXT, after_json TEXT,
  ip TEXT, ray_id TEXT
);
CREATE INDEX idx_audit_entity ON audit_log(entity, entity_id);
CREATE INDEX idx_tasks_due ON compliance_tasks(status, due_date);
CREATE INDEX idx_nc_status ON nc_records(branch_id, status);

-- ===== View ความพร้อมรายข้อรายสาขา (หัวข้อ 5) =====
CREATE VIEW v_requirement_readiness AS
SELECT s.branch_id, r.item_no, r.section_id,
       s.applicable,
       COUNT(c.id) AS criteria_total,
       COUNT(DISTINCT CASE WHEN e.id IS NOT NULL THEN c.id END) AS criteria_with_valid_evidence
FROM requirements r
JOIN req_branch_scope s ON s.requirement_id = r.id
LEFT JOIN req_criteria c ON c.requirement_id = r.id
LEFT JOIN evidence_links l ON l.criterion_id = c.id
LEFT JOIN evidence e ON e.id = l.evidence_id
     AND e.deleted_at IS NULL
     AND (e.branch_id = s.branch_id OR e.branch_id IS NULL)
     AND (e.valid_until IS NULL OR e.valid_until >= date('now'))
GROUP BY s.branch_id, r.id;

-- ===== ส่วนเพิ่มเติมจาก spec: บังคับกติกาบันทึกคุณภาพอิเล็กทรอนิกส์ที่ระดับ DB =====
-- audit_log เป็น append-only (ข้อ 12, 57): ห้าม UPDATE / DELETE
CREATE TRIGGER trg_audit_log_no_update BEFORE UPDATE ON audit_log
BEGIN SELECT RAISE(ABORT, 'audit_log is append-only'); END;
CREATE TRIGGER trg_audit_log_no_delete BEFORE DELETE ON audit_log
BEGIN SELECT RAISE(ABORT, 'audit_log is append-only'); END;

-- หลักฐานลบจริงไม่ได้ ใช้ deleted_at (soft delete) และไฟล์ R2 ห้ามเปลี่ยน key/hash
CREATE TRIGGER trg_evidence_no_delete BEFORE DELETE ON evidence
BEGIN SELECT RAISE(ABORT, 'evidence uses soft delete'); END;
CREATE TRIGGER trg_evidence_file_immutable BEFORE UPDATE OF r2_key, sha256 ON evidence
WHEN OLD.r2_key IS NOT NEW.r2_key OR OLD.sha256 IS NOT NEW.sha256
BEGIN SELECT RAISE(ABORT, 'evidence file is immutable; upload a new evidence row'); END;

CREATE INDEX idx_evidence_branch ON evidence(branch_id, deleted_at);
CREATE INDEX idx_evidence_links_req ON evidence_links(requirement_id);
CREATE INDEX idx_evidence_links_crit ON evidence_links(criterion_id);
CREATE INDEX idx_criteria_req ON req_criteria(requirement_id, seq);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);
