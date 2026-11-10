import { useEffect } from 'react';

type Props = {
  open: boolean;
  title: string;
  body: string;
  confirmLabel?: string;
  onConfirm: () => void;
  onCancel: () => void;
};

export function ConfirmDialog({ open, title, body, confirmLabel = 'Confirm', onConfirm, onCancel }: Props) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onCancel();
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onCancel]);

  if (!open) return null;

  return (
    <div className="dialog-backdrop" role="presentation" onClick={onCancel}>
      <div className="card dialog" role="dialog" onClick={(e) => e.stopPropagation()}>
        <h2 className="page-title">{title}</h2>
        <p>{body}</p>
        <div className="dialog-actions">
          <button type="button" className="btn btn-sm btn-secondary" onClick={onCancel}>
            Cancel
          </button>
          <button type="button" className="btn btn-sm btn-primary" onClick={onConfirm}>
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
}
