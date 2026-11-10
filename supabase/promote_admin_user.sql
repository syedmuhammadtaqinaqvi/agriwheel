-- Run in Supabase → SQL Editor (after schema.sql + admin_rls_v2.sql).
-- Grants web admin panel access (profiles.is_admin).

update public.profiles
set is_admin = true
where id = '4947a160-4cf8-433c-835c-b01ddd2b7860';

-- Verify:
-- select id, email, full_name, role, is_admin from public.profiles where id = '4947a160-4cf8-433c-835c-b01ddd2b7860';
