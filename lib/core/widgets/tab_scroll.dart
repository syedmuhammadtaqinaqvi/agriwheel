import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// Standard scroll padding for main-tab screens (clears bottom nav + FAB).
class TabScroll extends StatelessWidget {
  const TabScroll({
    super.key,
    required this.child,
    this.padding,
    this.physics,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.sm,
            AppSpacing.margin,
            AppSpacing.shellBottomInset,
          ),
      child: child,
    );
  }
}
