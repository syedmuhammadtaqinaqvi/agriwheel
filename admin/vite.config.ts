import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');

  const publicSite =
    env.VITE_PUBLIC_SITE_URL?.trim() || (env.VERCEL_URL ? `https://${env.VERCEL_URL}` : '');

  const define: Record<string, string> = {};
  if (publicSite && !env.VITE_PUBLIC_SITE_URL?.trim()) {
    define['import.meta.env.VITE_PUBLIC_SITE_URL'] = JSON.stringify(publicSite);
  }

  return {
    plugins: [react()],
    /** Allow Vercel env names `SUPABASE_URL` / `SUPABASE_ANON_KEY` without VITE_ prefix. */
    envPrefix: ['VITE_', 'SUPABASE_'],
    define,
    build: {
      outDir: 'dist',
      sourcemap: false,
      chunkSizeWarningLimit: 600,
    },
  };
});
