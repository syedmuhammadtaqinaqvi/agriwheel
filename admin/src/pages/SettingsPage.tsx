export function SettingsPage() {
  const url = import.meta.env.VITE_SUPABASE_URL ?? '—';
  const site = import.meta.env.VITE_PUBLIC_SITE_URL ?? '—';

  return (
    <div>
      <h2 className="page-title">Settings</h2>
      <div className="card">
        <p>
          <strong>Supabase URL</strong>
          <br />
          {url}
        </p>
        <p>
          <strong>Public site URL</strong> (email redirects)
          <br />
          {site}
        </p>
        <p className="muted">
          Listing photos should be compressed to ~300 KB in the mobile app before upload. Admins display public URLs from
          the listing-images bucket.
        </p>
        <p className="muted">Email templates: Supabase Dashboard → Authentication → Email.</p>
      </div>
    </div>
  );
}
