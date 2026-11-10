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

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  final _repo = const ProfileRepository();
  String _city = 'Lahore';
  final _interests = <String>{'Tractor'};
  bool _saving = false;

  static const _cities = [
    'Lahore',
    'Faisalabad',
    'Multan',
    'Rahim Yar Khan',
    'Hyderabad',
    'Sargodha',
    'Islamabad',
    'Karachi',
  ];

  Future<void> _save({bool skipOptional = false}) async {
    if (_interests.isEmpty && !skipOptional) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick at least one interest or skip for now.')));
      return;
    }
    if (skipOptional && _interests.isEmpty) {
      // Still save city so profile setup is marked complete.
    }
    setState(() => _saving = true);
    try {
      await _repo.updateProfile(city: _city, interests: _interests.toList());
      if (!mounted) return;
      final auth = context.read<AuthSessionProvider>();
      await auth.refreshProfile();
      if (!mounted) return;
      context.go(RouteNames.home);
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
      appBar: const AuthStackAppBar(screenTitle: 'Profile Details'),
      body: ResponsiveBody(
        child: ListView(
          children: [
            const _ProgressBar(step: 3, total: 3, percent: 1),
            const SizedBox(height: AppSpacing.md),
            Text('Tailor Your Machinery Feed', style: Theme.of(context).textTheme.displaySmall),
            Text('Tell us where you farm and what machinery you are looking for.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
              child: const Text('Verified listings closest to your city will appear first!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Select Your City', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              value: _city,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.pin_drop)),
              items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _city = v ?? _city),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('What are you looking to buy?', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Tractor', 'Harvester', 'Trolley', 'Tools'].map((label) {
                final selected = _interests.contains(label);
                return FilterChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      if (selected) {
                        _interests.remove(label);
                      } else {
                        _interests.add(label);
                      }
                    });
                  },
                  selectedColor: AppColors.secondaryContainer,
                  showCheckmark: true,
                  side: const BorderSide(color: AppColors.brand, width: 2),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Start Browsing',
              icon: Icons.arrow_forward,
              isLoading: _saving,
              onPressed: _save,
            ),
            TextButton(
              onPressed: _saving ? null : () => _save(skipOptional: true),
              child: const Text('SKIP FOR NOW'),
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
            Text('STEP $step OF $total • BUYER PROFILE', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
            Text('Almost Done!', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: percent, color: AppColors.secondaryContainer, backgroundColor: AppColors.surfaceContainer, minHeight: 8, borderRadius: BorderRadius.circular(8)),
      ],
    );
  }
}
