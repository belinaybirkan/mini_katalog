import 'dart:io';

import 'package:mini_katalog/data/product_repository.dart';
import 'package:mini_katalog/models/product.dart';

/// Testlerde gerçek JSON dosyasını diskten okur.
List<Product> loadTestProducts() {
  final jsonString = File('assets/data/products.json').readAsStringSync();
  return ProductRepository.parseProducts(jsonString);
}

/// Bekleme yapmadan, verilen ürünleri döndüren sahte veri kaynağı.
class FakeProductRepository extends ProductRepository {
  FakeProductRepository(this.products);

  final List<Product> products;

  @override
  Future<List<Product>> loadProducts() async => products;
}

/// Testlerde kullanılan örnek ürün.
const Product sampleProduct = Product(
  id: 99,
  name: 'Test Kulaklık',
  tagline: 'Deneme ürünü',
  description: 'Açıklama',
  price: 1250.5,
  category: 'Ses',
  image: 'assets/images/products/headphone.png',
  rating: 4.5,
  reviewCount: 10,
  stock: 3,
);
