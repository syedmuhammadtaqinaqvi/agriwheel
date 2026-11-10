import { createClient, type SupabaseClient } from '@supabase/supabase-js';

import { readSupabaseAnonKey, readSupabaseUrl } from './env';

const url = readSupabaseUrl();
const anonKey = readSupabaseAnonKey();

function envError(): string {
  if (!url || url.length < 10) {
    return 'Missing Supabase URL. In Vercel set VITE_SUPABASE_URL or SUPABASE_URL, then redeploy.';
  }
  if (!anonKey || anonKey.includes('your_publishable') || anonKey.length < 20) {
    return 'Missing Supabase anon key. In Vercel set VITE_SUPABASE_ANON_KEY or SUPABASE_ANON_KEY, then redeploy.';
  }
  return '';
}

const envErr = envError();

export const supabaseConfigError = envErr;

export const supabase: SupabaseClient = envErr
  ? (null as unknown as SupabaseClient)
  : createClient(url, anonKey, {
      auth: { detectSessionInUrl: true, persistSession: true },
    });

export function mapSupabaseAuthError(message: string): string {
  if (message.toLowerCase().includes('invalid api key')) {
    return 'Invalid API key — check SUPABASE_ANON_KEY / VITE_SUPABASE_ANON_KEY in Vercel, then redeploy.';
  }
  return message;
}
