import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.label,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.brand, fontWeight: FontWeight.w600)),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: AppSpacing.fieldHeight,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: AppColors.brand, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileLockedPhoneField extends StatelessWidget {
  const ProfileLockedPhoneField({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phone Number (Verified - Locked)',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.brand, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(999)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 14),
                  SizedBox(width: 4),
                  Text('Verified', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: AppSpacing.fieldHeight,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.call, color: AppColors.brand, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(phone, style: const TextStyle(fontWeight: FontWeight.w500))),
              const Icon(Icons.lock_outline, color: AppColors.brand, size: 20),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: AppColors.secondary),
            SizedBox(width: 6),
            Expanded(
              child: Text('Contact agricultural support desk to modify verified number', style: TextStyle(fontSize: 12, color: AppColors.brand)),
            ),
          ],
        ),
      ],
    );
  }
}
