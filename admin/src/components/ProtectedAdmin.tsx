import { Navigate, Outlet } from 'react-router-dom';

import { useAuth } from '../context/AuthContext';
import { Loading } from './Loading';

export function ProtectedAdmin() {
  const { session, loading, isAdmin } = useAuth();

  if (loading) return <Loading />;
  if (!session) return <Navigate to="/login" replace />;
  if (!isAdmin) {
    return (
      <div className="card card-error">
        <h2>Admin access required</h2>
        <p>
          Your account is not an admin. In Supabase SQL Editor run{' '}
          <code>admin_rls.sql</code>, then set <code>is_admin = true</code> on your profile row.
        </p>
      </div>
    );
  }

  return <Outlet />;
}
