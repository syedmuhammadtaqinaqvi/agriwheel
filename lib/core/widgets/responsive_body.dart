import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// Centers content and caps width. Default: no top inset (screen already has appBar).
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
    this.safeTop = false,
    this.safeBottom = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool safeTop;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: safeTop,
      bottom: safeBottom,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
