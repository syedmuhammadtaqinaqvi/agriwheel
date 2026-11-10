import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'agri_brand_header.dart';

/// Scrollable profile tab body only — app bar lives on [MainShellScreen].
class AgriProfileTabBody extends StatelessWidget {
  const AgriProfileTabBody({
    super.key,
    required this.headerExtension,
    required this.body,
    this.bottomPadding = AppSpacing.shellBottomInset,
  });

  final Widget headerExtension;
  final Widget body;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: bottomPadding),
      children: [
        ColoredBox(
          color: AppColors.primaryContainer,
          child: SizedBox(
            width: double.infinity,
            child: headerExtension,
          ),
        ),
        SizedBox(width: double.infinity, child: body),
      ],
    );
  }
}

/// Full-screen profile hub (pushed routes outside the tab shell).
class AgriScreenShell extends StatelessWidget {
  const AgriScreenShell({
    super.key,
    required this.headerTitle,
    this.showBrandTitle = true,
    this.leading,
    this.trailing,
    required this.body,
    this.headerExtension,
    this.bottomPadding = AppSpacing.shellBottomInset,
  });

  final String headerTitle;
  final bool showBrandTitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget body;
  final Widget? headerExtension;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AgriAppBar(
        key: ValueKey('shell-$headerTitle'),
        leading: leading,
        title: headerTitle,
        showBrandTitle: showBrandTitle,
        trailing: trailing ?? const AgriProfileAppBarChip(),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: bottomPadding),
        children: [
          if (headerExtension != null)
            ColoredBox(
              color: AppColors.primaryContainer,
              child: headerExtension,
            ),
          body,
        ],
      ),
    );
  }
}

/// Trailing avatar on logged-in profile app bar.
class AgriProfileAppBarChip extends StatelessWidget {
  const AgriProfileAppBarChip({super.key});

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
