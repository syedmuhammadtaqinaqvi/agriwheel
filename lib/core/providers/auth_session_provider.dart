import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/profile/domain/profile_model.dart';
import '../../modules/auth/domain/auth_session.dart';
import '../supabase/supabase_client.dart';

class AuthSessionProvider extends ChangeNotifier {
  AuthSessionProvider() {
    _session = supabase.auth.currentSession;
    _authSub = supabase.auth.onAuthStateChange.listen((data) async {
      _session = data.session;
      if (_session != null) {
        await refreshProfile();
      } else {
        _profile = null;
        AuthSession.instance.logout();
        notifyListeners();
      }
    });
    if (_session != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(refreshProfile());
      });
    }
  }

  final _authRepo = const AuthRepository();
  final _profileRepo = const ProfileRepository();

  Session? _session;
  ProfileModel? _profile;
  bool _loadingProfile = false;
  Future<void>? _refreshInFlight;
  late final StreamSubscription<AuthState> _authSub;

  bool get isLoggedIn => _session != null;

  Session? get session => _session;

  ProfileModel? get profile => _profile;

  bool get isLoadingProfile => _loadingProfile;

  bool get needsProfileSetup => _profile != null && !_profile!.isProfileComplete;

  String? get postAuthRoute {
    if (_profile == null) return null;
    if (_profile!.isProfileComplete) return null;
  return _profile!.isSeller ? '/onboarding/seller-dealership' : '/onboarding/buyer-profile';
  }

  /// Waits for profile after sign-in without duplicate Supabase calls.
  Future<void> ensureProfileLoaded() {
    return refreshProfile();
  }

  Future<void> refreshProfile() {
    return _refreshInFlight ??= _refreshProfileImpl().whenComplete(() => _refreshInFlight = null);
  }

  Future<void> _refreshProfileImpl() async {
    _loadingProfile = true;
    notifyListeners();
    try {
      _profile = await _profileRepo.fetchCurrentProfile();
      if (_profile != null) {
        final p = _profile!;
        AuthSession.instance.applySupabaseProfile(
          roleDb: p.role,
          fullName: p.fullName,
          phoneNumber: p.phone,
          cityValue: p.city,
          shopName: p.shopName,
          addressValue: p.address,
          avatar: p.avatarUrl,
        );
      }
    } catch (e) {
      debugPrint('Profile load failed: $e');
    } finally {
      _loadingProfile = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    _profile = null;
    AuthSession.instance.logout();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}
