import { useState, type FormEvent } from 'react';
import { Navigate } from 'react-router-dom';

import { mapSupabaseAuthError } from '../lib/supabase';
import { useAuth } from '../context/AuthContext';
import { Loading } from '../components/Loading';

export function LoginPage() {
  const { signIn, session, isAdmin, loading } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  if (loading) return <Loading />;
  if (session && isAdmin) return <Navigate to="/" replace />;

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    const err = await signIn(email.trim(), password);
    if (err) setError(mapSupabaseAuthError(err));
    setBusy(false);
  }

  return (
    <div className="login-page">
      <form className="card login-card" onSubmit={onSubmit}>
        <h1>AgriWheel Admin</h1>
        <p className="muted">Moderator sign in (Supabase email / password)</p>
        <label className="field">
          Email
          <input type="email" autoComplete="username" value={email} onChange={(e) => setEmail(e.target.value)} required />
        </label>
        <label className="field">
          Password
          <input type="password" autoComplete="current-password" value={password} onChange={(e) => setPassword(e.target.value)} required />
        </label>
        {error && <p className="error">{error}</p>}
        <button type="submit" className="btn btn-primary" disabled={busy}>
          {busy ? 'Signing in…' : 'Log in'}
        </button>
      </form>
    </div>
  );
}
