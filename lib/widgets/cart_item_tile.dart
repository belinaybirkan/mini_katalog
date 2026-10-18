import 'package:flutter/material.dart';

import 'package:mini_katalog/models/cart_item.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/state/cart_scope.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/category_style.dart';
import 'package:mini_katalog/utils/formatters.dart';
import 'package:mini_katalog/widgets/product_image.dart';
import 'package:mini_katalog/widgets/quantity_selector.dart';

/// Sepet sayfasındaki tek bir ürün satırı.
class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.read(context);
    final product = item.product;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.productDetail,
                arguments: product,
              ),
              child: Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CategoryStyle.of(product.category).background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ProductImage(path: product.image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                    '${formatPrice(product.price)} / adet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatPrice(item.totalPrice),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Sepetten çıkar',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => cart.remove(product),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.muted,
                  ),
                ),
                QuantitySelector(
                  compact: true,
                  quantity: item.quantity,
                  onDecrease: () => cart.decrease(product),
                  onIncrease: () => cart.add(product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
