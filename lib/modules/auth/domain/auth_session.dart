import 'package:flutter/foundation.dart';

enum UserRole { guest, buyer, seller }

class AuthSession extends ChangeNotifier {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  UserRole role = UserRole.guest;
  String displayName = '';
  String phone = '';
  String city = 'Punjab, PK';
  String dealerName = '';
  String address = '';
  String? avatarUrl;

  bool get isLoggedIn => role != UserRole.guest;

  void loginAsBuyer({String? name, String? phoneNumber}) {
    role = UserRole.buyer;
    displayName = name ?? 'Muhammad Ahmad';
    phone = phoneNumber ?? '+92 300 1234567';
    city = 'Lahore, Punjab';
    notifyListeners();
  }

  void loginAsSeller({String? name, String? phoneNumber}) {
    role = UserRole.seller;
    displayName = name ?? 'Haji Rafiq Chaudhry';
    phone = phoneNumber ?? '+92 300 9876543';
    dealerName = 'Al-Madina Agro Traders';
    address = 'Shop #14, Grain Market Bypass Road';
    city = 'Sargodha, Punjab';
    avatarUrl = null;
    notifyListeners();
  }

  void logout() {
    role = UserRole.guest;
    displayName = '';
    phone = '';
    dealerName = '';
    address = '';
    avatarUrl = null;
    notifyListeners();
  }

  /// Sync legacy UI from Supabase profiles row (Phase 2+).
  void applySupabaseProfile({
    required String roleDb,
    String? fullName,
    String? phoneNumber,
    String? cityValue,
    String? shopName,
    String? addressValue,
    String? avatar,
  }) {
    role = roleDb == 'seller' ? UserRole.seller : UserRole.buyer;
    if (fullName != null) displayName = fullName;
    if (phoneNumber != null) phone = phoneNumber;
    if (cityValue != null) city = cityValue;
    if (shopName != null) dealerName = shopName;
    if (addressValue != null) address = addressValue;
    if (avatar != null) avatarUrl = avatar;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? cityValue,
    String? dealer,
    String? showroomAddress,
    String? newAvatarUrl,
  }) {
    if (name != null) displayName = name;
    if (cityValue != null) city = cityValue;
    if (dealer != null) dealerName = dealer;
    if (showroomAddress != null) address = showroomAddress;
    if (newAvatarUrl != null) avatarUrl = newAvatarUrl;
    notifyListeners();
  }
}
