import 'package:flutter/material.dart';

import 'package:mini_katalog/theme/app_colors.dart';

/// Ürün görselini `Image.asset` ile gösterir.
///
/// Dosya bulunamazsa uygulama çökmesin diye yerine bir ikon gösterilir.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.path,
    this.width,
    this.height,
  });

  /// Asset yolu, ör. `assets/images/products/laptop.png`
  final String path;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.muted,
              size: 36,
            ),
          ),
        );
      },
    );
  }
}
