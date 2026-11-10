import '../../../core/supabase/supabase_client.dart';
import '../../listings/domain/listing.dart';

class FavoritesRepository {
  const FavoritesRepository();

  Future<Set<String>> favoriteIds() async {
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return {};
    final rows = await supabase.from('favorites').select('listing_id').eq('user_id', uid);
    return rows.map((e) => e['listing_id'] as String).toSet();
  }

  Future<bool> isFavorite(String listingId) async {
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return false;
    final row = await supabase.from('favorites').select().eq('user_id', uid).eq('listing_id', listingId).maybeSingle();
    return row != null;
  }

  Future<void> toggle(String listingId) async {
    final uid = supabase.auth.currentUser!.id;
    final existing = await supabase.from('favorites').select().eq('user_id', uid).eq('listing_id', listingId).maybeSingle();
    if (existing != null) {
      await supabase.from('favorites').delete().eq('user_id', uid).eq('listing_id', listingId);
    } else {
      await supabase.from('favorites').insert({'listing_id': listingId});
    }
  }

  Future<List<Listing>> fetchFavoriteListings() async {
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await supabase.from('favorites').select('listing_id').eq('user_id', uid);
    if (rows.isEmpty) return [];
    final ids = rows.map((e) => e['listing_id'] as String).toList();
    final data = await supabase.from('listings').select().inFilter('id', ids).eq('status', 'active');
    return data.map((e) => Listing.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }
}
