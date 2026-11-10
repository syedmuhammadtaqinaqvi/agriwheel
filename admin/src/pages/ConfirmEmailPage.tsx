import { useEffect, useState } from 'react';

import { Loading } from '../components/Loading';
import { supabase } from '../lib/supabase';

type State = 'loading' | 'success' | 'error';

export function ConfirmEmailPage() {
  const [state, setState] = useState<State>('loading');
  const [message, setMessage] = useState('');

  useEffect(() => {
    (async () => {
      const search = new URLSearchParams(window.location.search);
      const hash = new URLSearchParams(window.location.hash.replace(/^#/, ''));
      const errDesc = hash.get('error_description') ?? search.get('error_description');
      if (errDesc) {
        setState('error');
        setMessage(decodeURIComponent(errDesc.replace(/\+/g, ' ')));
        return;
      }

      const code = search.get('code');
      if (code) {
        const { error: exchErr } = await supabase.auth.exchangeCodeForSession(code);
        if (exchErr) {
          setState('error');
          setMessage(exchErr.message);
          return;
        }
        await supabase.auth.signOut();
        setState('success');
        return;
      }

      const { data, error } = await supabase.auth.getSession();
      if (error) {
        setState('error');
        setMessage(error.message);
        return;
      }
      if (data.session) {
        await supabase.auth.signOut();
        setState('success');
        return;
      }

      setState('error');
      setMessage('Link invalid or expired. Sign up again or request a new confirmation email from Supabase.');
    })();
  }, []);

  if (state === 'loading') return <Loading label="Confirming email…" />;

  return (
    <div className="login-page">
      <div className="card login-card">
        <h1>{state === 'success' ? 'Email confirmed' : 'Confirmation failed'}</h1>
        {state === 'success' ? (
          <p>Open the AgriWheel app and log in with your email and password.</p>
        ) : (
          <p className="error">{message}</p>
        )}
      </div>
    </div>
  );
}
