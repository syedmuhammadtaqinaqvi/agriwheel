export function ImageThumb({ src, alt = '' }: { src: string | null | undefined; alt?: string }) {
  if (!src) {
    return (
      <div className="thumb thumb-empty" aria-hidden>
        —
      </div>
    );
  }
  return <img className="thumb" src={src} alt={alt} loading="lazy" />;
}
