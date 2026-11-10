# Localhost test checklist (Goal 1)

Run SQL first: [`supabase/admin_rls_v2.sql`](../supabase/admin_rls_v2.sql) and promote your user:

```sql
-- or run supabase/promote_admin_user.sql
update public.profiles set is_admin = true where id = '4947a160-4cf8-433c-835c-b01ddd2b7860';
```

Admin login uses the **same email and password** as the Flutter app (no separate admin password).

## Admin `.env`

```powershell
cd admin
Copy-Item .env.example .env
```

Set `VITE_SUPABASE_*` from Flutter root `.env`. Set `VITE_PUBLIC_SITE_URL=http://localhost:5173`.

```powershell
npm run dev
```

## Checklist

1. [ ] `/login` — no "Invalid API key"
2. [ ] Login with `is_admin` account → Dashboard
3. [ ] `/users` — buyers/sellers with email (after admin_rls_v2)
4. [ ] `/sellers` — Verify, CNIC modal, Ads link
5. [ ] `/listings` — feature, sold, delete, thumbnails
6. [ ] `/listings/:id` — detail + gallery
7. [ ] `/auth/confirm-email` — page loads
8. [ ] `/auth/reset-password` — page loads

## Supabase redirects (local email test)

Authentication → URL configuration → Redirect URLs: `http://localhost:5173/**`

Flutter `.env`: `AUTH_REDIRECT_BASE=http://localhost:5173`

## Sample listings

```sql
insert into public.listings (seller_id, title, category, price, city, status, is_featured, image_urls)
values (
  'YOUR-SELLER-UUID',
  'MF 385 Tractor',
  'Tractor',
  2500000,
  'Lahore',
  'active',
  true,
  array['https://picsum.photos/seed/agri1/800/600']
);
```

When all pass → deploy Vercel per [README.md](./README.md).
