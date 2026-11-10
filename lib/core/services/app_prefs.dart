import 'package:shared_preferences/shared_preferences.dart';

abstract final class AppPrefs {
  static const _onboardingKey = 'onboarding_completed';
  static const _roleKey = 'pending_signup_role';

  static SharedPreferences? _cache;

  /// Call from [main] so splash/login never wait on a cold prefs open.
  static Future<void> warmUp() async {
    _cache ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> _prefs() async {
    if (_cache != null) return _cache!;
    _cache = await SharedPreferences.getInstance();
    return _cache!;
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await _prefs();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await _prefs();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<String?> pendingSignupRole() async {
    final prefs = await _prefs();
    return prefs.getString(_roleKey);
  }

  static Future<void> setPendingSignupRole(String role) async {
    final prefs = await _prefs();
    await prefs.setString(_roleKey, role);
  }

  static Future<void> clearPendingSignupRole() async {
    final prefs = await _prefs();
    await prefs.remove(_roleKey);
  }
}
