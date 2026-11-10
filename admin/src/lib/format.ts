export function formatRs(price: number) {
  return `Rs ${Math.round(price).toLocaleString('en-PK')}`;
}

export function formatDate(iso: string) {
  try {
    return new Date(iso).toLocaleDateString('en-PK', { year: 'numeric', month: 'short', day: 'numeric' });
  } catch {
    return iso;
  }
}
