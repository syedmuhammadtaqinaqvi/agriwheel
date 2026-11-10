import { supabaseConfigError } from '../lib/supabase';

export function EnvGuard({ children }: { children: React.ReactNode }) {
  if (supabaseConfigError) {
    return (
      <div className="login-page">
        <div className="card card-error">
          <h1>Configuration required</h1>
          <p>{supabaseConfigError}</p>
          <pre className="env-hint">
            {`cd admin
Copy-Item .env.example .env
# Paste SUPABASE_URL → VITE_SUPABASE_URL
# Paste SUPABASE_ANON_KEY → VITE_SUPABASE_ANON_KEY`}
          </pre>
        </div>
      </div>
    );
  }
  return children;
}
