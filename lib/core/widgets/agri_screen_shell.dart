import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

/// Fixed header + scroll body (profile tabs — no duplicate appBar strip).
class AgriScreenShell extends StatelessWidget {
  const AgriScreenShell({
    super.key,
    required this.headerTitle,
    this.showBrandTitle = true,
    this.leading,
    this.trailing,
    required this.body,
    this.headerExtension,
  });

  final String headerTitle;
  final bool showBrandTitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget body;
  final Widget? headerExtension;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          AgriBrandHeader(
            standalone: true,
            leading: leading,
            title: headerTitle,
            showBrandTitle: showBrandTitle,
            trailing: trailing ?? const _DefaultProfileChip(),
          ),
          if (headerExtension != null)
            ColoredBox(
              color: AppColors.primaryContainer,
              child: headerExtension,
            ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _DefaultProfileChip extends StatelessWidget {
  const _DefaultProfileChip();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.brand,
      child: Icon(Icons.person, color: Colors.white, size: 18),
    );
  }
}
