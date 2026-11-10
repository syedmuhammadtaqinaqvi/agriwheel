create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  city text,
  role text not null default 'buyer' check (role in ('buyer','seller')),
  shop_name text,
  address text,
  avatar_url text,
  interests text[] not null default '{}',
  is_verified boolean not null default false,
  created_at timestamptz not null default now()
);

create function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name, phone, role)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'phone',
    case when new.raw_user_meta_data->>'role' = 'seller' then 'seller' else 'buyer' end
  );
  return new;
end; $$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

create table public.listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  title text not null,
  category text not null,
  brand text,
  year int,
  price numeric not null,
  city text,
  condition text,
  hours_used int,
  description text,
  image_urls text[] not null default '{}',
  status text not null default 'active' check (status in ('active','sold')),
  is_featured boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.favorites (
  user_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  listing_id uuid not null references public.listings(id) on delete cascade,
  primary key (user_id, listing_id)
);

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  buyer_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  seller_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (listing_id, buyer_id)
);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  text text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.listings enable row level security;
alter table public.favorites enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;

create policy "Anyone can view profiles" on public.profiles for select using (true);
create policy "Users edit own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

create policy "Anyone can view listings" on public.listings for select using (true);
create policy "Sellers add own listings" on public.listings for insert with check (auth.uid() = seller_id);
create policy "Sellers edit own listings" on public.listings for update using (auth.uid() = seller_id) with check (auth.uid() = seller_id);
create policy "Sellers delete own listings" on public.listings for delete using (auth.uid() = seller_id);

create policy "Users manage own favorites" on public.favorites for all
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Members view conversations" on public.conversations for select
  using (auth.uid() = buyer_id or auth.uid() = seller_id);
create policy "Buyers start conversations" on public.conversations for insert
  with check (auth.uid() = buyer_id);

create policy "Members view messages" on public.messages for select
  using (exists (select 1 from public.conversations c where c.id = conversation_id
        and (c.buyer_id = auth.uid() or c.seller_id = auth.uid())));
create policy "Members send messages" on public.messages for insert
  with check (auth.uid() = sender_id and exists (select 1 from public.conversations c
        where c.id = conversation_id and (c.buyer_id = auth.uid() or c.seller_id = auth.uid())));

alter publication supabase_realtime add table public.messages;

insert into storage.buckets (id, name, public) values ('listing-images', 'listing-images', true);
insert into storage.buckets (id, name, public) values ('verification-docs', 'verification-docs', false);

create policy "Anyone can view listing images" on storage.objects
  for select using (bucket_id = 'listing-images');
create policy "Users upload to own folder in listing-images" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'listing-images' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users delete own listing images" on storage.objects
  for delete to authenticated
  using (bucket_id = 'listing-images' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Users upload own verification docs" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'verification-docs' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users view own verification docs" on storage.objects
  for select to authenticated
  using (bucket_id = 'verification-docs' and (storage.foldername(name))[1] = auth.uid()::text);
