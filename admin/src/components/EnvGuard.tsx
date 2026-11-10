import { supabaseConfigError } from '../lib/supabase';

export function EnvGuard({ children }: { children: React.ReactNode }) {
  if (supabaseConfigError) {
    return (
      <div className="login-page">
        <div className="card card-error">
          <h1>Configuration required</h1>
          <p>{supabaseConfigError}</p>
          <pre className="env-hint">
            {`Vercel → Settings → Environment Variables:
SUPABASE_URL (or VITE_SUPABASE_URL)
SUPABASE_ANON_KEY (or VITE_SUPABASE_ANON_KEY)
Then Deployments → Redeploy.`}
          </pre>
        </div>
      </div>
    );
  }
  return children;
}
