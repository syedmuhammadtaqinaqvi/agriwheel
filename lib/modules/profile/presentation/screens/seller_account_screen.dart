import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/widgets/agri_screen_shell.dart';
import '../../../auth/domain/auth_session.dart';
import '../widgets/logout_confirm_dialog.dart';
import '../widgets/profile_menu_tile.dart';

class SellerAccountScreen extends StatefulWidget {
  const SellerAccountScreen({super.key});

  @override
  State<SellerAccountScreen> createState() => _SellerAccountScreenState();
}

class _SellerAccountScreenState extends State<SellerAccountScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final session = AuthSession.instance;

    return Scaffold(
      body: AgriScreenShell(
        headerTitle: 'Seller Profile',
        headerExtension: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 0, AppSpacing.margin, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        AgriAvatarImage(networkUrl: session.avatarUrl, radius: 34),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.secondaryContainer,
                            child: Icon(Icons.verified, size: 14, color: AppColors.brand),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            children: [
                              Text(session.displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(999)),
                                child: const Text('Verified', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          Text(session.phone, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                          Text('${session.dealerName} • ${session.city.split(',').first}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.brand.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          _PulseDot(),
                          SizedBox(width: 8),
                          Text('Deals Active Today', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => context.push(RouteNames.editProfile),
                      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.brand),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Profile'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _Metric(value: '3', label: 'Live Ads'),
                        _Metric(value: '18', label: 'Machines Sold'),
                        _Metric(value: '4.9', label: 'Seller Rating', showStar: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _sectionHeader('My Account'),
                Card(
                  child: Column(
                    children: [
                      ProfileMenuTile(
                        icon: Icons.agriculture,
                        title: 'My Ads',
                        subtitle: 'Manage tractors & implements',
                        badge: '3 Active',
                        onTap: () => context.push(RouteNames.sellerMyAds),
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuTile(
                        icon: Icons.favorite_border,
                        title: 'Favorites',
                        subtitle: 'Wishlisted machinery',
                        trailing: const Text('14 Saved'),
                        onTap: () => context.push(RouteNames.savedListings),
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuTile(
                        icon: Icons.chat_bubble_outline,
                        title: 'My Chats',
                        subtitle: 'Farmer inquiries & bids',
                        badge: '4 New',
                        onTap: () => context.go(RouteNames.chats),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _sectionHeader('Settings'),
                Card(
                  child: Column(
                    children: [
                      const ProfileMenuTile(icon: Icons.translate, title: 'Language', trailing: Text('English / اردو')),
                      const ProfileMenuDivider(),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                                  Text('Instant alerts on tractor leads', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Switch(
                              value: _notifications,
                              onChanged: (v) => setState(() => _notifications = v),
                              activeTrackColor: AppColors.secondaryContainer,
                            ),
                          ],
                        ),
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        onTap: () => context.push(RouteNames.changePassword),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _sectionHeader('Support'),
                Card(
                  child: const Column(
                    children: [
                      ProfileMenuTile(icon: Icons.help_outline, title: 'Help & Support'),
                      ProfileMenuDivider(),
                      ProfileMenuTile(icon: Icons.description, title: 'Terms & Privacy Policy'),
                      ProfileMenuDivider(),
                      ProfileMenuTile(icon: Icons.scanner, title: 'About AgriWheel', trailing: Text('v2.4.0')),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => showLogoutBottomSheet(context),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(AppSpacing.fieldHeight), foregroundColor: AppColors.brand),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield, size: 14, color: Theme.of(context).disabledColor),
                    const SizedBox(width: 4),
                    Text('Secured AgriWheel Mandi Account', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(title.toUpperCase(), style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label, this.showStar = false});
  final String value;
  final String label;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.brand)),
            if (showStar) const Icon(Icons.star, color: AppColors.secondaryContainer, size: 18),
          ],
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle)),
    );
  }
}
