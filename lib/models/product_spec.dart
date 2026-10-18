/// Ürün detay sayfasındaki "Özellikler" kutucuklarında gösterilen bilgi.
///
/// Örnek JSON: `{"label": "Pil", "value": "30 saat"}`
class ProductSpec {
  const ProductSpec({required this.label, required this.value});

  final String label;
  final String value;

  /// JSON (Map) verisinden nesne oluşturur.
  factory ProductSpec.fromJson(Map<String, dynamic> json) {
    return ProductSpec(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  /// Nesneyi tekrar JSON (Map) biçimine çevirir.
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}
