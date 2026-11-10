import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/edit_profile_app_bar.dart';
import '../../../auth/domain/auth_session.dart';
import '../widgets/profile_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _dealer;
  late final TextEditingController _address;
  late String _city;
  bool _saving = false;
  OverlayEntry? _toastEntry;

  static const _cities = [
    'Sargodha, Punjab',
    'Faisalabad, Punjab',
    'Multan, Punjab',
    'Lahore, Punjab',
    'Bahawalpur, Punjab',
    'Rahim Yar Khan, Punjab',
    'Sukkur, Sindh',
    'Hyderabad, Sindh',
    'Peshawar, Khyber Pakhtunkhwa',
    'Quetta, Balochistan',
  ];

  @override
  void initState() {
    super.initState();
    final s = AuthSession.instance;
    _name = TextEditingController(text: s.displayName);
    _dealer = TextEditingController(text: s.dealerName);
    _address = TextEditingController(text: s.address);
    _city = _cities.contains(s.city) ? s.city : _cities.first;
  }

  @override
  void dispose() {
    _removeToast();
    _name.dispose();
    _dealer.dispose();
    _address.dispose();
    super.dispose();
  }

  void _removeToast() {
    _toastEntry?.remove();
    _toastEntry = null;
  }

  void _showToast(String message) {
    _removeToast();
    final overlay = Overlay.of(context);
    _toastEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 72,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity: 1,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: AppColors.onSurface),
                    const SizedBox(width: 6),
                    Flexible(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_toastEntry!);
    Future<void>.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) _removeToast();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    AuthSession.instance.updateProfile(
      name: _name.text.trim(),
      cityValue: _city,
      dealer: _dealer.text.trim(),
      showroomAddress: _address.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    _showToast('Profile details updated successfully!');
  }

  void _onPhotoTap() {
    _showToast('Photo selected! Tap save to apply.');
  }

  @override
  Widget build(BuildContext context) {
    final session = AuthSession.instance;
    final isSeller = session.role == UserRole.seller;
    final avatarUrl = session.avatarUrl;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: EditProfileAppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 112),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _onPhotoTap,
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: AppColors.brand, shape: BoxShape.circle),
                          child: avatarUrl != null
                              ? AgriAvatarImage(networkUrl: avatarUrl, radius: 37)
                              : const CircleAvatar(radius: 37, backgroundImage: AssetImage(AppAssets.appIcon)),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 2),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4)],
                            ),
                            child: const Icon(Icons.photo_camera, size: 18, color: AppColors.brand),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _onPhotoTap,
                    child: const Text('Change Profile Photo', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.brand)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileFormField(
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    child: TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ProfileLockedPhoneField(phone: session.phone),
                  const SizedBox(height: AppSpacing.md),
                  ProfileFormField(
                    label: 'City / District',
                    icon: Icons.location_on,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _city,
                        items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _city = v ?? _city),
                      ),
                    ),
                  ),
                  if (isSeller) ...[
                    const SizedBox(height: AppSpacing.md),
                    ProfileFormField(
                      label: 'Shop / Dealer Name',
                      icon: Icons.storefront,
                      child: TextFormField(
                        controller: _dealer,
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: 'e.g. Chaudhry Machinery Hub'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ProfileFormField(
                      label: 'Showroom Address',
                      icon: Icons.pin_drop,
                      child: TextFormField(
                        controller: _address,
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, hintText: 'Street or Chowk location'),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.secondaryContainer,
                          child: Icon(Icons.verified_user, color: AppColors.brand),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSeller ? 'Verified Agro Merchant' : 'Verified Equipment Buyer',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brand),
                              ),
                              Text(
                                isSeller
                                    ? 'Your profile carries an authenticated merchant insignia across tractor and harvesters trade catalogs.'
                                    : 'Your buyer badge helps sellers trust inquiries across Punjab & Sindh mandi listings.',
                                style: const TextStyle(fontSize: 12, color: AppColors.brand, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 8,
        color: AppColors.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(AppSpacing.fieldHeight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
              ),
              child: _saving
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                        SizedBox(width: 8),
                        Text('Updating Profile...'),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save, size: 20),
                        SizedBox(width: 8),
                        Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
