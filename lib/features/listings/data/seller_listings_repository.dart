import '../../../core/supabase/supabase_client.dart';
import '../domain/listing.dart';

class SellerListingsRepository {
  const SellerListingsRepository();

  Future<List<Listing>> myListings({String? status}) async {
    var q = supabase.from('listings').select().eq('seller_id', supabase.auth.currentUser!.id);
    if (status != null) q = q.eq('status', status);
    final data = await q.order('created_at', ascending: false);
    return data.map((e) => Listing.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> insertListing(Map<String, dynamic> row) async {
    await supabase.from('listings').insert(row);
  }

  Future<void> updateListing(String id, Map<String, dynamic> row) async {
    await supabase.from('listings').update(row).eq('id', id).eq('seller_id', supabase.auth.currentUser!.id);
  }

  Future<void> markSold(String id) async {
    await updateListing(id, {'status': 'sold'});
  }

  Future<void> deleteListing(String id) async {
    await supabase.from('listings').delete().eq('id', id).eq('seller_id', supabase.auth.currentUser!.id);
  }
}
