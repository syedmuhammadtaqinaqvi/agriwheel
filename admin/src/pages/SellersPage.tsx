import { useCallback, useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

import { ConfirmDialog } from '../components/ConfirmDialog';
import { EmptyState } from '../components/EmptyState';
import { Loading } from '../components/Loading';
import { ProfileEditorModal } from '../components/ProfileEditorModal';
import { ProfileViewModal } from '../components/ProfileViewModal';
import { listVerificationDocs, verificationDocUrl } from '../lib/storage';
import { supabase } from '../lib/supabase';
import type { ProfileRow } from '../lib/types';

export function SellersPage() {
  const [rows, setRows] = useState<ProfileRow[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [cnicUser, setCnicUser] = useState<string | null>(null);
  const [cnicUrls, setCnicUrls] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [viewUser, setViewUser] = useState<ProfileRow | null>(null);
  const [editUser, setEditUser] = useState<ProfileRow | null>(null);
  const [deleteUser, setDeleteUser] = useState<ProfileRow | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    const { data, error: err } = await supabase
      .from('profiles')
      .select('id, full_name, email, phone, city, role, shop_name, address, interests, is_verified, is_admin, created_at')
      .eq('role', 'seller')
      .order('is_verified', { ascending: true })
      .order('created_at', { ascending: false });
    setLoading(false);
    if (err) {
      setError(err.message);
      return;
    }
    setRows((data ?? []) as ProfileRow[]);
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  async function toggleVerified(row: ProfileRow) {
    setBusyId(row.id);
    setError(null);
    const { error: err } = await supabase.from('profiles').update({ is_verified: !row.is_verified }).eq('id', row.id);
    setBusyId(null);
    if (err) setError(err.message);
    else await load();
  }

  async function openCnic(userId: string) {
    setCnicUser(userId);
    setCnicUrls([]);
    const names = await listVerificationDocs(userId);
    const preferred = names.length ? names : ['cnic_front.jpg', 'cnic_back.jpg'];
    const urls: string[] = [];
    for (const name of preferred) {
      const u = await verificationDocUrl(userId, name);
      if (u) urls.push(u);
    }
    setCnicUrls(urls);
  }

  async function confirmDelete() {
    if (!deleteUser) return;
    setBusyId(deleteUser.id);
    const { error: err } = await supabase.from('profiles').delete().eq('id', deleteUser.id);
    setBusyId(null);
    setDeleteUser(null);
    if (err) setError(err.message);
    else await load();
  }

  if (loading) return <Loading label="Loading sellers…" />;

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <h2 className="page-title">Sellers</h2>
          <p className="page-lead">Verify CNIC, manage shops, and moderate seller accounts.</p>
        </div>
      </header>
      {error && <p className="error">{error}</p>}
      {rows.length === 0 ? (
        <EmptyState message="No sellers registered yet." />
      ) : (
        <div className="table-wrap">
          <table className="data-table">
            <thead>
              <tr>
                <th>Name / Shop</th>
                <th>Contact</th>
                <th>City</th>
                <th>Verified</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.id}>
                  <td>
                    <strong>{row.full_name ?? '—'}</strong>
                    <br />
                    <span className="muted">{row.shop_name ?? '—'}</span>
                  </td>
                  <td>
                    {row.email ?? '—'}
                    <br />
                    <span className="muted">{row.phone ?? ''}</span>
                  </td>
                  <td>{row.city ?? '—'}</td>
                  <td>
                    {row.is_verified ? (
                      <span className="badge badge-accent">Verified</span>
                    ) : (
                      <span className="badge">Pending</span>
                    )}
                  </td>
                  <td className="actions">
                    <button type="button" className="btn btn-sm btn-secondary" onClick={() => setViewUser(row)}>
                      View
                    </button>
                    <button type="button" className="btn btn-sm btn-accent" onClick={() => setEditUser(row)}>
                      Edit
                    </button>
                    <button type="button" className="btn btn-sm btn-secondary" disabled={busyId === row.id} onClick={() => toggleVerified(row)}>
                      {row.is_verified ? 'Revoke' : 'Verify'}
                    </button>
                    <button type="button" className="btn btn-sm btn-secondary" onClick={() => openCnic(row.id)}>
                      CNIC
                    </button>
                    <Link className="btn btn-sm btn-secondary" to={`/listings?seller=${row.id}`}>
                      Ads
                    </Link>
                    <button type="button" className="btn btn-sm btn-secondary" disabled={busyId === row.id} onClick={() => setDeleteUser(row)}>
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
        title="Delete seller?"
        body="Removes profile and all their listings."
        confirmLabel="Delete"
        onConfirm={confirmDelete}
        onCancel={() => setDeleteUser(null)}
      />

      {cnicUser && (
        <div className="dialog-backdrop" role="presentation" onClick={() => setCnicUser(null)}>
          <div className="card dialog" onClick={(e) => e.stopPropagation()}>
            <h3 className="page-title">CNIC documents</h3>
            {cnicUrls.length === 0 ? (
              <p className="muted">No files in verification-docs/{cnicUser}/</p>
            ) : (
              <div className="gallery">
                {cnicUrls.map((url) => (
                  <img key={url} src={url} alt="CNIC" className="gallery-img" />
                ))}
              </div>
            )}
            <button type="button" className="btn btn-sm btn-secondary" onClick={() => setCnicUser(null)}>
              Close
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
