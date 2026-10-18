import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/utils/formatters.dart';
import 'package:mini_katalog/utils/product_filter.dart';

import 'test_helpers.dart';

void main() {
  final products = loadTestProducts();

  group('normalizeForSearch', () {
    test('Türkçe karakterleri sadeleştirir ve küçük harfe çevirir', () {
      expect(normalizeForSearch('Kulaklık Max'), 'kulaklik max');
      expect(normalizeForSearch('İÇİN ŞÖYLE ĞÜ'), 'icin soyle gu');
      expect(normalizeForSearch('  Çok   boşluk  '), 'cok bosluk');
    });
  });

  group('filterProducts', () {
    test('boş arama tüm ürünleri döndürür', () {
      expect(filterProducts(products), hasLength(products.length));
    });

    test('Türkçe karakter olmadan arama yapılabilir', () {
      final result = filterProducts(products, query: 'hoparlor');
      expect(result.map((p) => p.name), ['Boom Mini Hoparlör']);
    });

    test('büyük/küçük harf duyarsızdır', () {
      final result = filterProducts(products, query: 'KLAVYE');
      expect(result.single.name, 'Klik Mekanik Klavye');
    });

    test('birden fazla kelimenin hepsi aranır', () {
      final result = filterProducts(products, query: 'lumen 14');
      expect(result.single.name, 'Lumen Book 14');
    });

    test('kategori filtresi uygulanır', () {
      final result = filterProducts(products, category: 'Aksesuar');
      expect(result, hasLength(4));
      expect(result.every((p) => p.category == 'Aksesuar'), isTrue);
    });

    test('kategori ve arama birlikte çalışır', () {
      final result = filterProducts(
        products,
        query: 'mouse',
        category: 'Aksesuar',
      );
      expect(result.single.name, 'Glide Kablosuz Mouse');
    });

    test('fiyata göre artan ve azalan sıralama', () {
      final ascending = filterProducts(
        products,
        sort: SortOption.priceLowToHigh,
      );
      final descending = filterProducts(
        products,
        sort: SortOption.priceHighToLow,
      );

      expect(ascending.first.name, 'Volt 35W Şarj Adaptörü');
      expect(descending.first.name, 'Lumen Studio 24');
      for (var i = 1; i < ascending.length; i++) {
        expect(ascending[i - 1].price, lessThanOrEqualTo(ascending[i].price));
      }
    });

    test('puana göre sıralama', () {
      final result = filterProducts(products, sort: SortOption.topRated);
      expect(result.first.name, 'Lumen Book 14');
    });

    test('filtreleme orijinal listeyi değiştirmez', () {
      final firstBefore = products.first;
      filterProducts(products, sort: SortOption.priceHighToLow);
      expect(products.first, firstBefore);
    });
  });

  test('categoriesOf kategorileri tekrarsız ve sırayla döndürür', () {
    expect(categoriesOf(products), [
      'Ses',
      'Bilgisayar',
      'Telefon & Saat',
      'Fotoğraf',
      'Oyun & Eğlence',
      'Aksesuar',
    ]);
  });

  group('formatPrice', () {
    test('tam sayıları binlik ayraçla yazar', () {
      expect(formatPrice(0), '₺0');
      expect(formatPrice(899), '₺899');
      expect(formatPrice(4299), '₺4.299');
      expect(formatPrice(38999), '₺38.999');
      expect(formatPrice(1234567), '₺1.234.567');
    });

    test('kuruşları virgülle yazar', () {
      expect(formatPrice(649.9), '₺649,90');
      expect(formatPrice(49.9), '₺49,90');
      expect(formatPrice(1250.05), '₺1.250,05');
    });

    test('puanı virgüllü yazar', () {
      expect(formatRating(4.8), '4,8');
      expect(formatRating(5), '5,0');
    });
  });
}
