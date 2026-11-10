-- Run once in Supabase SQL Editor (after schema.sql).
-- Grants admin moderators access via RLS (anon key + logged-in admin user).

alter table public.profiles
  add column if not exists is_admin boolean not null default false;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select is_admin from public.profiles where id = auth.uid()),
    false
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

-- Admins may verify sellers / edit profile flags for any user
create policy "Admins update profiles"
  on public.profiles for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- Admins may feature listings and change status
create policy "Admins update listings"
  on public.listings for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- Admins can read private verification documents
create policy "Admins read verification docs"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'verification-docs'
    and public.is_admin()
  );

-- Make yourself admin (replace with your auth user uuid after first login):
-- update public.profiles set is_admin = true where id = 'YOUR-USER-UUID';
