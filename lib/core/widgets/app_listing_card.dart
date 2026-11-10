import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../utils/price_format.dart';
import 'agri_network_image.dart';

/// Strict design-system listing card (Phase 1+); legacy modules use [ListingCard].
class AppListingCard extends StatelessWidget {
  const AppListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.subtitle,
    this.featured = false,
    this.onTap,
  });

  final String title;
  final num price;
  final String imageUrl;
  final String subtitle;
  final bool featured;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: const BorderSide(color: AppColors.green, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: AgriNetworkImage(imageUrl: imageUrl),
                ),
                if (featured)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.green, width: 1),
                      ),
                      child: const Text('Featured', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.green)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(formatPakistanPrice(price), style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
