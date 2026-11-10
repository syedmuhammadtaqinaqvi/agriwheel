import { useCallback, useEffect, useMemo, useState } from 'react';

import { ConfirmDialog } from '../components/ConfirmDialog';
import { EmptyState } from '../components/EmptyState';
import { Loading } from '../components/Loading';
import { ProfileEditorModal } from '../components/ProfileEditorModal';
import { ProfileViewModal } from '../components/ProfileViewModal';
import { formatDate } from '../lib/format';
import { supabase } from '../lib/supabase';
import type { ProfileRow } from '../lib/types';

export function UsersPage() {
  const [tab, setTab] = useState<'buyer' | 'seller'>('buyer');
  const [rows, setRows] = useState<ProfileRow[]>([]);
  const [q, setQ] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [viewUser, setViewUser] = useState<ProfileRow | null>(null);
  const [editUser, setEditUser] = useState<ProfileRow | null>(null);
  const [deleteUser, setDeleteUser] = useState<ProfileRow | null>(null);
  const [busyId, setBusyId] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    const { data, error: err } = await supabase
      .from('profiles')
      .select('id, full_name, email, phone, city, role, shop_name, address, interests, is_verified, is_admin, created_at')
      .eq('role', tab)
      .order('created_at', { ascending: false });
    setLoading(false);
    if (err) {
      setError(err.message);
      return;
    }
    setRows((data ?? []) as ProfileRow[]);
  }, [tab]);

  useEffect(() => {
    load();
  }, [load]);

  const filtered = useMemo(() => {
    const term = q.trim().toLowerCase();
    if (!term) return rows;
    return rows.filter((r) => {
      const hay = [r.full_name, r.email, r.phone, r.city, r.shop_name, r.address, ...(r.interests ?? [])]
        .filter(Boolean)
        .join(' ')
        .toLowerCase();
      return hay.includes(term);
    });
  }, [rows, q]);

  async function confirmDelete() {
    if (!deleteUser) return;
    setBusyId(deleteUser.id);
    const { error: err } = await supabase.from('profiles').delete().eq('id', deleteUser.id);
    setBusyId(null);
    setDeleteUser(null);
    if (err) setError(err.message);
    else await load();
  }

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <h2 className="page-title">Users</h2>
          <p className="page-lead">View, edit, and remove buyer and seller accounts.</p>
        </div>
      </header>
      <div className="toolbar">
        <div className="tabs">
          <button type="button" className={tab === 'buyer' ? 'tab active' : 'tab'} onClick={() => setTab('buyer')}>
            Buyers
          </button>
          <button type="button" className={tab === 'seller' ? 'tab active' : 'tab'} onClick={() => setTab('seller')}>
            Sellers
          </button>
        </div>
        <label className="field field-inline">
          <span className="sr-only">Search</span>
          <input type="search" placeholder="Search name, email, phone…" value={q} onChange={(e) => setQ(e.target.value)} />
        </label>
      </div>
      {error && <p className="error">{error}</p>}
      {loading ? (
        <Loading />
      ) : filtered.length === 0 ? (
        <EmptyState message={rows.length === 0 ? `No ${tab}s yet.` : 'No matches for your search.'} />
      ) : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>City</th>
                {tab === 'seller' ? <th>Shop</th> : <th>Interests</th>}
                <th>Joined</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((row) => (
                <tr key={row.id}>
                  <td>
                    <strong>{row.full_name ?? '—'}</strong>
                    {row.is_admin && (
                      <>
                        <br />
                        <span className="badge badge-accent">Admin</span>
                      </>
                    )}
                  </td>
                  <td>{row.email ?? '—'}</td>
                  <td>{row.phone ?? '—'}</td>
                  <td>{row.city ?? '—'}</td>
                  <td>
                    {tab === 'seller'
                      ? row.shop_name ?? '—'
                      : (row.interests ?? []).join(', ') || '—'}
                  </td>
                  <td>{formatDate(row.created_at)}</td>
                  <td className="actions">
                    <button type="button" className="btn btn-sm btn-secondary" onClick={() => setViewUser(row)}>
                      View
                    </button>
                    <button type="button" className="btn btn-sm btn-accent" onClick={() => setEditUser(row)}>
                      Edit
                    </button>
                    <button
                      type="button"
                      className="btn btn-sm btn-secondary"
                      disabled={busyId === row.id}
                      onClick={() => setDeleteUser(row)}
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {viewUser && (
        <ProfileViewModal
          profile={viewUser}
          onClose={() => setViewUser(null)}
          onEdit={() => {
            setEditUser(viewUser);
            setViewUser(null);
          }}
        />
      )}
      {editUser && <ProfileEditorModal profile={editUser} onClose={() => setEditUser(null)} onSaved={load} />}
      <ConfirmDialog
        open={deleteUser !== null}
        title="Delete profile?"
        body="Removes the marketplace profile and their listings. The auth user may still exist in Supabase — remove there if needed."
        confirmLabel="Delete"
        onConfirm={confirmDelete}
        onCancel={() => setDeleteUser(null)}
      />
    </div>
  );
}
