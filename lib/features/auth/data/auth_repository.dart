import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/auth_redirect.dart';
import '../../../core/supabase/supabase_client.dart';

class AuthRepository {
  const AuthRepository();

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    return supabase.auth.signUp(
      email: email.trim(),
      password: password,
      emailRedirectTo: emailConfirmRedirect,
      data: {
        'full_name': fullName.trim(),
        'phone': phone.trim(),
        'role': role,
      },
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => supabase.auth.signOut();

  Future<void> resetPasswordForEmail(String email) {
    return supabase.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: passwordResetRedirect,
    );
  }

  Future<UserResponse> updatePassword(String newPassword) {
    return supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
}
