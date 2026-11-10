import 'package:flutter/material.dart';

import 'agri_brand_header.dart';

class ProfileScaffoldAppBar extends StatelessWidget implements PreferredSizeWidget {
  ProfileScaffoldAppBar({super.key, required this.subtitle});

  final String subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(kAgriToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriAppBar(
      key: key,
      title: subtitle,
      showBrandTitle: true,
    );
  }
}
