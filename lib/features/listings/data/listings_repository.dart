import '../../../core/supabase/supabase_client.dart';
import '../domain/listing.dart';

class ListingsFilter {
  const ListingsFilter({
    this.search,
    this.category,
    this.city,
    this.brand,
    this.minPrice,
    this.maxPrice,
    this.year,
    this.condition,
  });

  final String? search;
  final String? category;
  final String? city;
  final String? brand;
  final num? minPrice;
  final num? maxPrice;
  final int? year;
  final String? condition;
}

class ListingsRepository {
  const ListingsRepository();

  Future<void> pingListings() async {
    await supabase.from('listings').select('id').limit(1);
  }

  Future<List<Listing>> fetchFeatured({int limit = 10}) async {
    final data = await supabase
        .from('listings')
        .select()
        .eq('status', 'active')
        .eq('is_featured', true)
        .order('created_at', ascending: false)
        .limit(limit);
    return _mapList(data);
  }

  Future<List<Listing>> fetchRecent({int limit = 20, int offset = 0}) async {
    final data = await supabase
        .from('listings')
        .select()
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    return _mapList(data);
  }

  Future<Listing?> fetchById(String id) async {
    final row = await supabase.from('listings').select().eq('id', id).maybeSingle();
    if (row == null) return null;
    final seller = await supabase
        .from('profiles')
        .select('full_name, phone, city, is_verified')
        .eq('id', row['seller_id'])
        .maybeSingle();
    return Listing.fromMap(Map<String, dynamic>.from(row), seller: seller != null ? Map<String, dynamic>.from(seller) : null);
  }

  Future<List<Listing>> search(ListingsFilter filter, {int limit = 20, int offset = 0}) async {
    var query = supabase.from('listings').select().eq('status', 'active');
    if (filter.category != null && filter.category!.isNotEmpty && filter.category != 'All') {
      query = query.ilike('category', '%${filter.category}%');
    }
    if (filter.city != null && filter.city!.isNotEmpty) {
      query = query.ilike('city', '%${filter.city}%');
    }
    if (filter.brand != null && filter.brand!.isNotEmpty) {
      query = query.ilike('brand', '%${filter.brand}%');
    }
    if (filter.condition != null && filter.condition!.isNotEmpty) {
      query = query.eq('condition', filter.condition!);
    }
    if (filter.year != null) query = query.eq('year', filter.year!);
    if (filter.minPrice != null) query = query.gte('price', filter.minPrice!);
    if (filter.maxPrice != null) query = query.lte('price', filter.maxPrice!);
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      query = query.ilike('title', '%${filter.search!.trim()}%');
    }
    final data = await query.order('created_at', ascending: false).range(offset, offset + limit - 1);
    return _mapList(data);
  }

  List<Listing> _mapList(List<dynamic> data) {
    return data.map((e) => Listing.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }
}
