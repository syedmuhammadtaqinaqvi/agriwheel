import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Base URL for email links (localhost:5173 dev, Vercel prod). No trailing slash.
String? get authRedirectBase {
  final v = dotenv.env['AUTH_REDIRECT_BASE']?.trim();
  if (v == null || v.isEmpty) return null;
  return v.endsWith('/') ? v.substring(0, v.length - 1) : v;
}

String? get emailConfirmRedirect {
  final base = authRedirectBase;
  if (base == null) return null;
  return '$base/auth/confirm-email';
}

String? get passwordResetRedirect {
  final base = authRedirectBase;
  if (base == null) return null;
  return '$base/auth/reset-password';
}
