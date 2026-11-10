import { useEffect, useState, type FormEvent } from 'react';

import { supabase } from '../lib/supabase';
import type { ListingRow } from '../lib/types';

type Props = {
  listing: ListingRow | null;
  sellerId?: string;
  onClose: () => void;
  onSaved: () => void;
};

export function ListingEditorModal({ listing, sellerId, onClose, onSaved }: Props) {
  const isNew = !listing;
  const [title, setTitle] = useState(listing?.title ?? '');
  const [category, setCategory] = useState(listing?.category ?? 'Tractor');
  const [brand, setBrand] = useState(listing?.brand ?? '');
  const [year, setYear] = useState(listing?.year?.toString() ?? '');
  const [price, setPrice] = useState(listing?.price?.toString() ?? '0');
  const [city, setCity] = useState(listing?.city ?? '');
  const [condition, setCondition] = useState(listing?.condition ?? '');
  const [hours, setHours] = useState(listing?.hours_used?.toString() ?? '');
  const [description, setDescription] = useState(listing?.description ?? '');
  const [status, setStatus] = useState<'active' | 'sold'>(listing?.status ?? 'active');
  const [featured, setFeatured] = useState(listing?.is_featured ?? false);
  const [imagesText, setImagesText] = useState((listing?.image_urls ?? []).join('\n'));
  const [seller, setSeller] = useState(sellerId ?? listing?.seller_id ?? '');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!listing) return;
    setTitle(listing.title);
    setCategory(listing.category);
    setBrand(listing.brand ?? '');
    setYear(listing.year?.toString() ?? '');
    setPrice(listing.price.toString());
    setCity(listing.city ?? '');
    setCondition(listing.condition ?? '');
    setHours(listing.hours_used?.toString() ?? '');
    setDescription(listing.description ?? '');
    setStatus(listing.status);
    setFeatured(listing.is_featured);
    setImagesText((listing.image_urls ?? []).join('\n'));
    setSeller(listing.seller_id);
  }, [listing]);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    const payload = {
      title: title.trim(),
      category: category.trim(),
      brand: brand.trim() || null,
      year: year ? parseInt(year, 10) : null,
      price: parseFloat(price) || 0,
      city: city.trim() || null,
      condition: condition.trim() || null,
      hours_used: hours ? parseInt(hours, 10) : null,
      description: description.trim() || null,
      status,
      is_featured: featured,
      image_urls: imagesText
        .split('\n')
        .map((s) => s.trim())
        .filter(Boolean),
    };

    if (isNew) {
      if (!seller.trim()) {
        setError('Seller user id is required.');
        setBusy(false);
        return;
      }
      const { error: err } = await supabase.from('listings').insert({ ...payload, seller_id: seller.trim() });
      setBusy(false);
      if (err) {
        setError(err.message);
        return;
      }
    } else {
      const { error: err } = await supabase.from('listings').update(payload).eq('id', listing!.id);
      setBusy(false);
      if (err) {
        setError(err.message);
        return;
      }
    }
    onSaved();
    onClose();
  }

  return (
    <div className="dialog-backdrop" role="presentation" onClick={onClose}>
      <form className="card dialog dialog-wide" onClick={(e) => e.stopPropagation()} onSubmit={onSubmit}>
        <div className="dialog-head">
          <h3>{isNew ? 'Create listing' : 'Edit listing'}</h3>
        </div>
        {error && <p className="error">{error}</p>}
        <div className="form-grid">
          {isNew && (
            <label className="field field-span">
              Seller id (UUID)
              <input value={seller} onChange={(e) => setSeller(e.target.value)} required placeholder="4947a160-…" />
            </label>
          )}
          <label className="field field-span">
            Title
            <input value={title} onChange={(e) => setTitle(e.target.value)} required />
          </label>
          <label className="field">
            Category
            <input value={category} onChange={(e) => setCategory(e.target.value)} required />
          </label>
          <label className="field">
            Brand
            <input value={brand} onChange={(e) => setBrand(e.target.value)} />
          </label>
          <label className="field">
            Year
            <input inputMode="numeric" value={year} onChange={(e) => setYear(e.target.value)} />
          </label>
          <label className="field">
            Price (PKR)
            <input inputMode="decimal" value={price} onChange={(e) => setPrice(e.target.value)} required />
          </label>
          <label className="field">
            City
            <input value={city} onChange={(e) => setCity(e.target.value)} />
          </label>
          <label className="field">
            Condition
            <input value={condition} onChange={(e) => setCondition(e.target.value)} />
          </label>
          <label className="field">
            Hours used
            <input inputMode="numeric" value={hours} onChange={(e) => setHours(e.target.value)} />
          </label>
          <label className="field">
            Status
            <select value={status} onChange={(e) => setStatus(e.target.value as 'active' | 'sold')}>
              <option value="active">Active</option>
              <option value="sold">Sold</option>
            </select>
          </label>
          <label className="check-inline">
            <input type="checkbox" checked={featured} onChange={(e) => setFeatured(e.target.checked)} />
            Featured
          </label>
          <label className="field field-span">
            Description
            <textarea className="textarea" rows={4} value={description} onChange={(e) => setDescription(e.target.value)} />
          </label>
          <label className="field field-span">
            Image URLs (one per line)
            <textarea className="textarea" rows={3} value={imagesText} onChange={(e) => setImagesText(e.target.value)} />
          </label>
        </div>
        <div className="dialog-actions">
          <button type="button" className="btn btn-secondary btn-sm" onClick={onClose}>
            Cancel
          </button>
          <button type="submit" className="btn btn-primary btn-sm" disabled={busy}>
            {busy ? 'Saving…' : isNew ? 'Create' : 'Save'}
          </button>
        </div>
      </form>
    </div>
  );
}
