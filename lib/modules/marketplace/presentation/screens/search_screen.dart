import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/market_app_bar.dart';
import '../../../../core/widgets/app_listing_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/listings/data/listings_repository.dart';
import '../../../../features/listings/domain/listing.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = const ListingsRepository();
  final _query = TextEditingController();
  List<Listing> _results = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await _repo.search(ListingsFilter(search: _query.text));
      if (!mounted) return;
      setState(() {
        _results = rows;
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
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MarketAppBar(key: const ValueKey('tab-search-app-bar')),
      body: ResponsiveBody(
        child: Column(
          children: [
            TextField(
              controller: _query,
              decoration: InputDecoration(
                hintText: 'Search by title…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _search),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: _loading
                  ? const LoadingView(message: 'Searching…')
                  : _error != null
                      ? EmptyState(message: _error!)
                      : _results.isEmpty
                          ? const EmptyState(message: 'No listings found.')
                          : ListView.separated(
                              itemCount: _results.length,
                              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                              itemBuilder: (_, i) {
                                final e = _results[i];
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
            ),
          ],
        ),
      ),
    );
  }
}
