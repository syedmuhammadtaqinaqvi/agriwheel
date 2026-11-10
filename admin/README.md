# AgriWheel Admin + Auth (one Vercel site)

Moderator panel and **public** email pages on the **same** HTTPS URL.

| Path | Audience |
|------|----------|
| `/login`, `/`, `/users`, `/sellers`, `/listings` | Moderators (`is_admin`) |
| `/auth/confirm-email` | Sign-up email link (Supabase Site URL) |
| `/auth/reset-password` | Forgot-password email link |

## Setup

1. Run [`supabase/admin_rls.sql`](../supabase/admin_rls.sql), [`admin_rls_v2.sql`](../supabase/admin_rls_v2.sql), and [`admin_rls_v3.sql`](../supabase/admin_rls_v3.sql).
2. `update public.profiles set is_admin = true where id = '…';`
3. Local:

```powershell
cd admin
Copy-Item .env.example .env
npm install
npm run dev
```

Copy **SUPABASE_URL** and **SUPABASE_ANON_KEY** from Flutter `.env` → `VITE_SUPABASE_*`.

See [LOCALHOST_TEST.md](./LOCALHOST_TEST.md) before deploying.

## Deploy to Vercel (free)

Full checklist: **[VERCEL_DEPLOY.md](./VERCEL_DEPLOY.md)**.

Summary: Vercel **Root Directory `admin`**, set `VITE_*` env vars, Supabase **Redirect URLs** `https://YOUR_URL/**`, Flutter `AUTH_REDIRECT_BASE` same URL.

## Flutter app

Same Supabase project. Mobile uses `AUTH_REDIRECT_BASE` for sign-up and password-reset emails.
