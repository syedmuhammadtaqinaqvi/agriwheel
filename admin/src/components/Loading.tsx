export function Loading({ label = 'Loading…' }: { label?: string }) {
  return (
    <div className="loading">
      <div className="spinner" aria-hidden />
      <p>{label}</p>
    </div>
  );
}
