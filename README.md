# MT-QMS — ระยะที่ 1 (ฐานข้อมูลมาตรฐานและหลักฐาน)

ดูสถาปัตยกรรมและกติกาทั้งหมดที่ `docs/system-design-spec.md` และ `CLAUDE.md`

## สิ่งที่มีในระยะที่ 1

- D1 schema ตาม spec หัวข้อ 5 (`migrations/0001_init.sql`) + trigger บังคับ audit_log append-only และหลักฐานลบจริงไม่ได้
- Seed 12 หมวด / 90 ข้อ / เกณฑ์ย่อย 183 รายการจาก PDF (`migrations/0002_seed_moph2568.sql`, สร้างด้วย `scripts/extract_moph2568.py`)
- 5 สาขา + ขอบเขตข้อกำหนดรายสาขา (`migrations/0003_seed_branches.sql`)
- API `/api/v1`: `me`, `branches`, `users`, `sections`, `requirements`, `requirements/:key`, `PATCH requirements/:id/scope/:branchId`,
  `POST evidence`, `GET files/:id`, `POST evidence/:id/links`, `PATCH evidence/:id`, `DELETE evidence/:id` (soft), `dashboard/readiness`, `dashboard/overview`, `audit-log`
- หน้าเว็บ: ภาพรวมความพร้อม (`/`), ข้อกำหนด 90 ข้อ (`/requirements`), รายละเอียดข้อ + อัปโหลด (`/requirements/:itemNo`), Audit log (`/audit-log`)

## รันบนเครื่อง

```bash
npm install && npm install --prefix web
cp .dev.vars.example .dev.vars
npx wrangler d1 migrations apply mt-qms-db --local
npx wrangler d1 execute mt-qms-db --local --file scripts/dev-seed.sql
npm run build --prefix web
npm run dev
```

เปิด http://127.0.0.1:8787 — ตอนรันบนเครื่องผู้ใช้คือ `DEV_AUTH_EMAIL` ใน `.dev.vars` (ใช้ได้เฉพาะ localhost)

```bash
npm test
```

## Deploy ครั้งแรก (production: https://qms.medicaltrend.stream)

1. สร้าง resource แล้วใส่ `database_id` ที่ได้ลงใน `wrangler.jsonc`
   ```bash
   npx wrangler d1 create mt-qms-db
   npx wrangler r2 bucket create mt-qms-docs
   npx wrangler r2 bucket create mt-qms-evidence
   npx wrangler r2 bucket create mt-qms-backup
   ```
2. Zero Trust → Access → Applications → Self-hosted: โดเมน `qms.medicaltrend.stream`
   - Login method: One-time PIN
   - Policy: Allow → Emails: ใส่อีเมลทีมงานทีละคน
   - คัดลอก Application Audience (AUD) tag และ team domain (`https://<team>.cloudflareaccess.com`)
3. ใส่ team domain ใน `vars.ACCESS_TEAM_DOMAIN` ของ `wrangler.jsonc` แล้วตั้ง secret
   ```bash
   npx wrangler secret put ACCESS_AUD
   ```
4. Migration + deploy
   ```bash
   npx wrangler d1 migrations apply mt-qms-db --remote
   npm run build --prefix web && npx wrangler deploy
   ```
5. ลงทะเบียนผู้ใช้คนแรก (QM ทุกสาขา) — อีเมลต้องตรงกับที่ใช้ล็อกอิน Access
   ```bash
   npx wrangler d1 execute mt-qms-db --remote --command "INSERT INTO users (id, email, full_name, position) VALUES ('u-qm-1', '<อีเมล>', '<ชื่อ>', 'ผู้จัดการคุณภาพ'); INSERT INTO user_roles (user_id, role, branch_id) VALUES ('u-qm-1', 'QM', NULL);"
   ```

ห้ามตั้ง `DEV_AUTH_EMAIL` ใน production
