import 'package:mini_katalog/models/product_spec.dart';

/// Katalogdaki bir ürünü temsil eden model sınıfı.
///
/// Veriler `assets/data/products.json` dosyasından okunur ve
/// [Product.fromJson] ile nesneye dönüştürülür.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    this.rating = 0,
    this.reviewCount = 0,
    this.stock = 0,
    this.isFeatured = false,
    this.colors = const [],
    this.specs = const [],
  });

  final int id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String category;

  /// Görselin asset yolu, ör. `assets/images/products/laptop.png`
  final String image;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isFeatured;
  final List<String> colors;
  final List<ProductSpec> specs;

  /// Stokta ürün var mı?
  bool get inStock => stock > 0;

  /// JSON (Map) verisinden [Product] nesnesi oluşturur.
  factory Product.fromJson(Map<String, dynamic> json) {
    final colorList = json['colors'] as List<dynamic>? ?? const [];
    final specList = json['specs'] as List<dynamic>? ?? const [];

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? 'Diğer',
      image: json['image'] as String? ?? '',
      rating: (json['rating'] as num? ?? 0).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      stock: json['stock'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      colors: colorList.map((color) => color as String).toList(),
      specs: specList
          .map((spec) => ProductSpec.fromJson(spec as Map<String, dynamic>))
          .toList(),
    );
  }

  /// [Product] nesnesini JSON (Map) biçimine çevirir.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'stock': stock,
      'isFeatured': isFeatured,
      'colors': colors,
      'specs': specs.map((spec) => spec.toJson()).toList(),
    };
  }

  /// İki ürün, id'leri aynıysa aynı ürün kabul edilir.
  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product($id, $name)';
}
