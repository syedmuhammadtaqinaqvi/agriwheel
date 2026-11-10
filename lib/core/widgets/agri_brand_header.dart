import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'agri_emblem.dart';

/// Fixed green top bar — use inside [Scaffold.appBar] OR top of a [Column] (not slivers).
class AgriBrandHeader extends StatelessWidget implements PreferredSizeWidget {
  const AgriBrandHeader({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.showBrandTitle = true,
    this.standalone = false,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final bool showBrandTitle;
  /// `true` when header is the top of [Scaffold.body] (adds status-bar inset). `false` for [Scaffold.appBar].
  final bool standalone;

  static const double barHeight = 56;

  @override
  Size get preferredSize => Size.fromHeight(standalone ? barHeight : barHeight);

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final topPad = standalone ? MediaQuery.paddingOf(context).top : 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: AppColors.primaryContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: topPad),
          child: SizedBox(
            height: barHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                children: [
                  if (leading != null) leading!,
                  const AgriEmblem(size: 30),
                  if (showBrandTitle) ...[
                    SizedBox(width: compact ? 4 : 8),
                    if (!compact)
                      Text(
                        'AgriWheel',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                  ],
                  if (title != null) ...[
                    if (showBrandTitle)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: compact ? 2 : 6),
                        child: Text('|', style: TextStyle(color: AppColors.accent.withValues(alpha: 0.85))),
                      ),
                    Expanded(
                      child: Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: compact ? 15 : 17,
                            ),
                      ),
                    ),
                  ] else
                    const Spacer(),
                  if (subtitle != null && !compact)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent)),
                    ),
                  trailing ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
