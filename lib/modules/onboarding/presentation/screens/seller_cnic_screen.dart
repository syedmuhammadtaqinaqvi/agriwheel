import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_stack_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/profile/data/profile_repository.dart';

class SellerCnicScreen extends StatefulWidget {
  const SellerCnicScreen({super.key});

  @override
  State<SellerCnicScreen> createState() => _SellerCnicScreenState();
}

class _SellerCnicScreenState extends State<SellerCnicScreen> {
  final _repo = const ProfileRepository();
  final _picker = ImagePicker();
  String? _frontName;
  String? _backName;
  bool _uploading = false;

  Future<void> _pick(bool front) async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _uploading = true);
    try {
      final name = front ? 'cnic_front.jpg' : 'cnic_back.jpg';
      await _repo.uploadVerificationDoc(fileName: name, bytes: bytes);
      setState(() {
        if (front) {
          _frontName = name;
        } else {
          _backName = name;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _finish() async {
    final auth = context.read<AuthSessionProvider>();
    await auth.refreshProfile();
    if (!mounted) return;
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthStackAppBar(screenTitle: 'Seller Verification'),
      body: ResponsiveBody(
        child: ListView(
          children: [
            _ProgressBar(),
            const SizedBox(height: AppSpacing.md),
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.labelLarge,
                children: const [
                  TextSpan(text: 'Verify your identity with CNIC for a '),
                  TextSpan(text: 'Verified Seller', style: TextStyle(backgroundColor: AppColors.secondaryContainer)),
                  TextSpan(text: ' badge and priority listing.'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.brand, width: 2),
              ),
              child: const Text('Verified sellers get more buyer calls on AgriWheel'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upload National ID Card (CNIC)', style: Theme.of(context).textTheme.titleMedium),
                Chip(label: const Text('OPTIONAL'), side: const BorderSide(color: AppColors.brand, width: 2)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _UploadTile(title: 'CNIC Front Side', icon: Icons.badge_outlined, uploaded: _frontName != null, onTap: () => _pick(true)),
            const SizedBox(height: AppSpacing.md),
            _UploadTile(title: 'CNIC Back Side', icon: Icons.credit_card, uploaded: _backName != null, onTap: () => _pick(false)),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.brand, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('PHOTO GUIDELINES:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  _Guideline('All 4 corners of CNIC must be clearly visible'),
                  _Guideline('No glare or flash reflection covering details'),
                  _Guideline('13-digit identity number and expiry clearly legible'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Submit for Verification',
              icon: Icons.arrow_forward,
              isLoading: _uploading,
              onPressed: _finish,
            ),
            TextButton(
              onPressed: _uploading ? null : _finish,
              child: const Text('Skip for now'),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 16),
                const SizedBox(width: 6),
                Text('Your documents are encrypted and kept strictly confidential.', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('STEP 4 OF 4 • TRUST & SAFETY', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
            const Chip(label: Text('75% Complete'), backgroundColor: AppColors.secondaryContainer),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: 0.75, color: AppColors.secondaryContainer, minHeight: 8, borderRadius: BorderRadius.circular(8)),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.title,
    required this.icon,
    required this.uploaded,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.brand, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: uploaded ? AppColors.secondaryContainer : AppColors.white,
              child: Icon(uploaded ? Icons.check : icon),
            ),
            const SizedBox(height: 6),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            Text(uploaded ? 'Uploaded' : 'Tap to capture or upload photo', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Guideline extends StatelessWidget {
  const _Guideline(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
