import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'agri_emblem.dart';

/// Standard green top bar height (below status bar).
const double kAgriToolbarHeight = 56;

/// Green AgriWheel app bar. Use a unique [key] per simultaneous scaffold (tab shell).
class AgriAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AgriAppBar({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.showBrandTitle = true,
    this.actions,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final bool showBrandTitle;
  final List<Widget>? actions;

  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: AppColors.green,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kAgriToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final actionWidgets = <Widget>[
      if (trailing != null)
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: trailing,
        ),
      ...?actions,
    ];

    return AppBar(
      key: key,
      toolbarHeight: kAgriToolbarHeight,
      backgroundColor: AppColors.primaryContainer,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: overlayStyle,
      automaticallyImplyLeading: false,
      leading: leading,
      titleSpacing: 8,
      centerTitle: false,
      title: _BrandTitleRow(
        title: title,
        subtitle: subtitle,
        showBrandTitle: showBrandTitle,
      ),
      actions: actionWidgets.isEmpty ? null : actionWidgets,
    );
  }
}

class _BrandTitleRow extends StatelessWidget {
  const _BrandTitleRow({
    required this.title,
    required this.subtitle,
    required this.showBrandTitle,
  });

  final String? title;
  final String? subtitle;
  final bool showBrandTitle;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 360;
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: compact ? 15 : 17,
        );
    final brandStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );

    return Row(
      children: [
        const AgriEmblem(size: 30),
        if (showBrandTitle) ...[
          SizedBox(width: compact ? 4 : 8),
          if (!compact) Text('AgriWheel', style: brandStyle),
        ],
        if (title != null && title!.isNotEmpty) ...[
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
              style: titleStyle,
            ),
          ),
        ] else if (!showBrandTitle)
          const Spacer(),
        if (subtitle != null && !compact)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent),
            ),
          ),
      ],
    );
  }
}
