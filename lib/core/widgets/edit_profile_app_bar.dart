import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  EditProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kAgriToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriAppBar(
      key: key,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onPrimary),
      ),
      title: 'Edit Profile',
      showBrandTitle: false,
    );
  }
}
