import { NavLink, Outlet } from 'react-router-dom';

import { useAuth } from '../context/AuthContext';

const nav = [
  { to: '/', label: 'Dashboard', end: true },
  { to: '/users', label: 'Users' },
  { to: '/sellers', label: 'Sellers' },
  { to: '/listings', label: 'Listings' },
  { to: '/settings', label: 'Settings' },
];

export function Layout() {
  const { profile, signOut } = useAuth();
  const subtitle = profile?.email ?? profile?.full_name ?? 'Moderator';

  return (
    <div className="app">
      <aside className="sidebar">
        <div className="sidebar-brand">
          <span className="sidebar-logo">AgriWheel</span>
          <span className="sidebar-tag">Admin</span>
        </div>
        <nav className="sidebar-nav">
          {nav.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) => (isActive ? 'sidebar-link active' : 'sidebar-link')}
            >
              {item.label}
            </NavLink>
          ))}
        </nav>
        <div className="sidebar-foot">
          <p className="sidebar-user" title={profile?.id}>
            {subtitle}
          </p>
          <button type="button" className="btn btn-secondary btn-sm btn-block" onClick={() => signOut()}>
            Log out
          </button>
        </div>
      </aside>
      <main className="main-panel">
        <Outlet />
      </main>
    </div>
  );
}
