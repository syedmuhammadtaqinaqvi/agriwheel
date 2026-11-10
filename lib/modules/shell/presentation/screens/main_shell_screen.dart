import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_brand_header.dart';
import '../../../../core/widgets/agri_screen_shell.dart';
import '../../../../core/widgets/market_app_bar.dart';
import '../../../auth/domain/auth_session.dart';

/// One [Scaffold] for all bottom tabs — tab routes render body only (no nested scaffolds).
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  PreferredSizeWidget? _appBarFor(int index) {
    if (index == 3) {
      final role = AuthSession.instance.role;
      if (role == UserRole.guest) {
        return MarketAppBar(key: const ValueKey('shell-app-bar-profile-guest'));
      }
      final title = role == UserRole.seller ? 'Seller Profile' : 'Buyer Profile';
      return AgriAppBar(
        key: ValueKey('shell-app-bar-profile-${role.name}'),
        title: title,
        trailing: const AgriProfileAppBarChip(),
      );
    }
    return switch (index) {
      0 => MarketAppBar(key: const ValueKey('shell-app-bar-home')),
      1 => MarketAppBar(key: const ValueKey('shell-app-bar-search')),
      2 => MarketAppBar(key: const ValueKey('shell-app-bar-chats')),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;

    return ListenableBuilder(
      listenable: AuthSession.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: _appBarFor(index),
          body: navigationShell,
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(RouteNames.postAd),
            backgroundColor: AppColors.secondaryContainer,
            foregroundColor: AppColors.brand,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              side: const BorderSide(color: AppColors.green, width: 2),
            ),
            child: const Icon(Icons.add, size: 28),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: SafeArea(
            top: false,
            child: BottomAppBar(
              color: AppColors.surface,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              notchMargin: 8,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: index == 0,
                    onTap: () => _goBranch(0),
                  ),
                  _NavItem(
                    icon: Icons.search_rounded,
                    label: 'Search',
                    selected: index == 1,
                    onTap: () => _goBranch(1),
                  ),
                  const SizedBox(width: 56),
                  _NavItem(
                    icon: Icons.chat_rounded,
                    label: 'Chats',
                    selected: index == 2,
                    onTap: () => _goBranch(2),
                  ),
                  _NavItem(
                    icon: Icons.account_circle_rounded,
                    label: 'Profile',
                    selected: index == 3,
                    onTap: () => _goBranch(3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.brand, size: 24),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.brand,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
