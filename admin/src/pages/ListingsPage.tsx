import { useCallback, useEffect, useMemo, useState } from 'react';
import { Link, useSearchParams } from 'react-router-dom';

import { ConfirmDialog } from '../components/ConfirmDialog';
import { EmptyState } from '../components/EmptyState';
import { ImageThumb } from '../components/ImageThumb';
import { ListingEditorModal } from '../components/ListingEditorModal';
import { Loading } from '../components/Loading';
import { formatRs } from '../lib/format';
import { supabase } from '../lib/supabase';
import type { ListingRow } from '../lib/types';

export function ListingsPage() {
  const [params] = useSearchParams();
  const sellerFilter = params.get('seller') ?? '';
  const [rows, setRows] = useState<ListingRow[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState<'all' | 'active' | 'sold'>('all');
  const [featuredOnly, setFeaturedOnly] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [editRow, setEditRow] = useState<ListingRow | null | 'new'>(null);

  const load = useCallback(async () => {
    setLoading(true);
    let query = supabase
      .from('listings')
      .select('id, seller_id, title, category, brand, year, price, city, condition, hours_used, description, status, is_featured, created_at, image_urls')
      .order('created_at', { ascending: false })
      .limit(200);
    if (sellerFilter) query = query.eq('seller_id', sellerFilter);
    const { data, error: err } = await query;
    setLoading(false);
    if (err) {
      setError(err.message);
      return;
    }
    setRows((data ?? []) as ListingRow[]);
  }, [sellerFilter]);

  useEffect(() => {
    load();
  }, [load]);

  const filtered = useMemo(() => {
    return rows.filter((r) => {
      if (statusFilter !== 'all' && r.status !== statusFilter) return false;
      if (featuredOnly && !r.is_featured) return false;
      return true;
    });
  }, [rows, statusFilter, featuredOnly]);

  async function toggleFeatured(row: ListingRow) {
    setBusyId(row.id);
    const { error: err } = await supabase.from('listings').update({ is_featured: !row.is_featured }).eq('id', row.id);
    setBusyId(null);
    if (err) setError(err.message);
    else await load();
  }

  async function setStatus(row: ListingRow, status: 'active' | 'sold') {
    setBusyId(row.id);
    const { error: err } = await supabase.from('listings').update({ status }).eq('id', row.id);
    setBusyId(null);
    if (err) setError(err.message);
    else await load();
  }

  async function confirmDelete() {
    if (!deleteId) return;
    setBusyId(deleteId);
    const { error: err } = await supabase.from('listings').delete().eq('id', deleteId);
    setBusyId(null);
    setDeleteId(null);
    if (err) setError(err.message);
    else await load();
  }

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <h2 className="page-title">Listings</h2>
          <p className="page-lead">Feature ads, mark sold, edit fields, or remove listings.</p>
        </div>
        <button type="button" className="btn btn-accent btn-sm" onClick={() => setEditRow('new')}>
          + New listing
        </button>
      </header>
      {sellerFilter && <p className="muted">Filtered by seller {sellerFilter}</p>}
      <div className="filters">
        <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value as typeof statusFilter)}>
          <option value="all">All status</option>
          <option value="active">Active</option>
          <option value="sold">Sold</option>
        </select>
        <label className="check-inline">
          <input type="checkbox" checked={featuredOnly} onChange={(e) => setFeaturedOnly(e.target.checked)} />
          Featured only
        </label>
      </div>
      {error && <p className="error">{error}</p>}
      {loading ? (
        <Loading />
      ) : filtered.length === 0 ? (
        <EmptyState message="No listings match filters." />
      ) : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th />
                <th>Title</th>
                <th>Category</th>
                <th>Price</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((row) => (
                <tr key={row.id}>
                  <td>
                    <ImageThumb src={row.image_urls?.[0]} alt="" />
                  </td>
                  <td>
                    <strong>{row.title}</strong>
                    <br />
                    <span className="muted">{row.city ?? '—'}</span>
                    {row.is_featured && (
                      <>
                        <br />
                        <span className="badge badge-accent">Featured</span>
                      </>
                    )}
                  </td>
                  <td>{row.category}</td>
                  <td className="price">{formatRs(row.price)}</td>
                  <td>{row.status}</td>
                  <td className="actions">
                    <Link className="btn btn-sm btn-secondary" to={`/listings/${row.id}`}>
                      View
                    </Link>
                    <button type="button" className="btn btn-sm btn-accent" onClick={() => setEditRow(row)}>
                      Edit
                    </button>
                    <button type="button" className="btn btn-sm btn-secondary" disabled={busyId === row.id} onClick={() => toggleFeatured(row)}>
                      {row.is_featured ? 'Unfeature' : 'Feature'}
                    </button>
                    {row.status === 'active' ? (
                      <button type="button" className="btn btn-sm btn-secondary" disabled={busyId === row.id} onClick={() => setStatus(row, 'sold')}>
                        Sold
                      </button>
                    ) : (
                      <button type="button" className="btn btn-sm btn-secondary" disabled={busyId === row.id} onClick={() => setStatus(row, 'active')}>
                        Active
                      </button>
                    )}
                    <button type="button" className="btn btn-sm btn-secondary" disabled={busyId === row.id} onClick={() => setDeleteId(row.id)}>
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      <ConfirmDialog
        open={deleteId !== null}
        title="Delete listing?"
        body="This permanently removes the ad. Sellers cannot undo from the app."
        confirmLabel="Delete"
        onConfirm={confirmDelete}
        onCancel={() => setDeleteId(null)}
      />
      {editRow !== null && (
        <ListingEditorModal
          listing={editRow === 'new' ? null : editRow}
          sellerId={sellerFilter || undefined}
          onClose={() => setEditRow(null)}
          onSaved={load}
        />
      )}
    </div>
  );
}
