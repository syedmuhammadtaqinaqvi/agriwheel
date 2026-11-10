import { readFileSync, existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const adminDir = join(dirname(fileURLToPath(import.meta.url)), '..');

export function loadAdminEnv() {
  const path = join(adminDir, '.env');
  if (!existsSync(path)) {
    throw new Error('Missing admin/.env — copy .env.example and set VITE_SUPABASE_* from Flutter .env');
  }
  const vars = {};
  for (const line of readFileSync(path, 'utf8').split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const i = trimmed.indexOf('=');
    if (i < 1) continue;
    vars[trimmed.slice(0, i).trim()] = trimmed.slice(i + 1).trim();
  }
  return vars;
}

/** Optional in admin/.env; defaults below only for `npm run provision:admin`. */
export function adminTestCredentials(env) {
  return {
    email: env.ADMIN_TEST_EMAIL?.trim() || 'agriwheel-moderator@example.com',
    password: env.ADMIN_TEST_PASSWORD?.trim() || 'AgriWheelAdmin!2026',
  };
}
