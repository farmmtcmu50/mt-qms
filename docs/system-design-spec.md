# ระบบติดตามและตรวจประเมิน MOPH LAB 2568 — System Design Spec

บริษัท เมดิคอลเทรนด์ จำกัด · Sep 30, 2026 · @Chanat Somboon

## 1. ภาพรวมและขอบเขต

ระบบนี้ (ชื่อทำงาน: **MT-QMS**) คือ Web App บน Cloudflare ที่ผูก **ข้อกำหนด 90 ข้อ → หลักฐาน → กิจกรรมตามรอบ → ผลประเมิน → การแก้ไข** ให้ตรวจสอบย้อนกลับได้ทุกข้อ เพื่อเตรียมรับการตรวจประเมินตาม "แนวทางการตรวจประเมินมาตรฐานห้องปฏิบัติการทางการแพทย์ กระทรวงสาธารณสุข 2568" (G 0715050 ฉบับปรับปรุงครั้งที่ 3)

**วัตถุประสงค์**

- ประเมินตนเอง (Self-assessment) และตรวจติดตามภายใน (Internal audit) รายสาขา ด้วยผล No NC / NC / Obs / N/A ตามข้อ 6.4 ของแนวทาง
- เก็บหลักฐานทุกชิ้นให้ผูกกับข้อกำหนดและเอกสารควบคุม (Master List) ค้นหาได้ภายในวินาทีในวันตรวจจริง
- ติดตาม NC/Obs จนปิด และส่งออกเป็นรูปแบบ Checklist 8.2.4 และ F 0715093 ได้ทันที
- แจ้งเตือนกิจกรรมที่มาตรฐานกำหนดความถี่ (ทบทวนเอกสาร, audit, MR, สอบเทียบ, EQA, competency)

**ขอบเขต (Scope v1)**

| รายการ | อยู่ใน v1 | หมายเหตุ |
| --- | --- | --- |
| 12 หมวด 90 ข้อ + เกณฑ์ย่อย | ใช่ | Seed จากเอกสาร 8.1 |
| Safety checklist 55 ข้อ (8.2.3) | ใช่ | แยกเป็นแม่แบบ audit อีกชุด |
| 4 สาขา + ห้องอณูชีววิทยา | ใช่ | สาขา = มิติหลักของทุกข้อมูล |
| Master List เอกสาร / ทะเบียนหลักฐาน | ใช่ | ไฟล์เก็บใน R2 |
| NC/CAR, Risk, KPI, MR pack | ใช่ |  |
| บันทึก IQC รายวัน / LIS integration | ไม่ | อ้างอิงลิงก์หรือแนบสรุปรายเดือนแทน |

**หลักการออกแบบ**

1. ข้อกำหนดหนึ่งข้อ "ผ่าน" เมื่อเกณฑ์ย่อยทุกตัวมีหลักฐานที่ยังไม่หมดอายุ
2. ไม่ลบข้อมูลจริง (soft delete) และบันทึกทุกการแก้ไขไว้ใน audit log สอดคล้องกับข้อ 12 และ 57
3. ข้อมูลสาขาแยกด้วยสิทธิ์ ผู้ใช้เห็นเฉพาะสาขาที่ได้รับมอบหมาย
4. Stack เดียวบน Cloudflare: ไม่มีเซิร์ฟเวอร์ให้ดูแล ต้นทุนต่ำสำหรับทีม 1–10 คน

## 2. สถาปัตยกรรมบน Cloudflare

ใช้ Worker ตัวเดียวทำหน้าที่ทั้ง API และเสิร์ฟหน้าเว็บ ผูกกับ subdomain ของบริษัท (`qms.medicaltrend.stream` — ยืนยันแล้ว 21 ต.ค. 2569) โดยมี Cloudflare Access กั้นหน้าประตูก่อนถึง Worker ทุก request

| ส่วนประกอบ | บริการ Cloudflare | หน้าที่ |
| --- | --- | --- |
| ประตูเข้าระบบ | Cloudflare Access (Zero Trust) | ล็อกอินด้วยอีเมลบริษัท (Google / One-time PIN) ก่อนเข้าถึง Worker ส่ง JWT header `Cf-Access-Jwt-Assertion` มาให้ |
| Frontend | Workers Static Assets | SPA (React + Vite) หรือ HTML จาก Hono JSX; ส่งออก Excel/PDF ฝั่ง browser |
| API | Workers (Hono framework, TypeScript) | ตรวจ JWT → หาผู้ใช้ใน D1 → ตรวจสิทธิ์สาขา → ทำงาน → เขียน audit log |
| ฐานข้อมูล | D1 (SQLite) | ข้อกำหนด, ผลประเมิน, NC, เอกสาร, ปฏิทิน, audit log |
| ไฟล์หลักฐาน | R2 bucket (private) | PDF, รูปถ่ายหน้างาน, Excel บันทึก; ดาวน์โหลดผ่าน Worker เท่านั้น |
| งานตามรอบ | Cron Triggers | ทุกเช้า 07:00 (Asia/Bangkok) สร้างรายการครบกำหนดและส่งแจ้งเตือน |
| แจ้งเตือน | Email (Email Routing `send_email` หรือผู้ให้บริการภายนอก) / LINE Messaging API | สรุปงานครบกำหนด NC ใกล้เลยกำหนด |
| สำรองข้อมูล | D1 Time Travel + Cron export ไป R2 | กู้คืนได้ย้อนหลัง 30 วัน + snapshot รายสัปดาห์เก็บระยะยาว |

**เหตุผลที่ใช้ Cloudflare Access แทนการทำระบบ login เอง:** ไม่ต้องเก็บรหัสผ่านใน D1, บังคับ MFA/จำกัดโดเมนอีเมลได้จาก dashboard และแผน Zero Trust ฟรีรองรับผู้ใช้ได้เพียงพอสำหรับบริษัทขนาด 1–10 คน (ควรตรวจเงื่อนไขแผนปัจจุบันก่อนใช้งานจริง)

**Flow ของหนึ่ง request:** ผู้ใช้ → Access (ยืนยันตัวตน) → Worker middleware (ตรวจ JWT กับ team domain + AUD tag) → โหลด user + role + สาขา → handler → D1/R2 → เขียน `audit_log` → ตอบกลับ

## 3. บทบาทผู้ใช้และสิทธิ์ (RBAC)

สิทธิ์กำหนดเป็นคู่ **(บทบาท, สาขา)** ผู้ใช้คนหนึ่งมีได้หลายคู่ เช่น เป็น Section Staff ที่บ่อสร้าง และเป็น Internal Auditor ที่หางดง

| บทบาท | ตัวอย่างผู้รับผิดชอบ | ทำอะไรได้ | ข้อจำกัดที่ระบบบังคับ |
| --- | --- | --- | --- |
| Top Management | กรรมการผู้จัดการ | ดูทุกสาขา, อนุมัตินโยบาย/คู่มือคุณภาพ, ปิด Management Review | — |
| Quality Manager | ผู้จัดการคุณภาพ | จัดการข้อกำหนด, เอกสาร, แผน audit, ปิด NC ทุกสาขา | — |
| Lab Head (สาขา) | หัวหน้าห้องปฏิบัติการ | ประเมินตนเอง, อนุมัติเอกสารระดับ WI, รับ NC ของสาขา | เฉพาะสาขาที่ได้รับมอบหมาย |
| Section Staff | นักเทคนิคการแพทย์ | อัปโหลดหลักฐาน, บันทึกกิจกรรม, แก้ไข CAR ที่ได้รับมอบ | ไม่อนุมัติเอกสารของตนเอง |
| Internal Auditor | ผู้ผ่านอบรม internal audit | บันทึกผลตรวจ, เปิด NC/Obs | **ห้ามตรวจพื้นที่/กิจกรรมที่ตนรับผิดชอบ** (ข้อ 89) และต้องมีหลักฐานการอบรมในระบบ |
| Safety Officer | ผู้รับผิดชอบความปลอดภัย | ทำ Safety checklist 55 ข้อ, บันทึกอุบัติการณ์ | ต้องมีหนังสือแต่งตั้งในระบบ (ข้อ 65) |
| External Auditor (ชั่วคราว) | ผู้ตรวจจาก สมป. | อ่านอย่างเดียว เฉพาะข้อกำหนด/หลักฐานของรอบตรวจ | สิทธิ์หมดอายุอัตโนมัติ, ทุกการเปิดไฟล์ถูกบันทึก |

**กติกาเชิงระบบ**

- Segregation of duties: ผู้จัดทำเอกสาร ≠ ผู้อนุมัติ, ผู้เปิด NC ≠ ผู้ปิด NC
- ผู้ตรวจภายในจะถูกกรองออกจากตัวเลือก เมื่อ `auditee_area` ตรงกับพื้นที่ที่ตนเป็นเจ้าของ
- สิทธิ์ External Auditor สร้างเป็น Access policy ชั่วคราวผูกอีเมล + วันหมดอายุ ไม่ต้องเพิ่มบัญชีถาวร

## 4. โมดูลระบบและการ map กับ MOPH LAB 2568

ระบบมี 11 โมดูล ทุกโมดูลเขียนหลักฐานกลับเข้า **Requirement Master** เพื่อให้ผลของแต่ละข้อคำนวณจากข้อมูลจริง ไม่ใช่การติ๊กด้วยมือ

| # | โมดูล | ครอบคลุมข้อ MOPH | ฟีเจอร์หลัก |
| --- | --- | --- | --- |
| M1 | Requirement Master | 1–90 ทั้งหมด | 12 หมวด / 90 ข้อ / เกณฑ์ย่อย, หลักฐานที่ต้องมี, ความถี่, กติกา N/A (ข้อ 23, 24, 25, 58, 77), ผู้รับผิดชอบรายสาขา |
| M2 | Document Control & Master List | 6–10 | ทะเบียนเอกสาร (QM/QP/WI/FM), ฉบับ/วันประกาศ, วงจร ร่าง → ทบทวน → อนุมัติ → แจกจ่าย → ยกเลิก, แจ้งทบทวนรายปี, เก็บฉบับยกเลิก ≥ 4 ปี |
| M3 | Records & Evidence | 11–14, 59 | อัปโหลดหลักฐานลง R2 ผูกกับข้อกำหนด, version ไฟล์ไม่ทับของเดิม, วันหมดอายุ/รอบทบทวน, ระยะเก็บรักษา |
| M4 | Personnel | 15–19, 74 | แฟ้มบุคลากร (การศึกษา, ใบประกอบวิชาชีพ + วันหมดอายุ, วัคซีน, ตรวจสุขภาพ, อุบัติเหตุ), Training need/แผนอบรม, Competency plan & ผล |
| M5 | Facility & Environment | 20–32 | ผังพื้นที่รายสาขา, บันทึกอุณหภูมิ/ความชื้นสรุปรายเดือน + การแก้ไขเมื่อออกนอกเกณฑ์, รายการเครื่องที่ต้องมีไฟสำรอง |
| M6 | Supplier & Referral Lab | 33–38 | ทะเบียนผู้ขาย/ผู้ให้บริการ (สอบเทียบ, EQA, LIS, แล็บส่งต่อ), เกณฑ์คัดเลือก, ประเมินรายปี, บันทึกตรวจรับน้ำยาทุก lot/shipment |
| M7 | Equipment & Reagent | 39–44, 54, 64 | ทะเบียนเครื่องมือ (รหัส/รุ่น/S/N), แผนสอบเทียบ-บำรุงรักษา + MPE, สถานะเครื่อง, Method verification report, เปรียบเทียบผลระหว่างเครื่อง/สาขา ≥ ปีละครั้ง |
| M8 | Process & Quality Assurance | 45–64 | คู่มือบริการ/คู่มือเก็บสิ่งส่งตรวจ (เช็คครบหัวข้อ), IQC สรุปรายเดือน + การแก้ไข, EQA ต่อรอบ (ผูกผลแปล EQAS เดิมได้) |
| M9 | Safety | 65–78 | Safety checklist 55 ข้อ (8.2.3), แผนอัคคีภัย, ทะเบียนสารเคมี + SDS, spill kit/อุปกรณ์ล้างตา สุ่มตรวจความพร้อม |
| M10 | Events: Complaint / NC / Risk | 79–82 | ข้อร้องเรียน, NC event → CAR (บันทึก → แก้ไขเบื้องต้น → RCA → มาตรการ → ติดตาม → ปิด), Risk register + Risk matrix |
| M11 | Improvement & Evaluation | 83–90 | แผนพัฒนา, สำรวจความพึงพอใจ, KPI + เป้าหมาย, Internal audit (แผน/ผล/ผู้ตรวจ), Management Review pack 12 หัวข้อ |

สองโมดูลที่ใช้งานข้ามทุกโมดูล:

- **Assessment Engine**: สร้างรอบประเมินจากแม่แบบ (MOPH 90 ข้อ หรือ Safety 55 ข้อ) รายสาขา ผลต่อข้อ = No NC / NC / Obs / N/A พร้อมช่องหลักฐานที่ตรวจพบ ตรงกับหน้าตา Checklist 8.2.4
- **Compliance Calendar**: รวมทุกกิจกรรมที่มีความถี่ (ดูหัวข้อ 8) แสดงเป็นปฏิทินและรายการครบกำหนด

## 5. โครงสร้างฐานข้อมูล D1

ใช้ id แบบ ULID (TEXT) ทุกตาราง, เวลาเก็บเป็น ISO 8601 (UTC) และแสดงผลเป็นเวลาไทย, ไม่ลบจริงแต่ใช้ `deleted_at` ตารางแบ่งเป็น 6 กลุ่มดังนี้

| กลุ่ม | ตาราง |
| --- | --- |
| องค์กร/ผู้ใช้ | `branches`, `users`, `user_roles`, `trainings` |
| มาตรฐาน | `req_sections`, `requirements`, `req_criteria`, `req_branch_scope` |
| เอกสาร/หลักฐาน | `documents`, `document_versions`, `evidence`, `evidence_links` |
| การประเมิน | `assessment_templates`, `template_items`, `assessments`, `assessment_items` |
| เหตุการณ์/ติดตาม | `nc_records`, `complaints`, `risks`, `equipment`, `equipment_events`, `task_rules`, `compliance_tasks`, `kpis`, `kpi_values` |
| ระบบ | `audit_log` |

**Migration 0001 (ตารางหลัก)**

```sql
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
```

**View สำหรับความพร้อม (Readiness) รายข้อรายสาขา**

```sql
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
```

กติกาแสดงผล: ครบทุกเกณฑ์ย่อย = พร้อม, ขาดบางส่วน = เสี่ยง Obs, ไม่มีหลักฐานเลย = เสี่ยง NC

## 6. การจัดเก็บไฟล์หลักฐานบน R2

Bucket เป็น private ทั้งหมด ไม่เปิด public URL ทุกการอัปโหลดและดาวน์โหลดวิ่งผ่าน Worker เพื่อตรวจสิทธิ์และบันทึก `audit_log` ไฟล์ไม่ถูกเขียนทับ ทุกครั้งที่อัปโหลดใหม่ได้ key ใหม่

**Bucket และโครงสร้าง key**

| Bucket | ใช้เก็บ | รูปแบบ key |
| --- | --- | --- |
| `mt-qms-docs` | เอกสารควบคุม (QM/QP/WI/FM) ทุก revision | `docs/{doc_code}/rev{NN}/{ulid}.pdf` |
| `mt-qms-evidence` | หลักฐาน/บันทึก/รูปถ่าย | `evidence/{branch_code}/{yyyy}/{mm}/{ulid}-{slug}.{ext}` |
| `mt-qms-evidence` | ไฟล์แนบ NC/CAR | `nc/{nc_no}/{ulid}.{ext}` |
| `mt-qms-backup` | D1 export รายสัปดาห์ | `d1/{yyyy-mm-dd}.sql.gz` |

**ขั้นตอนอัปโหลด**

1. Client ส่งไฟล์ (multipart) พร้อม `requirement_id`, `criterion_id`, `branch_id`, `valid_until`
2. Worker ตรวจสิทธิ์สาขา, ชนิดไฟล์ (PDF, JPG, PNG, XLSX, DOCX) และขนาด (เสนอไม่เกิน 25 MB ต่อไฟล์)
3. คำนวณ SHA-256 → `put` ลง R2 พร้อม `customMetadata` (uploader, branch, sha256)
4. เขียนแถว `evidence` + `evidence_links` + `audit_log` ใน `db.batch()` เดียวกัน

**ดาวน์โหลด:** `GET /api/files/:evidenceId` → ตรวจสิทธิ์ → stream จาก R2 ด้วย `Content-Disposition` และบันทึก action `DOWNLOAD` (สำคัญมากกับบัญชีผู้ตรวจภายนอก)

**ระยะเก็บรักษา:** ใช้คอลัมน์ `retain_until` (≥ 4 ปี ตามข้อ 9 และ 13) เป็นตัวตัดสิน ห้ามลบก่อนวันนั้น และให้ Cron รายเดือนสร้างรายการ "ครบกำหนดทำลาย" ให้ QM อนุมัติ แทนการตั้ง lifecycle rule ลบอัตโนมัติ

**ข้อมูลผู้ป่วย:** หลักฐานควรเป็นเอกสารระบบ ไม่ใช่รายงานผลรายบุคคล หากจำเป็นต้องแนบ (เช่น ตัวอย่างใบรายงานผลที่แก้ไข ข้อ 57) ให้ปิดชื่อ/HN ก่อนอัปโหลด และติดธง `contains_pii` เพื่อจำกัดการเข้าถึงตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล (ข้อ 4)

## 7. API endpoints

REST + JSON ใต้ `/api/v1` ทุก endpoint ผ่าน middleware 3 ชั้น: `accessAuth` (ตรวจ JWT) → `loadUser` (role + สาขา) → `requireRole(...)` และทุกการเขียนผ่าน `withAudit()` ที่บันทึก before/after อัตโนมัติ

| กลุ่ม | Method & Path | บทบาทที่ใช้ได้ |
| --- | --- | --- |
| ผู้ใช้ | `GET /me` | ทุกคน |
| ข้อกำหนด | `GET /requirements?branch=&section=` · `GET /requirements/:id` (พร้อมเกณฑ์ย่อย + หลักฐาน + สถานะ) | ทุกคน |
| ข้อกำหนด | `PATCH /requirements/:id/scope/:branchId` (applicable, N/A reason, owner) | QM |
| เอกสาร | `GET /documents` · `POST /documents` · `POST /documents/:id/versions` · `POST /documents/:id/versions/:v/approve` · `POST /documents/:id/obsolete` | STAFF ขึ้นไป / อนุมัติ: LAB\_HEAD, QM |
| หลักฐาน | `POST /evidence` (multipart) · `GET /files/:evidenceId` · `POST /evidence/:id/links` · `DELETE /evidence/:id` (soft) | STAFF ขึ้นไป; EXT\_AUDITOR อ่านอย่างเดียว |
| การประเมิน | `POST /assessments` (template, branch, kind) · `GET /assessments/:id` · `PUT /assessments/:id/items/:itemId` · `POST /assessments/:id/report` · `POST /assessments/:id/close` | INT\_AUDITOR, LAB\_HEAD (SELF), SAFETY |
| NC/CAR | `GET /nc?status=&branch=` · `POST /nc` · `PATCH /nc/:id` · `POST /nc/:id/verify` · `POST /nc/:id/close` | เปิด: ทุกคน; verify/close: QM |
| เครื่องมือ | `GET/POST /equipment` · `POST /equipment/:id/events` | STAFF ขึ้นไป |
| ความเสี่ยง | `GET/POST/PATCH /risks` | LAB\_HEAD, QM |
| ปฏิทิน | `GET /tasks?from=&to=&branch=` · `POST /tasks/:id/done` (แนบ evidence) | ทุกคน |
| KPI | `GET /kpis` · `PUT /kpis/:id/values/:branch/:period` | LAB\_HEAD, QM |
| Dashboard | `GET /dashboard/readiness?branch=` · `GET /dashboard/overview` | ทุกคน (ตามสาขา) |
| รายงาน | `GET /reports/checklist-8-2-4/:assessmentId.xlsx` · `GET /reports/f0715093/:assessmentId.xlsx` · `GET /reports/mr-pack?year=` · `GET /reports/master-list.xlsx` | QM, TOP\_MGMT |
| Audit log | `GET /audit-log?entity=&id=` | QM, TOP\_MGMT |

**ตัวอย่าง middleware ตรวจ Cloudflare Access JWT (Hono)**

```ts
import { createRemoteJWKSet, jwtVerify } from 'jose';

export const accessAuth = async (c, next) => {
  const token = c.req.header('Cf-Access-Jwt-Assertion');
  if (!token) return c.json({ error: 'unauthorized' }, 401);
  const JWKS = createRemoteJWKSet(new URL(`${c.env.ACCESS_TEAM_DOMAIN}/cdn-cgi/access/certs`));
  const { payload } = await jwtVerify(token, JWKS, {
    issuer: c.env.ACCESS_TEAM_DOMAIN,
    audience: c.env.ACCESS_AUD,
  });
  c.set('email', String(payload.email).toLowerCase());
  await next();
};
```

## 8. Workflow หลัก

### 8.1 รอบประเมิน (Self-assessment / Internal audit)

1. QM สร้างรอบประเมินจากแม่แบบ `MOPH90` เลือกสาขาและผู้ตรวจนำ ระบบกรองผู้ตรวจที่เป็นเจ้าของพื้นที่นั้นออก (ข้อ 89)
2. ระบบสร้าง `assessment_items` 90 แถว ข้อที่ตั้งเป็น N/A ในสาขานั้นถูกเติมผล `NA` ล่วงหน้าพร้อมเหตุผล
3. หน้าประเมินแต่ละข้อแสดงข้อกำหนด เกณฑ์ หมายเหตุ เกณฑ์ย่อย และหลักฐานที่ผูกไว้พร้อมสถานะหมดอายุ ผู้ตรวจเลือก No NC / NC / Obs / N/A และพิมพ์ "หลักฐานและรายละเอียดที่ตรวจพบ"
4. เลือก NC หรือ Obs → ระบบสร้าง `nc_records` (category C หรือ O) อัตโนมัติ ผูกกับข้อกำหนดและรายการประเมิน
5. สรุปผล: นับ NC / Obs / N/A รายหมวดทั้ง 12 หมวด (ข้อ 6.5 ของแนวทาง) → Closing meeting → ส่งรายงานผู้บริหารสูงสุด บันทึก `reported_to_top_mgmt_at` (ข้อ 88)
6. ปิดรอบได้เมื่อทุกข้อมีผล

Safety checklist 55 ข้อ ใช้ flow เดียวกันด้วยแม่แบบ `SAFETY55` ผลเป็น มี/ไม่มี และ "ไม่มี" สร้าง NC หมวดความปลอดภัย

### 8.2 NC / CAR

สถานะเดินตามลำดับ **OPEN → CONTAINED (แก้ไขเบื้องต้น) → RCA\_DONE (วิเคราะห์สาเหตุ + ประเมินผลกระทบ) → ACTION\_DONE (ดำเนินมาตรการ + แนบหลักฐาน) → VERIFIED (QM ตรวจประสิทธิผล) → CLOSED** ถ้า QM ตรวจแล้วไม่ได้ผล สถานะย้อนกลับไป RCA\_DONE ข้อมูลนี้ส่งออกเป็นตาราง F 0715093 ได้ตรง ๆ

กติกา: NC ประเภท C ต้องกำหนด `due_date` ภายใน 7 วันหลังเปิด, ระบบแจ้งเตือนก่อนครบกำหนด 3 วัน และทุกวันเมื่อเลยกำหนด

### 8.3 เอกสารควบคุม

ร่าง (STAFF) → ทบทวน (LAB\_HEAD) → อนุมัติ (QM / TOP\_MGMT สำหรับ QM-level) → EFFECTIVE พร้อมตั้ง `next_review_date` = +12 เดือน → ฉบับเก่าเปลี่ยนเป็น OBSOLETE, ขึ้นลายน้ำ "ยกเลิก" เมื่อดาวน์โหลด และ `retain_until` = +4 ปี

### 8.4 Compliance Calendar (ค่าเริ่มต้นของ `task_rules`)

Cron รายวันอ่านกฎเหล่านี้ สร้าง `compliance_tasks` ล่วงหน้าตาม `lead_days` และเปลี่ยนสถานะเป็น DUE / OVERDUE อัตโนมัติ

| กิจกรรม | ข้อ MOPH | ความถี่ | ต่อสาขา | ผู้รับผิดชอบเริ่มต้น |
| --- | --- | --- | --- | --- |
| ทบทวนเอกสารคุณภาพ | 8 | 12 เดือน (ต่อเอกสาร) | — | เจ้าของเอกสาร |
| ประเมิน Competency | 18 | ตามแผน (เสนอ 12 เดือน) | ใช่ | LAB\_HEAD |
| ตรวจสุขภาพ + ทบทวนวัคซีนบุคลากร | 19, 74 | 12 เดือน | ใช่ | QM |
| ต่ออายุใบประกอบวิชาชีพ / ใบอนุญาตสถานพยาบาล | 1, 19 | ตามวันหมดอายุ | ใช่ | QM |
| ประเมินผู้ขาย/ผู้ให้บริการ/แล็บส่งต่อ | 36, 38 | 12 เดือน | — | QM |
| สอบเทียบ / บำรุงรักษาเครื่องมือ | 42 | ตามแผนรายเครื่อง | ใช่ | STAFF |
| EQA ตามรอบของ Provider | 63 | ตามตาราง Provider | ใช่ | STAFF |
| เปรียบเทียบผลระหว่างเครื่อง/สาขา | 64 | 12 เดือน | — | QM |
| สำรวจความพึงพอใจผู้รับบริการ | 84 | ตามที่กำหนด (เสนอ 6 เดือน) | ใช่ | LAB\_HEAD |
| ทบทวนตัวชี้วัด | 86 | 6 เดือน (เสนอ) | — | QM |
| ทบทวนความเสี่ยง | 82 | 12 เดือน | ใช่ | LAB\_HEAD |
| Safety audit 55 ข้อ | 67 | 12 เดือน | ใช่ | SAFETY |
| Internal audit 90 ข้อ | 87, 88 | 12 เดือน | ใช่ | QM |
| Management Review | 90 | 12 เดือน | — | TOP\_MGMT |

### 8.5 Management Review pack (ข้อ 90)

ปุ่มเดียวสร้างวาระประชุม 12 หัวข้อ โดยดึงข้อมูลจริงจากระบบ: มาตรการจาก MR ครั้งก่อน, นโยบาย/วัตถุประสงค์, KPI เทียบเป้า, การเปลี่ยนแปลงปริมาณงาน/บุคลากร/สถานที่, สรุปความเสี่ยง, ข้อร้องเรียน/NC/CA, ผล internal audit ล่าสุด, ผลตรวจจากองค์กรภายนอก, สรุป IQC/EQA, ผลความพึงพอใจ, ความคืบหน้าแผนพัฒนาและแผนอบรม, ความต้องการทรัพยากร แล้วบันทึกมติเป็น action items ที่กลายเป็น `compliance_tasks`

## 9. Dashboard, KPI และรายงานส่งออก

หน้าแรกตอบคำถามเดียว: **"ถ้าผู้ตรวจมาพรุ่งนี้ สาขาไหนเสี่ยงข้อไหน"**

**ตัวชี้วัดบน Dashboard**

| ตัวชี้วัด | สูตร | แสดงแบบ |
| --- | --- | --- |
| Readiness % | ข้อที่หลักฐานครบ ÷ (90 − ข้อ N/A) | รายสาขา + รายหมวด (heatmap 12 หมวด × สาขา) |
| Assessment score (รอบล่าสุด) | ข้อ No NC ÷ (90 − N/A) | รายสาขา เทียบรอบก่อน |
| NC/Obs ค้าง | นับตามสถานะ + อายุ (วัน) | แยก C / O, แดงเมื่อเลยกำหนด |
| หลักฐานใกล้หมดอายุ | `valid_until` ภายใน 30 วัน | รายการ + ผู้รับผิดชอบ |
| งานตามรอบ | DUE / OVERDUE ใน 30 วัน | ปฏิทิน + รายการ |
| เครื่องมือเลยกำหนดสอบเทียบ | `CAL_OVERDUE` | รายสาขา |
| KPI เทียบเป้า | จาก `kpi_values` | trend รายเดือน แยก Pre / Analytic / Post |

**KPI ตั้งต้นที่แนะนำ (ข้อ 85)** — ปรับเป้าให้ตรงนโยบายคุณภาพของบริษัท

- Pre-analytic: อัตราปฏิเสธสิ่งส่งตรวจ, อัตราใบขอส่งตรวจข้อมูลไม่ครบ, อัตราระบุตัวผิดพลาด
- Analytic: % IQC ผ่านเกณฑ์, % EQA ผ่านเกณฑ์, อัตราเครื่องมือหยุดใช้งาน
- Post-analytic: TAT ตามเป้า (ปกติ/ด่วน), % รายงานค่าวิกฤตภายในเวลาที่กำหนด, อัตราการแก้ไขรายงานผล
- Management: ข้อร้องเรียนต่อ 1,000 ราย, คะแนนความพึงพอใจ, % NC ปิดตามกำหนด

**รายงานส่งออก**

| รายงาน | อ้างอิง | รูปแบบ |
| --- | --- | --- |
| แบบตรวจประเมิน (Assessment Checklist) ส่วนที่ 1–3 | 8.2.4 | XLSX / PDF ตามคอลัมน์ ข้อ · รายละเอียด · เอกสาร/หลักฐาน · No NC · NC · Obs · N/A · หลักฐานที่ตรวจพบ |
| ตารางสรุปผลการแก้ไขสิ่งที่ตรวจพบ | F 0715093 | XLSX จาก `nc_records` ของรอบนั้น |
| สรุปผลตรวจรายหมวด | ข้อ 6.5 ของแนวทาง | ตาราง 12 หมวด: จำนวนข้อ / NC / Obs / N/A |
| Safety checklist | 8.2.3 | XLSX / PDF |
| Master List เอกสารควบคุม | ข้อ 6–7 | XLSX (รูปแบบเดียวกับ Master List ที่ใช้อยู่) |
| Management Review pack | ข้อ 90 | DOCX / PDF |
| Evidence binder รายข้อ | ทั้งหมด | ZIP ของไฟล์หลักฐานเรียงโฟลเดอร์ตามเลขข้อ สำหรับส่ง สมป. ก่อนตรวจ (ข้อ 6.2 ของแนวทาง) |

XLSX สร้างฝั่ง browser ด้วย SheetJS เพื่อไม่ใช้ CPU ของ Worker, ZIP สร้างใน Worker แบบ stream จาก R2

## 10. ความปลอดภัย, Audit trail, PDPA และการสำรองข้อมูล

ระบบนี้เองจะถูกตรวจในฐานะ "บันทึกคุณภาพแบบอิเล็กทรอนิกส์" ตามข้อ 10–12 และ 59 จึงต้องพิสูจน์ได้ว่า ป้องกันการเข้าถึงโดยไม่ได้รับอนุญาต, ย้อนดูข้อมูลเดิมก่อนแก้ได้ และมีการสำรองข้อมูล

| ความต้องการ | ข้อ MOPH | วิธีทำในระบบ |
| --- | --- | --- |
| ป้องกันการเข้าถึง/แก้ไขโดยผู้ไม่ได้รับอนุญาต | 10, 14, 59 | Cloudflare Access + จำกัดโดเมนอีเมลบริษัท + MFA; RBAC รายสาขาใน Worker; R2 private |
| แก้ไขแล้วสืบกลับข้อมูลเดิมได้ ระบุวันเวลาและผู้แก้ | 12, 57 | `audit_log` เก็บ before/after JSON ทุกการเขียน; ไม่มี endpoint แก้/ลบ `audit_log`; ไฟล์ R2 ไม่เขียนทับ |
| สำรองข้อมูลอิเล็กทรอนิกส์ | 11, 59 | D1 Time Travel (กู้คืนระดับนาทีย้อนหลัง 30 วัน) + Cron รายสัปดาห์ export D1 ลง `mt-qms-backup` |
| กำหนดระยะเวลาเก็บรักษา | 9, 13 | `retain_until` ≥ 4 ปี, ทำลายต้องผ่านการอนุมัติ QM และบันทึก |
| ความลับของข้อมูลผู้ป่วย | 4 | ไม่เก็บผลรายบุคคลเป็นหลัก, ธง `contains_pii` จำกัดเฉพาะ QM/LAB\_HEAD, log การเปิดทุกครั้ง |
| ผู้ตรวจภายนอกเข้าถึงชั่วคราว | 6.1–6.3 ของแนวทาง | Access policy รายอีเมลมีวันหมดอายุ + role EXT\_AUDITOR อ่านอย่างเดียว |

**ข้อควรระวังทางเทคนิค**

- ตรวจ JWT ใน Worker ทุก request แม้มี Access อยู่หน้าประตู (ป้องกันการเรียกผ่าน `*.workers.dev`) และปิด `workers_dev` ใน config
- การเขียนหลายตารางใช้ `env.DB.batch([...])` เพื่อให้สำเร็จหรือล้มเหลวพร้อมกัน (atomic)
- `audit_log` เติบโตเร็ว: เสนอย้าย log ที่เก่ากว่า 12 เดือนไปเก็บเป็นไฟล์ใน R2 รายเดือน เพื่อคุมขนาด D1 (จำกัดต่อฐานข้อมูล ตรวจสอบขีดจำกัดปัจจุบันก่อนใช้งาน)
- ตั้ง Content-Security-Policy และ rate limit (WAF rule) บน subdomain
- เก็บค่า `ACCESS_AUD`, token แจ้งเตือน LINE ไว้ใน Wrangler secrets ไม่ commit ลง Git

## 11. Wrangler config, โครงสร้างโปรเจกต์ และการ deploy

**โครงสร้างโปรเจกต์ (monorepo เดียว)**

```text
mt-qms/
├── wrangler.jsonc
├── migrations/
│   ├── 0001_init.sql            # ตารางตามหัวข้อ 5
│   ├── 0002_seed_moph2568.sql   # 12 หมวด / 90 ข้อ / เกณฑ์ย่อย
│   ├── 0003_seed_safety55.sql   # Safety checklist 8.2.3
│   └── 0004_seed_branches_rules.sql  # 4 สาขา + task_rules
├── src/
│   ├── index.ts                 # Hono app + scheduled()
│   ├── middleware/ (accessAuth, loadUser, requireRole, withAudit)
│   ├── routes/ (requirements, documents, evidence, assessments, nc, equipment, risks, tasks, kpis, reports)
│   ├── cron/ (dailyTasks, weeklyBackup, notify)
│   └── lib/ (ulid, r2, db, dates-th)
├── web/                         # React + Vite → build ไปที่ web/dist
└── test/                        # vitest + @cloudflare/vitest-pool-workers
```

**wrangler.jsonc**

```jsonc
{
  "name": "mt-qms",
  "main": "src/index.ts",
  "compatibility_date": "2026-09-01",
  "workers_dev": false,
  "routes": [
    { "pattern": "qms.medicaltrend.stream", "custom_domain": true }
  ],
  "assets": {
    "directory": "./web/dist",
    "binding": "ASSETS",
    "not_found_handling": "single-page-application",
    "run_worker_first": ["/api/*"]
  },
  "d1_databases": [
    { "binding": "DB", "database_name": "mt-qms-db", "database_id": "<ใส่หลังสร้าง>", "migrations_dir": "migrations" }
  ],
  "r2_buckets": [
    { "binding": "DOCS", "bucket_name": "mt-qms-docs" },
    { "binding": "EVIDENCE", "bucket_name": "mt-qms-evidence" },
    { "binding": "BACKUP", "bucket_name": "mt-qms-backup" }
  ],
  "triggers": {
    "crons": ["0 0 * * *", "0 19 * * SUN"]   // 07:00 น. ทุกวัน และ 02:00 น. เช้าวันจันทร์ (เวลาไทย)
  },
  "vars": {
    "ACCESS_TEAM_DOMAIN": "https://<team>.cloudflareaccess.com",
    "APP_TZ": "Asia/Bangkok"
  },
  "observability": { "enabled": true }
}
```

**คำสั่งตั้งค่าครั้งแรก**

```bash
npm create cloudflare@latest mt-qms          # เลือก Hono template
npx wrangler d1 create mt-qms-db
npx wrangler r2 bucket create mt-qms-docs
npx wrangler r2 bucket create mt-qms-evidence
npx wrangler r2 bucket create mt-qms-backup
npx wrangler secret put ACCESS_AUD
npx wrangler secret put LINE_CHANNEL_TOKEN
npx wrangler d1 migrations apply mt-qms-db --local    # ทดสอบในเครื่อง
npx wrangler d1 migrations apply mt-qms-db --remote   # ขึ้น production
npm run build --prefix web && npx wrangler deploy
```

**ขั้นตอนใน Cloudflare Dashboard**

1. Zero Trust → Access → Applications → Self-hosted: `qms.medicaltrend.stream`
2. Login method: One-time PIN — Policy: Allow ระบุรายอีเมล (Emails) ของทีมงาน (+ policy แยกสำหรับผู้ตรวจภายนอก ตั้งวันหมดอายุ)
3. คัดลอก AUD tag ไปใส่ secret `ACCESS_AUD`
4. แนะนำแยก environment `staging` (D1/R2 ชุดแยก) ก่อนเปิดใช้งานจริง และ deploy ผ่าน GitHub Actions + `wrangler deploy --env production`

## 12. แผนพัฒนาเป็นระยะและประเด็นที่ต้องตัดสินใจ

เริ่มจากส่วนที่ให้คุณค่าทันที คือ Requirement Master + หลักฐาน เพราะผล gap assessment รอบแรกจะบอกว่าสาขาใดและหมวดใดต้องเร่ง

**แผนพัฒนา 4 ระยะ (แต่ละระยะมีเกณฑ์ผ่าน · Gate)**

1. **ระยะที่ 1 · ฐานข้อมูลมาตรฐานและหลักฐาน** — Cloudflare Access, D1 schema, seed 12 หมวด / 90 ข้อ + เกณฑ์ย่อย, 4 สาขา (M1); อัปโหลดหลักฐานลง R2 ผูกข้อกำหนด (M3), Readiness view, audit log
    - Gate: Gap assessment รอบแรกครบทุกสาขา
2. **ระยะที่ 2 · การประเมินและ NC/CAR** — Assessment engine (MOPH90, SAFETY55), NC/CAR workflow (M10); ส่งออก Checklist 8.2.4 และ F 0715093
    - Gate: Internal audit รอบแรกทำบนระบบ และปิด NC ได้ครบวงจร
3. **ระยะที่ 3 · งานปฏิบัติการประจำ** — Document control + Master List (M2), บุคลากร (M4), ผู้ขาย (M6), เครื่องมือ/น้ำยา (M7), Safety (M9); Compliance Calendar + Cron แจ้งเตือน Email / LINE
    - Gate: ปฏิทินงานครบ 14 กฎ และไม่มีงานเลยกำหนดค้าง
4. **ระยะที่ 4 · ประเมินผลและพร้อมยื่นรับรอง** — KPI + เป้าหมาย, Risk register, Management Review pack 12 หัวข้อ (M11); Dashboard รายสาขา, Evidence binder ZIP
    - Gate: Management Review ครบ แล้วยื่นขอรับรอง MOPH LAB

ประมาณการ (สำหรับผู้พัฒนา 1 คน ใช้ Claude Code ช่วย): ระยะที่ 1 ราว 3–4 สัปดาห์, ระยะที่ 2 ราว 3 สัปดาห์, ระยะที่ 3 ราว 4–5 สัปดาห์, ระยะที่ 4 ราว 3 สัปดาห์ ตัวเลขนี้เป็นการประเมินเบื้องต้น ปรับตามทีมจริง

**ประเด็นที่ต้องตัดสินใจก่อนเริ่มพัฒนา**

- [ ] ขอบเขตการยื่นรับรอง: ทั้ง 4 สาขา หรือเริ่มที่ศูนย์แล็บเมดิคอลเทรนด์ (บ่อสร้าง) ก่อน — มีผลต่อการตั้ง `req_branch_scope` และลำดับ gap assessment
- [ ] ข้อ 77 สำหรับห้องปฏิบัติการอณูชีววิทยา: หากมีการเก็บรักษาตัวอย่างหรือเชื้อ อาจต้องจดแจ้งครอบครองเชื้อโรค ไม่ใช่ N/A ควรยืนยันกับขอบเขตงานจริง
- [x] วิธีล็อกอิน: One-time PIN ทางอีเมล ระบุรายอีเมลใน Access policy (ตัดสินใจ 21 ต.ค. 2569)
- [ ] ช่องทางแจ้งเตือนหลัก: อีเมล หรือ LINE Official Account ของบริษัท
- [x] ชื่อ subdomain: `qms.medicaltrend.stream` (ตัดสินใจ 21 ต.ค. 2569)
- [ ] ผู้พัฒนาและดูแลระบบ: ทำเองร่วมกับ Claude Code หรือจ้างนักพัฒนาภายนอก
- [ ] เชื่อมผลแปล EQAS เดิม (M8) แบบนำเข้าไฟล์ หรือกรอกสรุปรายรอบ

ขั้นถัดไปที่ทำได้ทันที: จัดทำไฟล์ `0002_seed_moph2568.sql` จากเกณฑ์ 90 ข้อในเอกสาร G 0715050 พร้อมแตกเกณฑ์ย่อย เพื่อใช้เป็นฐานข้อมูลตั้งต้นของระบบ
