import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_listing_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/listings/data/listings_repository.dart';
import '../../../../features/listings/domain/listing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = const ListingsRepository();
  List<Listing> _featured = [];
  List<Listing> _recent = [];
  String? _error;
  bool _loading = true;

  static const _categories = ['All', 'Tractors', 'Harvesters', 'Trolleys', 'Implements'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final featured = await _repo.fetchFeatured();
      final recent = await _repo.fetchRecent();
      if (!mounted) return;
      setState(() {
        _featured = featured;
        _recent = recent;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _openListing(Listing listing) {
    context.push(RouteNames.listingDetail, extra: listing.id);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: AppColors.green,
        onRefresh: _load,
        child: ResponsiveBody(
          child: _loading
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [SizedBox(height: 120), LoadingView(message: 'Loading listings…')],
                )
              : _error != null
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            EmptyState(message: _error!),
                            TextButton(onPressed: _load, child: const Text('Retry')),
                          ],
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: AppSpacing.shellBottomInset),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: AppSpacing.sm),
                        _SearchRow(),
                        const SizedBox(height: AppSpacing.md),
                        _ChipScroller(labels: _categories, selectedIndex: 0),
                        const SizedBox(height: AppSpacing.md),
                        if (_featured.isNotEmpty) ...[
                          _SectionHeader(title: 'Featured Machinery', onViewAll: () => context.go(RouteNames.search)),
                          const SizedBox(height: AppSpacing.sm),
                          SizedBox(
                            height: 260,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _featured.length,
                              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                              itemBuilder: (_, i) {
                                final e = _featured[i];
                                return SizedBox(
                                  width: 280,
                                  child: AppListingCard(
                                    title: e.title,
                                    price: e.price,
                                    imageUrl: e.primaryImage,
                                    subtitle: e.subtitle,
                                    featured: true,
                                    onTap: () => _openListing(e),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        _SectionHeader(title: 'Recent Listings', onViewAll: () => context.go(RouteNames.search)),
                        const SizedBox(height: AppSpacing.sm),
                        if (_recent.isEmpty)
                          const EmptyState(message: 'No active listings yet.')
                        else
                          ..._recent.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: AppListingCard(
                                title: e.title,
                                price: e.price,
                                imageUrl: e.primaryImage,
                                subtitle: e.subtitle,
                                featured: e.isFeatured,
                                onTap: () => _openListing(e),
                              ),
                            ),
                          ),
                        _SellBanner(onPost: () => context.push(RouteNames.postAd)),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
        ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.search),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.brand, width: 2),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.brand),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search tractor model, city…',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.brand.withValues(alpha: 0.6)),
              ),
            ),
            const Icon(Icons.tune, color: AppColors.brand),
          ],
        ),
      ),
    );
  }
}

class _ChipScroller extends StatelessWidget {
  const _ChipScroller({required this.labels, this.selectedIndex});
  final List<String> labels;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = selectedIndex == i;
          return FilterChip(
            label: Text(labels[i], style: const TextStyle(fontSize: 14)),
            selected: selected,
            onSelected: (_) {},
            showCheckmark: false,
            selectedColor: AppColors.secondaryContainer,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.brand),
            labelStyle: TextStyle(
              color: AppColors.brand,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});
  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          margin: const EdgeInsets.only(right: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        TextButton(onPressed: onViewAll, child: const Text('View all')),
      ],
    );
  }
}

class _SellBanner extends StatelessWidget {
  const _SellBanner({required this.onPost});
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondaryContainer,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: InkWell(
        onTap: onPost,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline, color: AppColors.brand),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('Post your tractor or implement', style: Theme.of(context).textTheme.labelLarge),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.brand),
            ],
          ),
        ),
      ),
    );
  }
}
