import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/data/product_repository.dart';
import 'package:mini_katalog/models/cart_item.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/models/product_spec.dart';

import 'test_helpers.dart';

void main() {
  group('Product modeli', () {
    final json = <String, dynamic>{
      'id': 1,
      'name': 'Aura Kulaklık Max',
      'tagline': 'Aktif gürültü engelleme',
      'description': 'Uzun açıklama',
      'price': 4299,
      'category': 'Ses',
      'image': 'assets/images/products/headphone.png',
      'rating': 4.8,
      'reviewCount': 214,
      'stock': 18,
      'isFeatured': true,
      'colors': ['Gümüş', 'Siyah'],
      'specs': [
        {'label': 'Pil', 'value': '30 saat'},
      ],
    };

    test('fromJson alanları doğru okur', () {
      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'Aura Kulaklık Max');
      expect(product.price, 4299.0);
      expect(product.price, isA<double>());
      expect(product.rating, 4.8);
      expect(product.isFeatured, isTrue);
      expect(product.inStock, isTrue);
      expect(product.colors, ['Gümüş', 'Siyah']);
      expect(product.specs.single.label, 'Pil');
      expect(product.specs.single.value, '30 saat');
    });

    test('toJson ve fromJson birlikte veriyi korur', () {
      final product = Product.fromJson(json);
      final copy = Product.fromJson(
        jsonDecode(jsonEncode(product.toJson())) as Map<String, dynamic>,
      );

      expect(copy.toJson(), product.toJson());
      expect(copy, product);
    });

    test('isteğe bağlı alanlar eksikse varsayılan değerler kullanılır', () {
      final product = Product.fromJson({
        'id': 5,
        'name': 'Basit Ürün',
        'price': 10.5,
      });

      expect(product.tagline, '');
      expect(product.category, 'Diğer');
      expect(product.rating, 0);
      expect(product.stock, 0);
      expect(product.inStock, isFalse);
      expect(product.colors, isEmpty);
      expect(product.specs, isEmpty);
    });

    test('ProductSpec toJson / fromJson', () {
      const spec = ProductSpec(label: 'Ekran', value: '14 inç');
      final copy = ProductSpec.fromJson(spec.toJson());

      expect(copy.label, 'Ekran');
      expect(copy.value, '14 inç');
    });

    test('CartItem toplam fiyatı ve toJson', () {
      const item = CartItem(product: sampleProduct, quantity: 2);

      expect(item.totalPrice, 2501.0);
      expect(item.toJson(), {
        'productId': 99,
        'quantity': 2,
        'totalPrice': 2501.0,
      });
      expect(item.copyWith(quantity: 5).quantity, 5);
    });
  });

  group('assets/data/products.json', () {
    final jsonString = File('assets/data/products.json').readAsStringSync();
    final products = ProductRepository.parseProducts(jsonString);

    test('16 ürün içerir ve "total" alanıyla uyumludur', () {
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

      expect(products, hasLength(16));
      expect(decoded['total'], products.length);
    });

    test('ürün id değerleri benzersizdir', () {
      final ids = products.map((product) => product.id).toSet();
      expect(ids, hasLength(products.length));
    });

    test('her ürünün görsel dosyası projede bulunur', () {
      for (final product in products) {
        expect(
          File(product.image).existsSync(),
          isTrue,
          reason: '${product.name} görseli bulunamadı: ${product.image}',
        );
      }
    });

    test('fiyatlar pozitif, puanlar 0-5 arasındadır', () {
      for (final product in products) {
        expect(product.price, greaterThan(0), reason: product.name);
        expect(product.rating, inInclusiveRange(0, 5), reason: product.name);
      }
    });

    test('loadTestProducts yardımcı fonksiyonu aynı veriyi döndürür', () {
      expect(loadTestProducts(), hasLength(products.length));
    });
  });
}
