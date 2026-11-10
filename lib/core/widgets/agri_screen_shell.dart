import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

/// Profile hub layout: app bar + optional green hero + scroll body.
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AgriAppBar(
        key: ValueKey('shell-$headerTitle'),
        leading: leading,
        title: headerTitle,
        showBrandTitle: showBrandTitle,
        trailing: trailing ?? const _DefaultProfileChip(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
    return const Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.brand,
        child: Icon(Icons.person, color: Colors.white, size: 18),
      ),
    );
  }
}
