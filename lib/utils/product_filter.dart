import 'package:mini_katalog/models/product.dart';

/// Ürün listesindeki sıralama seçenekleri.
enum SortOption {
  recommended('Önerilen'),
  priceLowToHigh('En düşük fiyat'),
  priceHighToLow('En yüksek fiyat'),
  topRated('En yüksek puan');

  const SortOption(this.label);

  /// Ekranda gösterilecek Türkçe ad.
  final String label;
}

/// Ürünlerdeki kategorileri, JSON'daki sırayı koruyarak tekrarsız döndürür.
List<String> categoriesOf(List<Product> products) {
  return products.map((product) => product.category).toSet().toList();
}

/// Arama metni, kategori ve sıralamaya göre ürünleri filtreler.
///
/// Arama Türkçe karakterlere duyarsızdır: "hoparlor" yazınca "Hoparlör" bulunur.
List<Product> filterProducts(
  List<Product> products, {
  String query = '',
  String? category,
  SortOption sort = SortOption.recommended,
}) {
  final words = normalizeForSearch(query)
      .split(' ')
      .where((word) => word.isNotEmpty)
      .toList();

  final result = products.where((product) {
    if (category != null && product.category != category) {
      return false;
    }
    if (words.isEmpty) {
      return true;
    }
    final searchable = normalizeForSearch(
      '${product.name} ${product.tagline} ${product.category}',
    );
    return words.every(searchable.contains);
  }).toList();

  switch (sort) {
    case SortOption.recommended:
      break;
    case SortOption.priceLowToHigh:
      result.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHighToLow:
      result.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.topRated:
      result.sort((a, b) => b.rating.compareTo(a.rating));
  }

  return result;
}

/// Metni aramaya uygun hâle getirir: küçük harf + Türkçe karakterleri sadeleştirme.
///
/// "Kulaklık Max" -> "kulaklik max", "İPHONE" -> "iphone"
String normalizeForSearch(String input) {
  const replacements = {
    'İ': 'i',
    'I': 'i',
    'ı': 'i',
    'Ç': 'c',
    'ç': 'c',
    'Ğ': 'g',
    'ğ': 'g',
    'Ö': 'o',
    'ö': 'o',
    'Ş': 's',
    'ş': 's',
    'Ü': 'u',
    'ü': 'u',
  };

  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final character = String.fromCharCode(rune);
    buffer.write(replacements[character] ?? character.toLowerCase());
  }
  // Birden fazla boşluğu teke indir.
  return buffer.toString().trim().replaceAll(RegExp(r'\s+'), ' ');
}
