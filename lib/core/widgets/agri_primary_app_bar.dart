import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

/// Green header for stack / detail screens.
class AgriPrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  AgriPrimaryAppBar({
    super.key,
    this.title = 'AgriWheel',
    this.showBack = false,
    this.onBack,
    this.trailingTitle,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final String? trailingTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kAgriToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenTitle = trailingTitle;
    final compact = MediaQuery.sizeOf(context).width < 360;

    return AgriAppBar(
      key: key,
      leading: showBack
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
            )
          : null,
      title: screenTitle,
      showBrandTitle: screenTitle == null,
      trailing: showBack
          ? const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.brand,
              backgroundImage: AssetImage(AppAssets.appIcon),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: AppColors.secondaryContainer, size: 18),
                if (!compact) ...[
                  const SizedBox(width: 2),
                  const Text('Punjab', style: TextStyle(color: AppColors.onPrimary, fontSize: 12)),
                ],
                const Icon(Icons.expand_more, color: AppColors.onPrimary, size: 16),
              ],
            ),
    );
  }
}
