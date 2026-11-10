import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';

import { EnvGuard } from './components/EnvGuard';
import { Layout } from './components/Layout';
import { ProtectedAdmin } from './components/ProtectedAdmin';
import { AuthProvider } from './context/AuthContext';
import { ConfirmEmailPage } from './pages/ConfirmEmailPage';
import { DashboardPage } from './pages/DashboardPage';
import { ListingDetailPage } from './pages/ListingDetailPage';
import { ListingsPage } from './pages/ListingsPage';
import { LoginPage } from './pages/LoginPage';
import { ResetPasswordPage } from './pages/ResetPasswordPage';
import { SellersPage } from './pages/SellersPage';
import { SettingsPage } from './pages/SettingsPage';
import { UsersPage } from './pages/UsersPage';

export function App() {
  return (
    <EnvGuard>
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/auth/confirm-email" element={<ConfirmEmailPage />} />
          <Route path="/auth/reset-password" element={<ResetPasswordPage />} />
          <Route element={<ProtectedAdmin />}>
            <Route element={<Layout />}>
              <Route path="/" element={<DashboardPage />} />
              <Route path="/users" element={<UsersPage />} />
              <Route path="/sellers" element={<SellersPage />} />
              <Route path="/listings" element={<ListingsPage />} />
              <Route path="/listings/:id" element={<ListingDetailPage />} />
              <Route path="/settings" element={<SettingsPage />} />
            </Route>
          </Route>
          <Route path="*" element={<Navigate to="/login" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
    </EnvGuard>
  );
}
