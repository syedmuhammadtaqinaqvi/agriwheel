import { useEffect, useState, type FormEvent } from 'react';

import { Loading } from '../components/Loading';
import { mapSupabaseAuthError } from '../lib/supabase';
import { supabase } from '../lib/supabase';

export function ResetPasswordPage() {
  const [ready, setReady] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [done, setDone] = useState(false);
  const [password, setPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    (async () => {
      const search = new URLSearchParams(window.location.search);
      const hashParams = new URLSearchParams(window.location.hash.replace(/^#/, ''));
      const errDesc = hashParams.get('error_description') ?? search.get('error_description');
      if (errDesc) {
        setError(decodeURIComponent(errDesc.replace(/\+/g, ' ')));
        setReady(true);
        return;
      }

      const code = search.get('code');
      if (code) {
        const { error: exchErr } = await supabase.auth.exchangeCodeForSession(code);
        if (exchErr) setError(exchErr.message);
        setReady(true);
        return;
      }

      const { data, error: sessErr } = await supabase.auth.getSession();
      if (sessErr) setError(sessErr.message);
      else if (!data.session) setError('Reset link invalid or expired. Request a new email from the app.');
      setReady(true);
    })();
  }, []);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    if (password.length < 6) {
      setError('Use at least 6 characters.');
      return;
    }
    if (password !== confirm) {
      setError('Passwords do not match.');
      return;
    }
    setBusy(true);
    setError(null);
    const { error: err } = await supabase.auth.updateUser({ password });
    setBusy(false);
    if (err) {
      setError(mapSupabaseAuthError(err.message));
      return;
    }
    await supabase.auth.signOut();
    setDone(true);
  }

  if (!ready) return <Loading label="Loading reset link…" />;

  if (done) {
    return (
      <div className="login-page">
        <div className="card login-card">
          <h1>Password updated</h1>
          <p>Open AgriWheel and log in with your new password.</p>
        </div>
      </div>
    );
  }

  if (error && !supabase) {
    return (
      <div className="login-page">
        <div className="card login-card">
          <p className="error">{error}</p>
        </div>
      </div>
    );
  }

  const blocked = Boolean(error && !password);

  return (
    <div className="login-page">
      <form className="card login-card" onSubmit={onSubmit}>
        <h1>Set new password</h1>
        {error && <p className="error">{error}</p>}
        {!blocked && (
          <>
            <label className="field">
              New password
              <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} required minLength={6} />
            </label>
            <label className="field">
              Confirm password
              <input type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} required minLength={6} />
            </label>
            <button type="submit" className="btn btn-primary" disabled={busy}>
              {busy ? 'Saving…' : 'Save password'}
            </button>
          </>
        )}
      </form>
    </div>
  );
}
