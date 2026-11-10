-- Run after schema.sql and admin_rls.sql (safe to re-run where noted).

-- Email on profiles for admin user search (anon client cannot read auth.users)
alter table public.profiles add column if not exists is_admin boolean not null default false;
alter table public.profiles add column if not exists email text;

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name, phone, role, email)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'phone',
    case when new.raw_user_meta_data->>'role' = 'seller' then 'seller' else 'buyer' end,
    new.email
  );
  return new;
end; $$;

create or replace function public.sync_user_email_to_profile()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  update public.profiles set email = new.email where id = new.id;
  return new;
end; $$;

drop trigger if exists on_auth_user_email_sync on auth.users;
create trigger on_auth_user_email_sync
  after insert or update of email on auth.users
  for each row execute function public.sync_user_email_to_profile();

-- Backfill email for existing users
update public.profiles p
set email = u.email
from auth.users u
where p.id = u.id and (p.email is null or p.email <> u.email);

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

drop policy if exists "Admins update profiles" on public.profiles;
create policy "Admins update profiles"
  on public.profiles for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "Admins update listings" on public.listings;
create policy "Admins update listings"
  on public.listings for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "Admins delete listings" on public.listings;
create policy "Admins delete listings"
  on public.listings for delete
  to authenticated
  using (public.is_admin());

drop policy if exists "Admins read verification docs" on storage.objects;
create policy "Admins read verification docs"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'verification-docs' and public.is_admin());

create index if not exists profiles_role_idx on public.profiles (role);
create index if not exists profiles_email_idx on public.profiles (email);
create index if not exists listings_seller_id_idx on public.listings (seller_id);
create index if not exists listings_status_featured_created_idx
  on public.listings (status, is_featured, created_at desc);
