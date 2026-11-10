import { createClient, type SupabaseClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL?.trim();
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY?.trim();

function envError(): string {
  if (!url || url.length < 10) {
    return 'Missing VITE_SUPABASE_URL. Copy values from Flutter .env into admin/.env (see admin/README.md).';
  }
  if (!anonKey || anonKey.includes('your_publishable') || anonKey.length < 20) {
    return 'Invalid VITE_SUPABASE_ANON_KEY. Use the same publishable key as SUPABASE_ANON_KEY in the Flutter project root .env.';
  }
  return '';
}

const envErr = envError();

export const supabaseConfigError = envErr;

export const supabase: SupabaseClient = envErr
  ? (null as unknown as SupabaseClient)
  : createClient(url!, anonKey!, {
      auth: { detectSessionInUrl: true, persistSession: true },
    });

export function mapSupabaseAuthError(message: string): string {
  if (message.toLowerCase().includes('invalid api key')) {
    return 'Invalid API key — fix VITE_SUPABASE_ANON_KEY in admin/.env (copy from Flutter .env), then restart npm run dev.';
  }
  return message;
}
