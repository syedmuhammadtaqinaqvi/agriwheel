import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

/// Home tab header with location + profile avatar.
class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  MarketAppBar({
    super.key,
    String? title,
    bool showBack = false,
    VoidCallback? onBack,
  })  : _title = title,
        _showBack = showBack,
        _onBack = onBack;

  final String? _title;
  final bool _showBack;
  final VoidCallback? _onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kAgriToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriAppBar(
      key: key,
      leading: _showBack
          ? IconButton(
              onPressed: _onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
            )
          : null,
      title: _title,
      showBrandTitle: _title == null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_showBack) const _LocationChip(),
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
