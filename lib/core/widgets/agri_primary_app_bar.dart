import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

/// Green header on Home / guest Profile hub.
class AgriPrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AgriPrimaryAppBar({
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final location = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on, color: AppColors.secondaryContainer, size: 18),
        if (!compact) ...[
          const SizedBox(width: 2),
          const Text('Punjab', style: TextStyle(color: AppColors.onPrimary, fontSize: 12)),
        ],
        const Icon(Icons.expand_more, color: AppColors.onPrimary, size: 16),
      ],
    );

    return AgriBrandHeader(
      leading: showBack
          ? IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
            )
          : null,
      title: trailingTitle ?? title,
      showBrandTitle: trailingTitle == null,
      trailing: showBack
          ? const CircleAvatar(radius: 16, backgroundColor: AppColors.brand, child: Icon(Icons.person, size: 18, color: AppColors.onPrimary))
          : location,
    );
  }
}
