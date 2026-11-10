import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/agri_primary_app_bar.dart';
import '../../../../core/widgets/app_listing_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../features/favorites/data/favorites_repository.dart';
import '../../../../features/listings/domain/listing.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final _repo = const FavoritesRepository();
  List<Listing> _items = [];
  bool _loading = true;
  String? _error;

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
      final rows = await _repo.fetchFavoriteListings();
      if (!mounted) return;
      setState(() {
        _items = rows;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgriPrimaryAppBar(showBack: true, onBack: () => context.pop(), trailingTitle: 'Saved Machinery'),
      body: _loading
          ? const LoadingView(message: 'Loading favorites…')
          : _error != null
              ? EmptyState(message: _error!)
              : _items.isEmpty
                  ? const EmptyState(message: 'No saved listings yet.')
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.margin),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, i) {
                        final e = _items[i];
                        return AppListingCard(
                          title: e.title,
                          price: e.price,
                          imageUrl: e.primaryImage,
                          subtitle: e.subtitle,
                          featured: e.isFeatured,
                          onTap: () => context.push(RouteNames.listingDetail, extra: e.id),
                        );
                      },
                    ),
    );
  }
}
