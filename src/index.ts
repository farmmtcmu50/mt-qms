import { Hono } from 'hono';
import { secureHeaders } from 'hono/secure-headers';
import { accessAuth } from './middleware/accessAuth';
import { loadUser } from './middleware/loadUser';
import { withAudit } from './middleware/withAudit';
import { core } from './routes/core';
import { dashboard } from './routes/dashboard';
import { evidence } from './routes/evidence';
import { requirements } from './routes/requirements';
import type { AppEnv, Env } from './types';

const api = new Hono<AppEnv>();
api.use('*', accessAuth, loadUser, withAudit());
api.route('/', core);
api.route('/', requirements);
api.route('/', evidence);
api.route('/', dashboard);

const app = new Hono<AppEnv>();
app.use('/api/*', secureHeaders({ crossOriginResourcePolicy: 'same-origin' }));
app.route('/api/v1', api);
app.all('/api/*', (c) => c.json({ error: 'not_found' }, 404));
// หน้าเว็บ (SPA) เสิร์ฟจาก Workers Static Assets โดยตรง; เส้นทางนี้ใช้เมื่อ assets ส่งต่อมาถึง Worker
app.all('*', (c) => c.env.ASSETS.fetch(c.req.raw));

app.onError((err, c) => {
  console.error(err);
  return c.json({ error: 'internal_error' }, 500);
});

export default {
  fetch: app.fetch,
  // Cron Triggers (งานรายวัน / backup รายสัปดาห์) เริ่มในระยะที่ 3 ตาม spec หัวข้อ 12
  async scheduled(controller: ScheduledController, _env: Env) {
    console.log(`cron ${controller.cron}: not implemented until phase 3`);
  },
} satisfies ExportedHandler<Env>;
