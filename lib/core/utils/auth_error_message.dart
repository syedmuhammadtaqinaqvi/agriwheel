import 'package:supabase_flutter/supabase_flutter.dart';

String friendlyAuthError(Object error) {
  if (error is AuthException) {
    final m = error.message.toLowerCase();
    if (m.contains('invalid login credentials') || m.contains('invalid credentials')) {
      return 'Wrong email or password.';
    }
    if (m.contains('user already registered') || m.contains('already been registered')) {
      return 'This email is already registered. Try logging in.';
    }
    if (m.contains('password') && m.contains('weak')) {
      return 'Password is too weak. Use at least 6 characters.';
    }
    if (m.contains('email not confirmed')) {
      return 'Check your email to confirm your account, then log in.';
    }
    if (m.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    return error.message;
  }
  return error.toString();
}
