import { Link } from 'react-router-dom';

import { formatDate } from '../lib/format';
import type { ProfileRow } from '../lib/types';

type Props = {
  profile: ProfileRow;
  onClose: () => void;
  onEdit: () => void;
};

export function ProfileViewModal({ profile, onClose, onEdit }: Props) {
  return (
    <div className="dialog-backdrop" role="presentation" onClick={onClose}>
      <div className="card dialog dialog-wide" onClick={(e) => e.stopPropagation()}>
        <div className="dialog-head">
          <h3>{profile.full_name ?? 'User'}</h3>
          <p className="muted">{profile.email ?? profile.id}</p>
        </div>
        <dl className="detail-list">
          <div>
            <dt>Role</dt>
            <dd>{profile.role}</dd>
          </div>
          <div>
            <dt>Phone</dt>
            <dd>{profile.phone ?? '—'}</dd>
          </div>
          <div>
            <dt>City</dt>
            <dd>{profile.city ?? '—'}</dd>
          </div>
          {profile.role === 'seller' && (
            <>
              <div>
                <dt>Shop</dt>
                <dd>{profile.shop_name ?? '—'}</dd>
              </div>
              <div>
                <dt>Address</dt>
                <dd>{profile.address ?? '—'}</dd>
              </div>
              <div>
                <dt>Verified</dt>
                <dd>{profile.is_verified ? 'Yes' : 'No'}</dd>
              </div>
            </>
          )}
          {profile.role === 'buyer' && (
            <div>
              <dt>Interests</dt>
              <dd>{(profile.interests ?? []).join(', ') || '—'}</dd>
            </div>
          )}
          <div>
            <dt>Admin</dt>
            <dd>{profile.is_admin ? 'Yes' : 'No'}</dd>
          </div>
          <div>
            <dt>Joined</dt>
            <dd>{formatDate(profile.created_at)}</dd>
          </div>
        </dl>
        {profile.role === 'seller' && (
          <p>
            <Link className="back-link" to={`/listings?seller=${profile.id}`} onClick={onClose}>
              View seller listings →
            </Link>
          </p>
        )}
        <div className="dialog-actions">
          <button type="button" className="btn btn-secondary btn-sm" onClick={onClose}>
            Close
          </button>
          <button type="button" className="btn btn-accent btn-sm" onClick={onEdit}>
            Edit
          </button>
        </div>
      </div>
    </div>
  );
}
