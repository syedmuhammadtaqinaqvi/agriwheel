import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_network_image.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/favorites/data/favorites_repository.dart';
import '../../../../features/listings/data/listings_repository.dart';
import '../../../../features/listings/domain/listing.dart';
import '../../domain/listing_model.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key, this.listing, this.listingId});

  final MachineryListing? listing;
  final String? listingId;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final _listingsRepo = const ListingsRepository();
  final _favRepo = const FavoritesRepository();
  Listing? _listing;
  bool _loading = false;
  bool _favorite = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.listingId != null) {
      _loadRemote(widget.listingId!);
    } else if (widget.listing != null) {
      _listing = _fromMock(widget.listing!);
    }
  }

  Future<void> _loadRemote(String id) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final row = await _listingsRepo.fetchById(id);
      final fav = await _favRepo.isFavorite(id);
      if (!mounted) return;
      setState(() {
        _listing = row;
        _favorite = fav;
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

  Listing _fromMock(MachineryListing m) {
    return Listing(
      id: m.id,
      sellerId: 'mock',
      title: m.title,
      category: 'Tractor',
      brand: m.make,
      year: int.tryParse(m.year),
      price: 0,
      city: m.location,
      description: m.sellerNote,
      imageUrls: m.imageUrl.isNotEmpty ? [m.imageUrl] : const [],
      status: 'active',
      isFeatured: m.featured,
      createdAt: DateTime.now(),
      sellerName: m.sellerName,
      sellerPhone: '+923001234567',
    );
  }

  Future<void> _toggleFavorite() async {
    final id = _listing?.id;
    if (id == null) return;
    try {
      await _favRepo.toggle(id);
      if (!mounted) return;
      setState(() => _favorite = !_favorite);
    } catch (_) {}
  }

  Future<void> _callSeller() async {
    final phone = _listing?.sellerPhone?.replaceAll(RegExp(r'\s'), '');
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgriPrimaryAppBar(showBack: true, onBack: () => context.pop(), trailingTitle: 'Machine Details'),
      body: _loading
          ? const LoadingView(message: 'Loading listing…')
          : _error != null
              ? EmptyState(message: _error!)
              : _listing == null
                  ? const EmptyState(message: 'Listing not found.')
                  : ResponsiveBody(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 120),
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                            child: AspectRatio(
                              aspectRatio: 16 / 10,
                              child: AgriNetworkImage(imageUrl: _listing!.primaryImage),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(child: Text(_listing!.priceLabel, style: Theme.of(context).textTheme.titleLarge)),
                              IconButton(
                                onPressed: _toggleFavorite,
                                icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border, color: AppColors.green),
                              ),
                            ],
                          ),
                          Text(_listing!.title, style: Theme.of(context).textTheme.titleMedium),
                          Text(_listing!.subtitle, style: Theme.of(context).textTheme.bodySmall),
                          if (_listing!.isFeatured)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Chip(label: Text('Featured'), backgroundColor: AppColors.yellow),
                            ),
                          const SizedBox(height: AppSpacing.md),
                          _specRow('Category', _listing!.category),
                          if (_listing!.brand != null) _specRow('Brand', _listing!.brand!),
                          if (_listing!.year != null) _specRow('Year', '${_listing!.year}'),
                          if (_listing!.condition != null) _specRow('Condition', _listing!.condition!),
                          if (_listing!.hoursUsed != null) _specRow('Hours', '${_listing!.hoursUsed}'),
                          const SizedBox(height: AppSpacing.md),
                          Text(_listing!.description ?? 'No description.', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.md),
                          _SellerCard(
                            name: _listing!.sellerName ?? 'Seller',
                            verified: _listing!.sellerVerified,
                            city: _listing!.sellerCity ?? _listing!.city,
                          ),
                        ],
                      ),
                    ),
      bottomNavigationBar: _listing == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.margin),
                child: Row(
                  children: [
                    Expanded(child: AppButton(label: 'Chat', variant: AppButtonVariant.secondary, onPressed: () {})),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: AppButton(label: 'Call Seller', onPressed: _callSeller)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({required this.name, required this.verified, this.city});
  final String name;
  final bool verified;
  final String? city;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.green, width: 2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: AppColors.green, child: Icon(Icons.person, color: AppColors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
                    if (verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: AppColors.yellow, size: 20),
                    ],
                  ],
                ),
                if (city != null) Text(city!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
