import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

class AuthStackAppBar extends StatelessWidget implements PreferredSizeWidget {
  AuthStackAppBar({
    super.key,
    required this.screenTitle,
    this.showBack = true,
  });

  final String screenTitle;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kAgriToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriAppBar(
      key: key,
      leading: showBack
          ? IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
            )
          : null,
      title: screenTitle,
      showBrandTitle: false,
    );
  }
}
