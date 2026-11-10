import '../../../core/utils/price_format.dart';

class Listing {
  const Listing({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.category,
    this.brand,
    this.year,
    required this.price,
    this.city,
    this.condition,
    this.hoursUsed,
    this.description,
    required this.imageUrls,
    required this.status,
    required this.isFeatured,
    required this.createdAt,
    this.sellerName,
    this.sellerVerified = false,
    this.sellerPhone,
    this.sellerCity,
  });

  final String id;
  final String sellerId;
  final String title;
  final String category;
  final String? brand;
  final int? year;
  final num price;
  final String? city;
  final String? condition;
  final int? hoursUsed;
  final String? description;
  final List<String> imageUrls;
  final String status;
  final bool isFeatured;
  final DateTime createdAt;
  final String? sellerName;
  final bool sellerVerified;
  final String? sellerPhone;
  final String? sellerCity;

  String get priceLabel => formatPakistanPrice(price);

  String get subtitle {
    final parts = <String>[
      if (year != null) '$year',
      if (hoursUsed != null) '$hoursUsed hrs',
      if (city != null) city!,
    ];
    return parts.isEmpty ? category : parts.join(' • ');
  }

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  factory Listing.fromMap(Map<String, dynamic> map, {Map<String, dynamic>? seller}) {
    final images = map['image_urls'];
    return Listing(
      id: map['id'] as String,
      sellerId: map['seller_id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      brand: map['brand'] as String?,
      year: map['year'] as int?,
      price: map['price'] as num,
      city: map['city'] as String?,
      condition: map['condition'] as String?,
      hoursUsed: map['hours_used'] as int?,
      description: map['description'] as String?,
      imageUrls: images is List ? images.map((e) => e.toString()).toList() : const [],
      status: map['status'] as String? ?? 'active',
      isFeatured: map['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      sellerName: seller?['full_name'] as String?,
      sellerVerified: seller?['is_verified'] as bool? ?? false,
      sellerPhone: seller?['phone'] as String?,
      sellerCity: seller?['city'] as String?,
    );
  }
}
