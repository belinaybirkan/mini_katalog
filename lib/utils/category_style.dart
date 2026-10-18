import 'package:flutter/material.dart';

/// Her kategori için ikon ve renk bilgisi.
class CategoryStyle {
  const CategoryStyle({
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final IconData icon;

  /// Ürün görselinin arkasındaki yumuşak renk.
  final Color background;

  /// İkon rengi.
  final Color foreground;

  static const Map<String, CategoryStyle> _styles = {
    'Ses': CategoryStyle(
      icon: Icons.headphones_rounded,
      background: Color(0xFFEAF1FF),
      foreground: Color(0xFF2563EB),
    ),
    'Bilgisayar': CategoryStyle(
      icon: Icons.laptop_rounded,
      background: Color(0xFFEEF2F7),
      foreground: Color(0xFF334155),
    ),
    'Telefon & Saat': CategoryStyle(
      icon: Icons.smartphone_rounded,
      background: Color(0xFFF1ECFF),
      foreground: Color(0xFF7C3AED),
    ),
    'Fotoğraf': CategoryStyle(
      icon: Icons.photo_camera_rounded,
      background: Color(0xFFFFF3E6),
      foreground: Color(0xFFEA580C),
    ),
    'Oyun & Eğlence': CategoryStyle(
      icon: Icons.sports_esports_rounded,
      background: Color(0xFFFDECF3),
      foreground: Color(0xFFDB2777),
    ),
    'Aksesuar': CategoryStyle(
      icon: Icons.cable_rounded,
      background: Color(0xFFE9FBF1),
      foreground: Color(0xFF16A34A),
    ),
  };

  static const CategoryStyle _fallback = CategoryStyle(
    icon: Icons.category_rounded,
    background: Color(0xFFF1F5F9),
    foreground: Color(0xFF475569),
  );

  /// Kategori adına göre stili döndürür; bilinmeyen kategoride varsayılan stil.
  static CategoryStyle of(String category) => _styles[category] ?? _fallback;
}
