/**
 * API smoke tests for admin Supabase wiring (no browser).
 * Run: npm test
 */
import { createClient } from '@supabase/supabase-js';

import { adminTestCredentials, loadAdminEnv } from './load-env.mjs';

const env = loadAdminEnv();
const { email: ADMIN_EMAIL, password: ADMIN_PASSWORD } = adminTestCredentials(env);

function fail(msg) {
  console.error('FAIL:', msg);
  process.exit(1);
}

function ok(msg) {
  console.log('OK:', msg);
}

const url = env.VITE_SUPABASE_URL?.trim();
const key = env.VITE_SUPABASE_ANON_KEY?.trim();
const siteUrl = env.VITE_PUBLIC_SITE_URL?.trim() || 'http://localhost:5173';

if (!url || url.length < 10) fail('VITE_SUPABASE_URL missing in admin/.env');
if (!key || key.includes('your_publishable') || key.length < 20) {
  fail('VITE_SUPABASE_ANON_KEY invalid — copy SUPABASE_ANON_KEY from Flutter .env');
}
if (!siteUrl.startsWith('http')) fail('VITE_PUBLIC_SITE_URL must be a URL');

const supabase = createClient(url, key, {
  auth: { persistSession: false, autoRefreshToken: false },
});

async function main() {
  ok(`env loaded (site ${siteUrl})`);

  const health = await fetch(`${url.replace(/\/$/, '')}/auth/v1/health`, {
    headers: { apikey: key, Authorization: `Bearer ${key}` },
  });
  if (!health.ok) fail(`Supabase auth health HTTP ${health.status}`);
  ok('Supabase auth reachable');

  const { data: signIn, error: signErr } = await supabase.auth.signInWithPassword({
    email: ADMIN_EMAIL,
    password: ADMIN_PASSWORD,
  });
  if (signErr) {
    fail(
      `Admin login failed (${signErr.message}). ` +
        'Promote your user: supabase/promote_admin_user.sql, then set ADMIN_TEST_EMAIL and ADMIN_TEST_PASSWORD in admin/.env (same as Flutter app).',
    );
  }
  if (!signIn.session) fail('No session after admin login');
  ok('admin sign-in');

  const { data: profile, error: profErr } = await supabase
    .from('profiles')
    .select('is_admin, email, full_name')
    .eq('id', signIn.session.user.id)
    .single();
  if (profErr) fail(`Profile read: ${profErr.message}`);
  if (!profile?.is_admin) {
    fail(`profiles.is_admin is false — run supabase/promote_admin_user.sql for uid 4947a160-4cf8-433c-835c-b01ddd2b7860`);
  }
  ok(`profile is_admin (${profile.email ?? ADMIN_EMAIL})`);

  const { data: listings, error: listErr } = await supabase
    .from('listings')
    .select('id', { count: 'exact', head: true });
  if (listErr) fail(`Listings select: ${listErr.message} (run supabase/admin_rls_v2.sql?)`);
  ok(`listings table readable (count header: ${listings ?? 'ok'})`);

  const { error: usersErr } = await supabase.from('profiles').select('id', { count: 'exact', head: true });
  if (usersErr) fail(`Profiles admin list: ${usersErr.message}`);
  ok('profiles table readable for admin');

  await supabase.auth.signOut();
  ok('all smoke checks passed');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
