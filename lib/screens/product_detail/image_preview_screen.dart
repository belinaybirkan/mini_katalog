import 'package:flutter/material.dart';

import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/category_style.dart';
import 'package:mini_katalog/widgets/product_image.dart';

/// Ürün görselini tam ekranda, yakınlaştırılabilir şekilde gösterir.
///
/// Bu sayfa named route yerine doğrudan `Navigator.push` ile açılır,
/// kapatma butonu `Navigator.pop` ile önceki sayfaya döner.
class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CategoryStyle.of(product.category).background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(product.name),
        leading: IconButton(
          tooltip: 'Kapat',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: ProductImage(path: product.image, width: 300, height: 300),
                ),
              ),
            ),
          ),
          const SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Yakınlaştırmak için iki parmağını kullan',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
