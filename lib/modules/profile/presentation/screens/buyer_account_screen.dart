import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_screen_shell.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/domain/auth_session.dart';
import '../widgets/logout_confirm_dialog.dart';
import '../widgets/profile_menu_tile.dart';

class BuyerAccountScreen extends StatefulWidget {
  const BuyerAccountScreen({super.key});

  @override
  State<BuyerAccountScreen> createState() => _BuyerAccountScreenState();
}

class _BuyerAccountScreenState extends State<BuyerAccountScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final session = AuthSession.instance;
    final initials = session.displayName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return AgriProfileTabBody(
        headerExtension: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 0, AppSpacing.margin, AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.surface,
                      child: Text(initials, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brand)),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(child: Text(session.displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18), overflow: TextOverflow.ellipsis)),
                              const Icon(Icons.verified, color: AppColors.secondaryContainer, size: 20),
                            ],
                          ),
                          Text(session.phone, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                          const Text('Verified Buyer • Punjab', style: TextStyle(color: AppColors.secondaryContainer, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ACCOUNT ROLE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
                          Text('Active Equipment Buyer', style: TextStyle(color: AppColors.secondaryContainer, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => context.push(RouteNames.editProfile),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.brand,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Profile'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.margin, AppSpacing.md, AppSpacing.margin, 0),
            child: AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(icon: Icons.saved_search, value: '14', label: 'Searches'),
                  _Stat(icon: Icons.favorite, value: '5', label: 'Wishlist'),
                  _Stat(icon: Icons.forum, value: '2', label: 'Active Chats'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('My Account', 'Buyer Hub'),
                Card(
                  child: Column(
                    children: [
                      ProfileMenuTile(
                        icon: Icons.favorite_border,
                        title: 'Favorites',
                        subtitle: 'Saved tractors & harvesters',
                        badge: '5 Saved',
                        onTap: () => context.push(RouteNames.savedListings),
                      ),
                      const ProfileMenuDivider(),
                      ProfileMenuTile(
                        icon: Icons.chat_bubble_outline,
                        title: 'My Chats',
                        subtitle: 'Messages with verified sellers',
                        badge: '2 New',
                        onTap: () => context.go(RouteNames.chats),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  color: AppColors.surfaceLow,
                  child: const ListTile(
                    leading: CircleAvatar(backgroundColor: AppColors.secondaryContainer, child: Icon(Icons.verified_user, color: AppColors.brand)),
                    title: Text('Buyer Protection Active'),
                    subtitle: Text('Always inspect PTO drives and hydraulic lifts in person before transferring advance tokens.'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _sectionLabel('Settings', null),
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
                                  Text('Instant price drops & updates', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Switch(
                              value: _notifications,
                              onChanged: (v) => setState(() => _notifications = v),
                              thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.brand : null),
                              trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.secondaryContainer : null),
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
                const SizedBox(height: AppSpacing.lg),
                _sectionLabel('Support', null),
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
                  onPressed: () => showLogoutConfirmDialog(context),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(AppSpacing.fieldHeight), foregroundColor: AppColors.brand),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xl),
                  child: Text('Logged in via Pakistan Mobile (${session.phone})', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ],
        ),
    );
  }

  Widget _sectionLabel(String title, String? trailing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(color: AppColors.brand, fontWeight: FontWeight.w700, fontSize: 12)),
          if (trailing != null) Text(trailing, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.brand),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          ],
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
