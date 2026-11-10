import 'dart:typed_data';

import 'package:storage_client/storage_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';
import '../domain/profile_model.dart';

class ProfileRepository {
  const ProfileRepository();

  Future<ProfileModel?> fetchCurrentProfile() async {
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return null;

    final data = await supabase.from('profiles').select().eq('id', uid).maybeSingle();
    if (data == null) return null;
    return ProfileModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<ProfileModel> updateProfile({
    String? fullName,
    String? city,
    String? shopName,
    String? address,
    List<String>? interests,
    String? avatarUrl,
  }) async {
    final uid = supabase.auth.currentUser!.id;
    final patch = <String, dynamic>{};
    if (fullName != null) patch['full_name'] = fullName;
    if (city != null) patch['city'] = city;
    if (shopName != null) patch['shop_name'] = shopName;
    if (address != null) patch['address'] = address;
    if (interests != null) patch['interests'] = interests;
    if (avatarUrl != null) patch['avatar_url'] = avatarUrl;

    final data = await supabase.from('profiles').update(patch).eq('id', uid).select().single();
    return ProfileModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> uploadVerificationDoc({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final uid = supabase.auth.currentUser!.id;
    await supabase.storage.from('verification-docs').uploadBinary(
          '$uid/$fileName',
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );
  }
}
