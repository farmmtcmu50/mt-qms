import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// dev: `npx wrangler dev` (port 8787) ให้ API; `npm run dev --prefix web` proxy /api ไปที่นั่น
export default defineConfig({
  plugins: [react()],
  server: { proxy: { '/api': 'http://localhost:8787' } },
});
