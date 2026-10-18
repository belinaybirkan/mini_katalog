import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:mini_katalog/models/product.dart';

/// Ürün verilerini sağlayan sınıf (JSON simülasyonu).
///
/// Eğitim yönergesindeki `products.php` gibi bir API'yi taklit etmek için
/// veriler `assets/data/products.json` dosyasından okunur. İleride gerçek bir
/// servise geçmek istenirse yalnızca [loadProducts] metodunu değiştirmek yeterlidir.
class ProductRepository {
  ProductRepository({AssetBundle? bundle, this.assetPath = defaultAssetPath})
      : _bundle = bundle ?? rootBundle;

  static const String defaultAssetPath = 'assets/data/products.json';

  final AssetBundle _bundle;
  final String assetPath;

  List<Product>? _cache;

  /// Ürünleri yükler. İlk çağrıdan sonra sonuç bellekte tutulur.
  Future<List<Product>> loadProducts() async {
    final cached = _cache;
    if (cached != null) {
      return cached;
    }

    // Gerçek bir ağ isteğini taklit etmek için kısa bir bekleme.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final jsonString = await _bundle.loadString(assetPath);
    final products = parseProducts(jsonString);
    _cache = products;
    return products;
  }

  /// JSON metnini [Product] listesine dönüştürür.
  ///
  /// Beklenen biçim: `{"total": 16, "products": [ {...}, {...} ]}`
  static List<Product> parseProducts(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final items = decoded['products'] as List<dynamic>;
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
