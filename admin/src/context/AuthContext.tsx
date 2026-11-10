import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react';
import type { Session } from '@supabase/supabase-js';

import { supabase } from '../lib/supabase';
import type { ProfileRow } from '../lib/types';

type AuthState = {
  session: Session | null;
  profile: ProfileRow | null;
  loading: boolean;
  isAdmin: boolean;
  signIn: (email: string, password: string) => Promise<string | null>;
  signOut: () => Promise<void>;
  refreshProfile: () => Promise<void>;
};

const AuthContext = createContext<AuthState | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<ProfileRow | null>(null);
  const [loading, setLoading] = useState(true);

  const loadProfile = useCallback(async (userId: string) => {
    const { data, error } = await supabase
      .from('profiles')
      .select('id, full_name, email, phone, city, role, shop_name, address, interests, is_verified, is_admin, created_at')
      .eq('id', userId)
      .maybeSingle();

    if (error) throw error;
    setProfile(data as ProfileRow | null);
  }, []);

  const refreshProfile = useCallback(async () => {
    const uid = session?.user.id;
    if (!uid) return;
    await loadProfile(uid);
  }, [loadProfile, session?.user.id]);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      setSession(data.session);
      if (data.session?.user.id) {
        loadProfile(data.session.user.id)
          .catch(() => setProfile(null))
          .finally(() => setLoading(false));
      } else {
        setLoading(false);
      }
    });

    const { data: sub } = supabase.auth.onAuthStateChange((_event, next) => {
      setSession(next);
      if (next?.user.id) {
        loadProfile(next.user.id).catch(() => setProfile(null));
      } else {
        setProfile(null);
      }
    });

    return () => sub.subscription.unsubscribe();
  }, [loadProfile]);

  const signIn = useCallback(
    async (email: string, password: string) => {
      const { data, error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) return error.message;
      if (!data.session) return 'No session returned.';
      await loadProfile(data.session.user.id);
      return null;
    },
    [loadProfile],
  );

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
    setProfile(null);
  }, []);

  const isAdmin = Boolean(profile?.is_admin);

  const value = useMemo(
    () => ({
      session,
      profile,
      loading,
      isAdmin,
      signIn,
      signOut,
      refreshProfile,
    }),
    [session, profile, loading, isAdmin, signIn, signOut, refreshProfile],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
