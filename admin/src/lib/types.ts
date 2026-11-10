export type ProfileRow = {
  id: string;
  full_name: string | null;
  email: string | null;
  phone: string | null;
  city: string | null;
  role: string;
  shop_name: string | null;
  address: string | null;
  interests: string[] | null;
  is_verified: boolean;
  is_admin: boolean;
  created_at: string;
};

export type ListingRow = {
  id: string;
  seller_id: string;
  title: string;
  category: string;
  brand: string | null;
  year: number | null;
  price: number;
  city: string | null;
  condition: string | null;
  hours_used: number | null;
  description: string | null;
  status: 'active' | 'sold';
  is_featured: boolean;
  created_at: string;
  image_urls: string[];
};
