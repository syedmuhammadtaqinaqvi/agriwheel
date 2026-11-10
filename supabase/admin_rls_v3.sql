-- Run after admin_rls_v2.sql — admin create/delete users (profiles) and create listings.

drop policy if exists "Admins delete profiles" on public.profiles;
create policy "Admins delete profiles"
  on public.profiles for delete
  to authenticated
  using (public.is_admin());

drop policy if exists "Admins insert listings" on public.listings;
create policy "Admins insert listings"
  on public.listings for insert
  to authenticated
  with check (public.is_admin());
