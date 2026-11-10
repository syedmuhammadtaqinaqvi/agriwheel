import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';

/// Profile tab: entry to saved listings, seller dashboard, and auth flows.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AgriPrimaryAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.margin),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
            child: const Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: AppColors.brand, child: Icon(Icons.person, color: Colors.white)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Guest Buyer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                      Text('Sign in to sync chats & saved tractors', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Log In',
            onPressed: () => context.push(RouteNames.login),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Tile(
            icon: Icons.bookmark,
            title: 'Saved Machinery',
            subtitle: 'Shortlisted tractors & implements',
            onTap: () => context.push(RouteNames.savedListings),
          ),
          _Tile(
            icon: Icons.inventory_2,
            title: 'My Posted Ads',
            subtitle: 'Active, sold, and boost listings',
            onTap: () => context.push(RouteNames.sellerMyAds),
          ),
          _Tile(
            icon: Icons.storefront,
            title: 'Seller registration',
            subtitle: 'List machinery across Punjab & Sindh',
            onTap: () => context.push(RouteNames.sellerSignup),
          ),
          _Tile(
            icon: Icons.shopping_cart,
            title: 'Buyer registration',
            subtitle: 'Verified buyer profile & OTP login',
            onTap: () => context.push(RouteNames.buyerSignup),
          ),
          _Tile(
            icon: Icons.support_agent,
            title: 'Punjab Agro Desk',
            subtitle: '0800-AGRI',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: const BorderSide(color: AppColors.brand, width: 2),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.brand),
        title: Text(title, style: Theme.of(context).textTheme.labelLarge),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
