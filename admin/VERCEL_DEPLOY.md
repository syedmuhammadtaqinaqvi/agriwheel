# Deploy AgriWheel Admin to Vercel (step-by-step)

One live URL serves **moderator login** and **email links** (`/auth/confirm-email`, `/auth/reset-password`).

---

## Before you start

- [ ] SQL applied: `supabase/schema.sql`, `supabase/admin_rls.sql`, `supabase/admin_rls_v2.sql`
- [ ] At least one user with `is_admin = true` (SQL or dashboard)
- [ ] Code on **GitHub** (Vercel imports from Git)

Local proof (optional): `cd admin` → `npm run build` succeeds.

---

## Step 1 — Push code to GitHub

If the repo is not on GitHub yet:

1. Create an empty repo on GitHub (no README).
2. In the project root:

```powershell
git remote add origin https://github.com/YOUR_USER/Agriwheel.git
git push -u origin main
```

(Use your real branch name if not `main`.)

---

## Step 2 — Create the Vercel project

1. Go to [vercel.com](https://vercel.com) → **Add New… → Project**.
2. Import your **Agriwheel** GitHub repo.
3. **Root Directory** → **Edit** → set to **`admin`** (not the repo root).
4. Framework: **Vite** (auto-detected).
5. **Build command:** `npm run build`
6. **Output directory:** `dist`
7. Do **not** deploy yet — add env vars first.

---

## Step 3 — Vercel environment variables

In **Project → Settings → Environment Variables**, add (Production **and** Preview if you use previews):

| Name | Value |
|------|--------|
| `VITE_SUPABASE_URL` | Same as `SUPABASE_URL` in Flutter `.env` |
| `VITE_SUPABASE_ANON_KEY` | Same as `SUPABASE_ANON_KEY` in Flutter `.env` |
| `VITE_PUBLIC_SITE_URL` | Your Vercel URL, e.g. `https://agriwheel-admin.vercel.app` — **no trailing slash** |

After the first deploy you’ll know the exact URL; if it differs, update `VITE_PUBLIC_SITE_URL` and **Redeploy**.

Click **Deploy**.

---

## Step 4 — Note your live URL

Example: `https://agriwheel-admin.vercel.app`

Open in the browser:

- `https://YOUR_URL/login` — login form (not “Configuration required”)
- `https://YOUR_URL/auth/confirm-email` — public page (may show error without a token; that’s OK)
- `https://YOUR_URL/auth/reset-password` — same

`vercel.json` already rewrites all routes to the SPA (`index.html`).

---

## Step 5 — Supabase Authentication URLs

Supabase Dashboard → **Authentication** → **URL configuration**:

| Field | Value |
|-------|--------|
| **Site URL** | `https://YOUR_URL.vercel.app` |
| **Redirect URLs** | `https://YOUR_URL.vercel.app/**` |
| | `http://localhost:5173/**` (keep for local dev) |

Add each redirect on its own line (or one line with wildcard as above).

**Email templates (optional check):** Authentication → **Email templates** — links use your redirect; no need to hard-code localhost.

**Rate limits:** Authentication → **Rate Limits** — if you hit limits in dev, wait before testing production emails.

---

## Step 6 — Flutter app `.env` (production / release builds)

In the **Flutter project root** `.env` (not committed):

```env
AUTH_REDIRECT_BASE=https://YOUR_URL.vercel.app
```

No trailing slash.

This drives:

- Sign-up → `…/auth/confirm-email`
- Forgot password → `…/auth/reset-password`

Rebuild/restart the Flutter app after changing `.env`.

---

## Step 7 — Test the full email flows

### A. Confirm email (sign-up)

1. Supabase → **Authentication** → **Providers** → Email: confirm whether **Confirm email** is ON.
2. In the Flutter app, sign up with a **new** test email (or dashboard **Add user** with auto-confirm OFF).
3. Email link should open:  
   `https://YOUR_URL.vercel.app/auth/confirm-email?code=…`
4. Page shows **Email confirmed** → log in on the phone.

### B. Forgot password

1. Flutter app → **Forgot Password** → enter email.
2. Link opens:  
   `https://YOUR_URL.vercel.app/auth/reset-password?code=…`
3. Set new password on the web page → **Password updated** → log in on the phone.

### C. Admin login

1. `https://YOUR_URL.vercel.app/login`
2. Email + password of a user with `is_admin = true`
3. Dashboard, Users, Sellers, Listings load without RLS errors.

---

## Step 8 — Promote a moderator (if needed)

SQL Editor:

```sql
update public.profiles set is_admin = true
where id = 'YOUR-USER-UUID';
```

Or create a user in **Authentication → Users → Add user** (auto-confirm), then promote by `id` from `profiles`.

---

## Checklist (copy)

- [ ] Vercel root = `admin`, build OK
- [ ] All three `VITE_*` env vars set; `VITE_PUBLIC_SITE_URL` matches live URL
- [ ] Supabase Redirect URLs include `https://YOUR_URL/**`
- [ ] Flutter `AUTH_REDIRECT_BASE` = same Vercel URL
- [ ] Confirm-email and reset-password links work once from the app
- [ ] Admin login works for `is_admin` user

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| “Configuration required” on Vercel | Wrong/missing `VITE_SUPABASE_*`; redeploy after fixing |
| Email link goes to localhost | Flutter `AUTH_REDIRECT_BASE` still localhost; rebuild app |
| “Redirect URL not allowed” | Add exact `https://YOUR_URL/**` in Supabase Redirect URLs |
| Confirm/reset page says invalid link | Link expired; request new email; ensure PKCE pages deployed (latest `admin` code) |
| Admin login OK but “Admin access required” | Run `is_admin = true` SQL for that user |
| Email rate exceeded | Wait ~1 hour or use dashboard **Add user** with password (no email) for admin testing |

Custom domain (later): Vercel → Domains → add domain → update `VITE_PUBLIC_SITE_URL`, Supabase redirects, and Flutter `AUTH_REDIRECT_BASE` → **Redeploy**.
