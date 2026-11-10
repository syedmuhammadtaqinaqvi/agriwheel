/**
 * Creates (or reuses) a dedicated moderator account and sets profiles.is_admin = true.
 * Run: npm run provision:admin
 */
import { createClient } from '@supabase/supabase-js';

import { adminTestCredentials, loadAdminEnv } from './load-env.mjs';

const { email: ADMIN_EMAIL, password: ADMIN_PASSWORD } = adminTestCredentials(loadAdminEnv());

const env = loadAdminEnv();
const url = env.VITE_SUPABASE_URL;
const key = env.VITE_SUPABASE_ANON_KEY;

if (!url || !key || key.includes('your_publishable')) {
  console.error('Fix admin/.env (VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY).');
  process.exit(1);
}

const supabase = createClient(url, key, {
  auth: { persistSession: false, autoRefreshToken: false },
});

async function main() {
  let signIn = await supabase.auth.signInWithPassword({
    email: ADMIN_EMAIL,
    password: ADMIN_PASSWORD,
  });

  if (signIn.error?.message?.toLowerCase().includes('invalid login')) {
    const signUp = await supabase.auth.signUp({
      email: ADMIN_EMAIL,
      password: ADMIN_PASSWORD,
      options: {
        data: { full_name: 'AgriWheel Moderator', role: 'buyer' },
      },
    });
    if (signUp.error && !signUp.error.message.toLowerCase().includes('already')) {
      console.error('Sign up failed:', signUp.error.message);
      process.exit(1);
    }
    signIn = await supabase.auth.signInWithPassword({
      email: ADMIN_EMAIL,
      password: ADMIN_PASSWORD,
    });
  }

  if (signIn.error || !signIn.data.session) {
    console.error(
      'Could not sign in. If email confirmation is required, disable it in Supabase Auth settings or confirm the email, then retry.',
      signIn.error?.message ?? '',
    );
    process.exit(1);
  }

  const userId = signIn.data.session.user.id;

  const { error: profileErr } = await supabase
    .from('profiles')
    .update({
      is_admin: true,
      full_name: 'AgriWheel Moderator',
      role: 'buyer',
    })
    .eq('id', userId);

  if (profileErr) {
    console.error('Could not set is_admin on profile:', profileErr.message);
    console.error('Run in SQL Editor:\n  update public.profiles set is_admin = true where email =', `'${ADMIN_EMAIL}';`);
    process.exit(1);
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('id, email, is_admin')
    .eq('id', userId)
    .single();

  console.log('Admin account ready.');
  console.log('  Email:   ', ADMIN_EMAIL);
  console.log('  Password:', ADMIN_PASSWORD);
  console.log('  User id: ', userId);
  console.log('  is_admin:', profile?.is_admin === true ? 'yes' : 'NO — run admin_rls_v2.sql and promote manually');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
