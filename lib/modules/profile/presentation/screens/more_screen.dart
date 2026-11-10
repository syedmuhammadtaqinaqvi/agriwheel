import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/market_app_bar.dart';
import '../../../../core/widgets/responsive_body.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarketAppBar(key: const ValueKey('tab-more-app-bar')),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.shellBottomInset,
          ),
          children: [
            Text('Quick links', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            _MenuTile(
              icon: Icons.storefront,
              title: 'Sell machinery',
              subtitle: 'Create a seller account and post ads',
              onTap: () => context.push(RouteNames.sellerSignup),
            ),
            _MenuTile(
              icon: Icons.shopping_cart,
              title: 'Buyer registration',
              subtitle: 'Browse tractors with a verified buyer profile',
              onTap: () => context.push(RouteNames.buyerSignup),
            ),
            _MenuTile(
              icon: Icons.support_agent,
              title: 'Punjab Agro Desk',
              subtitle: '0800-AGRI support',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: AppColors.green),
      ),
    );
  }
}
