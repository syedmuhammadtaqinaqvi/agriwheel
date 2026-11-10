import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/utils/price_format.dart';
import '../../../../features/listings/data/seller_listings_repository.dart';
import '../../../../features/listings/domain/listing.dart';

class SellerMyAdsScreen extends StatefulWidget {
  const SellerMyAdsScreen({super.key});

  @override
  State<SellerMyAdsScreen> createState() => _SellerMyAdsScreenState();
}

class _SellerMyAdsScreenState extends State<SellerMyAdsScreen> {
  final _repo = const SellerListingsRepository();
  var _showActive = true;
  List<Listing> _listings = [];
  int _activeCount = 0;
  int _soldCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final active = await _repo.myListings(status: 'active');
      final sold = await _repo.myListings(status: 'sold');
      if (!mounted) return;
      setState(() {
        _activeCount = active.length;
        _soldCount = sold.length;
        _listings = _showActive ? active : sold;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _markSold(Listing listing) async {
    await _repo.markSold(listing.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as sold.')));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgriPrimaryAppBar(
        showBack: true,
        onBack: () => context.pop(),
        trailingTitle: 'My Ads',
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.shellBottomInset),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
              child: const Row(
                children: [
                  CircleAvatar(backgroundColor: AppColors.brand, child: Icon(Icons.storefront, color: Colors.white)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Haji Rafiq Chaudhry', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('3 Ads Posted • Sargodha, Punjab', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text('Active ($_activeCount)'),
                    selected: _showActive,
                    onSelected: (_) {
                      setState(() => _showActive = true);
                      _load();
                    },
                    selectedColor: AppColors.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Text('Sold ($_soldCount)'),
                    selected: !_showActive,
                    onSelected: (_) {
                      setState(() => _showActive = false);
                      _load();
                    },
                    selectedColor: AppColors.secondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
              child: Row(
                children: [
                  const Icon(Icons.rocket_launch),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Boost Your Ad to Featured\nSell up to 3x faster', style: TextStyle(fontSize: 13))),
                  ElevatedButton(onPressed: () {}, child: const Text('Upgrade')),
                ],
              ),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: LoadingView(message: 'Loading your ads…'),
            )
          else if (_listings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.margin),
              child: EmptyState(message: _showActive ? 'No active ads. Post your first ad.' : 'No sold ads yet.'),
            )
          else if (_showActive)
            ..._listings.map(
              (listing) => _AdCard(
                title: listing.title,
                price: formatPakistanPrice(listing.price),
                imageUrl: listing.primaryImage,
                onMarkSold: () => _markSold(listing),
              ),
            )
          else
            ..._listings.map(
              (listing) => _SoldCard(
                title: listing.title,
                price: formatPakistanPrice(listing.price),
                imageUrl: listing.primaryImage,
              ),
            ),
        ],
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  const _AdCard({required this.title, required this.price, required this.imageUrl, required this.onMarkSold});
  final String title;
  final String price;
  final String imageUrl;
  final VoidCallback onMarkSold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 0, AppSpacing.margin, AppSpacing.md),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 176,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AgriNetworkImage(imageUrl: imageUrl),
                  const Positioned(top: 8, left: 8, child: Chip(label: Text('LIVE'))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(price, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('142 Views • 18 Inquiries • 5 WhatsApp', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_note), label: const Text('Edit Ad'))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onMarkSold,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Mark as Sold'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: Colors.white),
                        ),
                      ),
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
}

class _SoldCard extends StatelessWidget {
  const _SoldCard({required this.title, required this.price, required this.imageUrl});
  final String title;
  final String price;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.margin),
      child: Card(
        child: Column(
          children: [
            Stack(
              children: [
                AgriNetworkImage(imageUrl: imageUrl, height: 160, width: double.infinity),
                const Center(child: Chip(label: Text('SOLD'), backgroundColor: AppColors.brand)),
              ],
            ),
            ListTile(
              title: Text(title),
              subtitle: const Text('Sold on 14 Mar • Faisalabad'),
              trailing: Text(price, style: const TextStyle(decoration: TextDecoration.lineThrough)),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.margin),
              child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.replay), label: const Text('Relist Tractor')),
            ),
          ],
        ),
      ),
    );
  }
}
