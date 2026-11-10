import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { primary, accent, secondary, smallPrimary, smallSecondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final small = variant == AppButtonVariant.smallPrimary || variant == AppButtonVariant.smallSecondary;
    final height = small ? AppSpacing.buttonHeightSmall : AppSpacing.fieldHeight;
    final width = small ? null : double.infinity;

    Color bg;
    Color fg;
    BorderSide? side;

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.smallPrimary:
        bg = AppColors.green;
        fg = AppColors.white;
        side = null;
      case AppButtonVariant.accent:
        bg = AppColors.yellow;
        fg = AppColors.green;
        side = null;
      case AppButtonVariant.secondary:
      case AppButtonVariant.smallSecondary:
        bg = AppColors.white;
        fg = AppColors.green;
        side = const BorderSide(color: AppColors.green, width: 2);
    }

    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : Row(
            mainAxisSize: small ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 20, color: fg), const SizedBox(width: 8)],
              Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: fg, fontSize: small ? 14 : 16)),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: AppColors.white,
          disabledForegroundColor: AppColors.green,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            side: side ?? BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: small ? 16 : 20),
        ).copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: AppColors.green, width: 2);
            }
            return side ?? BorderSide.none;
          }),
        ),
        child: child,
      ),
    );
  }
}
