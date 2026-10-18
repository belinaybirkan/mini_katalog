/// Fiyatı Türk Lirası biçiminde yazar.
///
/// Örnekler: `38999` -> `₺38.999`, `649.9` -> `₺649,90`
String formatPrice(double value) {
  final cents = (value * 100).round();
  final lira = cents ~/ 100;
  final kurus = cents % 100;
  final liraText = _groupThousands(lira.toString());
  if (kurus == 0) {
    return '₺$liraText';
  }
  return '₺$liraText,${kurus.toString().padLeft(2, '0')}';
}

/// Puanı tek ondalık basamakla Türkçe biçimde yazar: `4.8` -> `4,8`
String formatRating(double rating) {
  return rating.toStringAsFixed(1).replaceAll('.', ',');
}

/// "1234567" -> "1.234.567"
String _groupThousands(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
