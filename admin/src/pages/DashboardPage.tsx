import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

import { Loading } from '../components/Loading';
import { supabase } from '../lib/supabase';

type Stats = {
  sellers: number;
  buyers: number;
  listingsActive: number;
  listingsFeatured: number;
  sellersUnverified: number;
};

export function DashboardPage() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      try {
        const [sellers, buyers, active, featured, unverified] = await Promise.all([
          supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'seller'),
          supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'buyer'),
          supabase.from('listings').select('id', { count: 'exact', head: true }).eq('status', 'active'),
          supabase.from('listings').select('id', { count: 'exact', head: true }).eq('is_featured', true),
          supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'seller').eq('is_verified', false),
        ]);
        const firstErr = sellers.error ?? buyers.error ?? active.error ?? featured.error ?? unverified.error;
        if (firstErr) throw firstErr;
        setStats({
          sellers: sellers.count ?? 0,
          buyers: buyers.count ?? 0,
          listingsActive: active.count ?? 0,
          listingsFeatured: featured.count ?? 0,
          sellersUnverified: unverified.count ?? 0,
        });
      } catch (e) {
        setError(e instanceof Error ? e.message : String(e));
      }
    })();
  }, []);

  if (error) return <p className="error">{error}</p>;
  if (!stats) return <Loading />;

  const cards = [
    { label: 'Sellers', value: stats.sellers, to: '/sellers' },
    { label: 'Buyers', value: stats.buyers, to: '/users' },
    { label: 'Active listings', value: stats.listingsActive, to: '/listings' },
    { label: 'Featured listings', value: stats.listingsFeatured, to: '/listings' },
    { label: 'Unverified sellers', value: stats.sellersUnverified, to: '/sellers' },
  ];

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <h2 className="page-title">Dashboard</h2>
          <p className="page-lead">Marketplace overview — tap a card to manage.</p>
        </div>
      </header>
      <div className="stat-grid">
        {cards.map((c) => (
          <Link key={c.label} to={c.to} className="stat-card stat-card-link">
            <span className="stat-value">{c.value}</span>
            <span className="stat-label">{c.label}</span>
          </Link>
        ))}
      </div>
      <div className="quick-links card">
        <p className="section-title">Quick actions</p>
        <div className="actions">
          <Link className="btn btn-sm btn-accent" to="/listings">
            Manage listings
          </Link>
          <Link className="btn btn-sm btn-secondary" to="/sellers">
            Review sellers
          </Link>
          <Link className="btn btn-sm btn-secondary" to="/users">
            Browse users
          </Link>
        </div>
      </div>
    </div>
  );
}
