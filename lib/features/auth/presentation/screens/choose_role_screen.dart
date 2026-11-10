import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/app_prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_body.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  String? _role;

  Future<void> _continue() async {
    if (_role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select buyer or seller to continue.')),
      );
      return;
    }
    await AppPrefs.setPendingSignupRole(_role!);
    if (!mounted) return;
    context.go(_role == 'seller' ? RouteNames.sellerSignup : RouteNames.buyerSignup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ResponsiveBody(
        safeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(
              'How will you use AgriWheel?',
              textAlign: TextAlign.center,
              style: AppTypography.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.green),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Buyers browse and chat. Sellers post and manage ads.',
              textAlign: TextAlign.center,
              style: AppTypography.poppins(fontSize: 14, color: AppColors.green),
            ),
            const SizedBox(height: AppSpacing.lg),
            _RoleOptionTile(
              title: 'I want to Buy',
              subtitle: 'Browse tractors, harvesters & trolleys',
              icon: Icons.shopping_cart_outlined,
              selected: _role == 'buyer',
              onTap: () => setState(() => _role = 'buyer'),
            ),
            const SizedBox(height: AppSpacing.md),
            _RoleOptionTile(
              title: 'I want to Sell',
              subtitle: 'List machinery for buyers nationwide',
              icon: Icons.storefront_outlined,
              selected: _role == 'seller',
              onTap: () => setState(() => _role = 'seller'),
            ),
            const Spacer(),
            AppButton(label: 'Continue', onPressed: _continue, variant: _role == null ? AppButtonVariant.secondary : AppButtonVariant.primary),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.go(RouteNames.login),
              child: Text(
                'Already have an account? Log In',
                style: AppTypography.poppins(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _RoleOptionTile extends StatelessWidget {
  const _RoleOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Ink(
          height: 88,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(color: AppColors.green, width: selected ? 3 : 2),
            color: selected ? AppColors.yellow.withValues(alpha: 0.12) : AppColors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(color: AppColors.green, width: 2),
                  color: selected ? AppColors.yellow : AppColors.white,
                ),
                child: Icon(icon, size: 24, color: AppColors.green),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.green)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.poppins(fontSize: 12, color: AppColors.green)),
                  ],
                ),
              ),
              if (selected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 18, color: AppColors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
