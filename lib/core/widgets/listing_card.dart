import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/marketplace/domain/listing_model.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../../app/router/route_names.dart';
import 'agri_network_image.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    this.compact = false,
  });

  final MachineryListing listing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: const BorderSide(color: AppColors.brand, width: 1.5),
      ),
      child: InkWell(
        onTap: () => context.push(RouteNames.listingDetail, extra: listing),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: AgriNetworkImage(imageUrl: listing.imageUrl),
                  ),
                  if (listing.featured)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.brand),
                        ),
                        child: Text(
                          'FEATURED',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _FavoriteButton(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (compact) ...[
                      Row(
                        children: [
                          Container(width: 4, height: 20, color: AppColors.accent),
                          const SizedBox(width: 8),
                          Text(
                            listing.priceLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(listing.title, style: Theme.of(context).textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listing.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(listing.subtitle, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Text(listing.priceLabel, style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      listing.metaLine,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (listing.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: listing.tags
                            .map((t) => _TagChip(label: t))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push(RouteNames.listingDetail, extra: listing),
                        icon: Icon(listing.primaryActionIcon, size: 18),
                        label: Text(listing.primaryActionLabel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: listing.outlineAction ? AppColors.surface : AppColors.brand,
                          foregroundColor: listing.outlineAction ? AppColors.brand : AppColors.onPrimary,
                          side: listing.outlineAction ? const BorderSide(color: AppColors.brand, width: 2) : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brand),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: saved ? AppColors.secondaryContainer : AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.brand)),
      child: InkWell(
        onTap: () => setState(() => saved = !saved),
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(saved ? Icons.favorite : Icons.favorite_border, size: 20, color: AppColors.brand),
        ),
      ),
    );
  }
}
