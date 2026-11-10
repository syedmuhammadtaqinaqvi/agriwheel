import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

class AuthStackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthStackAppBar({
    super.key,
    required this.screenTitle,
    this.showBack = true,
  });

  final String screenTitle;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriBrandHeader(
      leading: showBack
          ? IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
            )
          : null,
      title: screenTitle,
    );
  }
}
