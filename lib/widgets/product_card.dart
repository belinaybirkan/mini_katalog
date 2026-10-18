import 'package:flutter/material.dart';

import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/state/cart_scope.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/category_style.dart';
import 'package:mini_katalog/utils/formatters.dart';
import 'package:mini_katalog/widgets/added_to_cart_snackbar.dart';
import 'package:mini_katalog/widgets/product_image.dart';
import 'package:mini_katalog/widgets/rating_badge.dart';

/// GridView ve yatay listelerde kullanılan ürün kartı.
///
/// Karta dokununca ürün detayına gidilir; "+" butonu ürünü sepete ekler.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  void _openDetail(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.productDetail, arguments: product);
  }

  void _addToCart(BuildContext context) {
    CartScope.read(context).add(product);
    showAddedToCartSnackBar(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = CategoryStyle.of(product.category);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: style.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: ProductImage(path: product.image),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: RatingBadge(rating: product.rating),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    product.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatPrice(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        tooltip: 'Sepete ekle',
                        onPressed: product.inStock
                            ? () => _addToCart(context)
                            : null,
                        iconSize: 18,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(34, 34),
                          fixedSize: const Size(34, 34),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
