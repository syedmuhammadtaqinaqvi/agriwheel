import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_stack_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/profile/data/profile_repository.dart';

class SellerDealershipScreen extends StatefulWidget {
  const SellerDealershipScreen({super.key});

  @override
  State<SellerDealershipScreen> createState() => _SellerDealershipScreenState();
}

class _SellerDealershipScreenState extends State<SellerDealershipScreen> {
  final _shopCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _repo = const ProfileRepository();
  String _city = 'Lahore';
  bool _saving = false;

  @override
  void dispose() {
    _shopCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_shopCtrl.text.trim().isEmpty || _addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter shop name and address.')));
      return;
    }
    setState(() => _saving = true);
    try {
      await _repo.updateProfile(
        shopName: _shopCtrl.text.trim(),
        city: _city,
        address: _addressCtrl.text.trim(),
      );
      if (!mounted) return;
      final auth = context.read<AuthSessionProvider>();
      await auth.refreshProfile();
      if (!mounted) return;
      context.push(RouteNames.sellerCnic);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthStackAppBar(screenTitle: 'Profile Details'),
      body: ResponsiveBody(
        child: ListView(
          children: [
            const _ProgressBar(step: 3, total: 4, percent: 0.75),
            const SizedBox(height: AppSpacing.md),
            Chip(
              avatar: const Icon(Icons.storefront, size: 16),
              label: const Text('Authorized Dealership'),
              backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.2),
            ),
            Text('Dealership Identity', style: Theme.of(context).textTheme.titleLarge),
            Text(
              'Set up your dealership or showroom details.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _shopCtrl,
              decoration: const InputDecoration(labelText: 'Shop / Dealer Name', prefixIcon: Icon(Icons.domain)),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _city,
              decoration: const InputDecoration(labelText: 'City', prefixIcon: Icon(Icons.location_on)),
              items: const [
                DropdownMenuItem(value: 'Lahore', child: Text('Lahore')),
                DropdownMenuItem(value: 'Faisalabad', child: Text('Faisalabad')),
                DropdownMenuItem(value: 'Multan', child: Text('Multan')),
                DropdownMenuItem(value: 'Sargodha', child: Text('Sargodha')),
                DropdownMenuItem(value: 'Karachi', child: Text('Karachi')),
              ],
              onChanged: (v) => setState(() => _city = v ?? _city),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _addressCtrl,
              decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.pin_drop)),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.brand, width: 2),
              ),
              child: const Text('Completing CNIC verification grants a Verified Seller badge on your ads.'),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Continue to Verification',
              icon: Icons.arrow_forward,
              isLoading: _saving,
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step, required this.total, required this.percent});
  final int step;
  final int total;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('STEP $step OF $total', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
            Text('${(percent * 100).round()}% Completed', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: percent, color: AppColors.brand, backgroundColor: AppColors.surfaceLow, minHeight: 8, borderRadius: BorderRadius.circular(8)),
      ],
    );
  }
}
