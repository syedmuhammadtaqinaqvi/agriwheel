# Supabase auth for AgriWheel (mobile)

## Email link opens `localhost:3000` and fails

Supabase’s default **Site URL** is `http://localhost:3000`. Confirm-signup emails use that link. On your PC nothing is running on port 3000, so the browser shows **connection refused** or `otp_expired`.

**Fix for development (recommended):**

1. Supabase Dashboard → **Authentication** → **Providers** → **Email**
2. Turn **OFF** “Confirm email”
3. Save

Then sign up again in the app. You should get a session immediately and go to profile setup—no email link required.

**If you already signed up with confirm on:**

- Dashboard → **Authentication** → **Users** → open the user → confirm manually, **or** delete the user and register again after disabling confirm.

**Production / confirm email ON:** see [LIVE_AUTH_AND_ADMIN_PLAN.md](./LIVE_AUTH_AND_ADMIN_PLAN.md) — use `https://agriwheel.vercel.app/auth/confirm-email` as redirect (Flutter `.env`: `AUTH_REDIRECT_BASE`).

## Testing without using email quota (rate limits)

Supabase free tier limits auth emails per hour. While testing:

1. **Confirm email OFF** (above) — sign-up does not send mail; login works right away.
2. **Authentication → Users → Add user** — set email + password, enable **Auto confirm user** (no email).
3. For admin: run `supabase/promote_admin_user.sql` or set `is_admin = true` on that user.

There is no separate “free unlimited verification” product — for dev, **disable confirmation** or **create users in the dashboard**.
