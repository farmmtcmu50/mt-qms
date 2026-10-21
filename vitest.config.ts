import path from 'node:path';
import { defineConfig } from 'vitest/config';
import { cloudflareTest, readD1Migrations } from '@cloudflare/vitest-pool-workers';

export default defineConfig({
  plugins: [
    cloudflareTest(async () => ({
      main: './src/index.ts',
      wrangler: { configPath: './wrangler.jsonc' },
      miniflare: {
        // workerd ที่มากับ vitest-pool-workers รองรับถึง 2026-08-22 (deprecated → @cloudflare/vitest-plugin)
        compatibilityDate: '2026-08-15',
        bindings: {
          TEST_MIGRATIONS: await readD1Migrations(path.join(import.meta.dirname, 'migrations')),
          ACCESS_AUD: 'test-aud',
          ACCESS_TEAM_DOMAIN: 'https://test.cloudflareaccess.com',
          DEV_AUTH_EMAIL: 'qm@example.test',
        },
      },
    })),
  ],
  test: { setupFiles: ['./test/apply-migrations.ts'] },
});
