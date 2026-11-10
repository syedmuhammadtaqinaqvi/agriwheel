import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import 'agri_brand_header.dart';
class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MarketAppBar({
    super.key,
    this.title,
    this.showBack = false,
    this.onBack,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriBrandHeader(
      leading: showBack
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
            )
          : null,
      title: title ?? 'AgriWheel',
      showBrandTitle: title == null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!showBack) const _LocationChip(),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.brand,
            backgroundImage: AssetImage(AppAssets.appIcon),
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: AppColors.secondaryContainer, size: 16),
          SizedBox(width: 2),
          Text('Punjab', style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
