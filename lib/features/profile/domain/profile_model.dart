class ProfileModel {
  const ProfileModel({
    required this.id,
    this.fullName,
    this.phone,
    this.city,
    required this.role,
    this.shopName,
    this.address,
    this.avatarUrl,
    this.interests = const [],
    this.isVerified = false,
  });

  final String id;
  final String? fullName;
  final String? phone;
  final String? city;
  final String role;
  final String? shopName;
  final String? address;
  final String? avatarUrl;
  final List<String> interests;
  final bool isVerified;

  bool get isSeller => role == 'seller';
  bool get isBuyer => role == 'buyer';

  bool get isProfileComplete {
    if (isBuyer) {
      return city != null && city!.trim().isNotEmpty;
    }
    if (isSeller) {
      return shopName != null &&
          shopName!.trim().isNotEmpty &&
          city != null &&
          city!.trim().isNotEmpty &&
          address != null &&
          address!.trim().isNotEmpty;
    }
    return false;
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    final interestsRaw = map['interests'];
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String?,
      phone: map['phone'] as String?,
      city: map['city'] as String?,
      role: map['role'] as String? ?? 'buyer',
      shopName: map['shop_name'] as String?,
      address: map['address'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      interests: interestsRaw is List ? interestsRaw.map((e) => e.toString()).toList() : const [],
      isVerified: map['is_verified'] as bool? ?? false,
    );
  }

  ProfileModel copyWith({
    String? fullName,
    String? phone,
    String? city,
    String? shopName,
    String? address,
    String? avatarUrl,
    List<String>? interests,
  }) {
    return ProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      role: role,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interests: interests ?? this.interests,
      isVerified: isVerified,
    );
  }
}
