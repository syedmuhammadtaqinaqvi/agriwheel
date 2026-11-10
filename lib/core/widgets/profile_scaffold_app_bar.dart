import 'package:flutter/material.dart';

import 'agri_brand_header.dart';

class ProfileScaffoldAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileScaffoldAppBar({super.key, required this.subtitle});

  final String subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AgriBrandHeader(title: subtitle);
  }
}
