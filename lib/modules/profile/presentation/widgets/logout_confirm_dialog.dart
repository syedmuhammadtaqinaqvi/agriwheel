import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Centered session dialog (HTML logout modal).
Future<void> showLogoutConfirmDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.brand.withValues(alpha: 0.8),
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(999)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shield, size: 16),
                  SizedBox(width: 4),
                  Text('SESSION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.brand,
              child: const Icon(Icons.logout, color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Log out?', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'You will need to log in again to chat and post ads.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(AppSpacing.fieldHeight),
                      side: const BorderSide(color: AppColors.brand, width: 2),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ctx.read<AuthSessionProvider>().signOut();
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) GoRouter.of(context).go(RouteNames.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(AppSpacing.fieldHeight),
                      side: const BorderSide(color: AppColors.brand, width: 2),
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Bottom sheet variant used on seller profile HTML.
Future<void> showLogoutBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 48, height: 4, decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: AppSpacing.md),
          const Icon(Icons.logout, size: 40),
          const SizedBox(height: 8),
          Text('Are you sure you want to log out?', style: Theme.of(ctx).textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text(
            'You will need to verify your phone number next time you sign in to view farmer leads.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () async {
              await ctx.read<AuthSessionProvider>().signOut();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) GoRouter.of(context).go(RouteNames.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(AppSpacing.fieldHeight),
            ),
            child: const Text('Confirm Log Out'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Stay Signed In')),
        ],
      ),
    ),
  );
}
