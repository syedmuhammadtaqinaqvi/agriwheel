import { useCallback, useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';

import { ConfirmDialog } from '../components/ConfirmDialog';
import { ListingEditorModal } from '../components/ListingEditorModal';
import { Loading } from '../components/Loading';
import { formatDate, formatRs } from '../lib/format';
import { supabase } from '../lib/supabase';
import type { ListingRow, ProfileRow } from '../lib/types';

export function ListingDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [listing, setListing] = useState<ListingRow | null>(null);
  const [seller, setSeller] = useState<ProfileRow | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [editOpen, setEditOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [busy, setBusy] = useState(false);

  const load = useCallback(async () => {
    if (!id) return;
    const { data, error: err } = await supabase
      .from('listings')
      .select('*')
      .eq('id', id)
      .maybeSingle();
    if (err) {
      setError(err.message);
      return;
    }
    if (!data) {
      setError('Listing not found.');
      return;
    }
    const row = data as ListingRow;
    setListing(row);
    const { data: prof } = await supabase
      .from('profiles')
      .select('id, full_name, email, phone, city, role, shop_name, address, interests, is_verified, is_admin, created_at')
      .eq('id', row.seller_id)
      .maybeSingle();
    setSeller(prof as ProfileRow | null);
  }, [id]);

  useEffect(() => {
    load();
  }, [load]);

  async function confirmDelete() {
    if (!listing) return;
    setBusy(true);
    const { error: err } = await supabase.from('listings').delete().eq('id', listing.id);
    setBusy(false);
    setDeleteOpen(false);
    if (err) setError(err.message);
    else navigate('/listings');
  }

  if (error) return <p className="error">{error}</p>;
  if (!listing) return <Loading label="Loading listing…" />;

  return (
    <div className="page">
      <Link to="/listings" className="back-link">
        ← Back to listings
      </Link>
      <header className="page-header">
        <div>
          <h2 className="page-title">{listing.title}</h2>
          <p className="price">{formatRs(listing.price)}</p>
          <div className="chip-row">
            {listing.is_featured && <span className="badge badge-accent">Featured</span>}
            <span className="badge">{listing.status}</span>
          </div>
        </div>
        <div className="actions">
          <button type="button" className="btn btn-sm btn-accent" onClick={() => setEditOpen(true)}>
            Edit
          </button>
          <button type="button" className="btn btn-sm btn-secondary" disabled={busy} onClick={() => setDeleteOpen(true)}>
            Delete
          </button>
        </div>
      </header>

      <div className="gallery">
        {(listing.image_urls ?? []).length === 0 ? (
          <p className="muted">No images</p>
        ) : (
          listing.image_urls.map((url) => (
            <a key={url} href={url} target="_blank" rel="noreferrer">
              <img src={url} alt="" className="gallery-img" />
            </a>
          ))
        )}
      </div>

      <div className="card">
        <table className="spec-table">
          <tbody>
            <tr>
              <th>Category</th>
              <td>{listing.category}</td>
            </tr>
            <tr>
              <th>Brand</th>
              <td>{listing.brand ?? '—'}</td>
            </tr>
            <tr>
              <th>Year</th>
              <td>{listing.year ?? '—'}</td>
            </tr>
            <tr>
              <th>City</th>
              <td>{listing.city ?? '—'}</td>
            </tr>
            <tr>
              <th>Condition</th>
              <td>{listing.condition ?? '—'}</td>
            </tr>
            <tr>
              <th>Hours used</th>
              <td>{listing.hours_used ?? '—'}</td>
            </tr>
            <tr>
              <th>Listed</th>
              <td>{formatDate(listing.created_at)}</td>
            </tr>
          </tbody>
        </table>
        <p className="section-title">Description</p>
        <p>{listing.description ?? '—'}</p>
      </div>

      {seller && (
        <div className="card">
          <p className="section-title">Seller</p>
          <p>
            <strong>{seller.full_name ?? '—'}</strong>
            {seller.is_verified && <span className="badge badge-accent"> Verified</span>}
          </p>
          <p className="muted">{seller.shop_name ?? seller.city ?? ''}</p>
          <p>{seller.phone ?? '—'}</p>
          <p>{seller.email ?? '—'}</p>
          <Link className="back-link" to={`/sellers`}>
            Manage sellers →
          </Link>
        </div>
      )}

      {editOpen && (
        <ListingEditorModal listing={listing} onClose={() => setEditOpen(false)} onSaved={load} />
      )}
      <ConfirmDialog
        open={deleteOpen}
        title="Delete listing?"
        body="This permanently removes the ad."
        confirmLabel="Delete"
        onConfirm={confirmDelete}
        onCancel={() => setDeleteOpen(false)}
      />
    </div>
  );
}
