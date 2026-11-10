/** Vite exposes `VITE_*`; Vercel users often set `SUPABASE_*` — support both. */
export function readSupabaseUrl(): string {
  return (import.meta.env.VITE_SUPABASE_URL || import.meta.env.SUPABASE_URL || '').trim();
}

export function readSupabaseAnonKey(): string {
  return (import.meta.env.VITE_SUPABASE_ANON_KEY || import.meta.env.SUPABASE_ANON_KEY || '').trim();
}

export function readPublicSiteUrl(): string {
  return (import.meta.env.VITE_PUBLIC_SITE_URL || '').trim();
}
