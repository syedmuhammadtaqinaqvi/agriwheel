import { useEffect, useState, type FormEvent } from 'react';

import { supabase } from '../lib/supabase';
import type { ProfileRow } from '../lib/types';

type Props = {
  profile: ProfileRow;
  onClose: () => void;
  onSaved: () => void;
};

export function ProfileEditorModal({ profile, onClose, onSaved }: Props) {
  const [fullName, setFullName] = useState(profile.full_name ?? '');
  const [phone, setPhone] = useState(profile.phone ?? '');
  const [city, setCity] = useState(profile.city ?? '');
  const [role, setRole] = useState<'buyer' | 'seller'>(profile.role === 'seller' ? 'seller' : 'buyer');
  const [shopName, setShopName] = useState(profile.shop_name ?? '');
  const [address, setAddress] = useState(profile.address ?? '');
  const [interests, setInterests] = useState((profile.interests ?? []).join(', '));
  const [isVerified, setIsVerified] = useState(profile.is_verified);
  const [isAdmin, setIsAdmin] = useState(profile.is_admin);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setFullName(profile.full_name ?? '');
    setPhone(profile.phone ?? '');
    setCity(profile.city ?? '');
    setRole(profile.role === 'seller' ? 'seller' : 'buyer');
    setShopName(profile.shop_name ?? '');
    setAddress(profile.address ?? '');
    setInterests((profile.interests ?? []).join(', '));
    setIsVerified(profile.is_verified);
    setIsAdmin(profile.is_admin);
  }, [profile]);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    const list = interests
      .split(',')
      .map((s) => s.trim())
      .filter(Boolean);
    const { error: err } = await supabase
      .from('profiles')
      .update({
        full_name: fullName.trim() || null,
        phone: phone.trim() || null,
        city: city.trim() || null,
        role,
        shop_name: role === 'seller' ? shopName.trim() || null : null,
        address: role === 'seller' ? address.trim() || null : null,
        interests: role === 'buyer' ? list : [],
        is_verified: isVerified,
        is_admin: isAdmin,
      })
      .eq('id', profile.id);
    setBusy(false);
    if (err) {
      setError(err.message);
      return;
    }
    onSaved();
    onClose();
  }

  return (
    <div className="dialog-backdrop" role="presentation" onClick={onClose}>
      <form className="card dialog dialog-wide" onClick={(e) => e.stopPropagation()} onSubmit={onSubmit}>
        <div className="dialog-head">
          <h3>Edit user</h3>
          <p className="muted">{profile.email ?? profile.id}</p>
        </div>
        {error && <p className="error">{error}</p>}
        <div className="form-grid">
          <label className="field">
            Full name
            <input value={fullName} onChange={(e) => setFullName(e.target.value)} />
          </label>
          <label className="field">
            Phone
            <input value={phone} onChange={(e) => setPhone(e.target.value)} />
          </label>
          <label className="field">
            City
            <input value={city} onChange={(e) => setCity(e.target.value)} />
          </label>
          <label className="field">
            Role
            <select value={role} onChange={(e) => setRole(e.target.value as 'buyer' | 'seller')}>
              <option value="buyer">Buyer</option>
              <option value="seller">Seller</option>
            </select>
          </label>
          {role === 'seller' && (
            <>
              <label className="field">
                Shop name
                <input value={shopName} onChange={(e) => setShopName(e.target.value)} />
              </label>
              <label className="field field-span">
                Address
                <input value={address} onChange={(e) => setAddress(e.target.value)} />
              </label>
            </>
          )}
          {role === 'buyer' && (
            <label className="field field-span">
              Interests (comma-separated)
              <input value={interests} onChange={(e) => setInterests(e.target.value)} />
            </label>
          )}
          <label className="check-inline field-span">
            <input type="checkbox" checked={isVerified} onChange={(e) => setIsVerified(e.target.checked)} />
            Verified seller
          </label>
          <label className="check-inline field-span">
            <input type="checkbox" checked={isAdmin} onChange={(e) => setIsAdmin(e.target.checked)} />
            Admin (moderator panel)
          </label>
        </div>
        <div className="dialog-actions">
          <button type="button" className="btn btn-secondary btn-sm" onClick={onClose}>
            Cancel
          </button>
          <button type="submit" className="btn btn-primary btn-sm" disabled={busy}>
            {busy ? 'Saving…' : 'Save changes'}
          </button>
        </div>
      </form>
    </div>
  );
}
