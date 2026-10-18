import 'package:flutter/material.dart';

import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/state/cart_scope.dart';
import 'package:mini_katalog/theme/app_colors.dart';

/// Üzerinde sepetteki ürün sayısını gösteren sepet butonu.
///
/// [CartScope.of] kullandığı için sepet her değiştiğinde rozet güncellenir.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key, this.filled = false});

  /// true ise beyaz, yuvarlak bir arka planla çizilir (görsel üzerinde kullanım için).
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final count = CartScope.of(context).totalQuantity;

    return IconButton(
      key: const Key('cartButton'),
      tooltip: 'Sepetim',
      onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
      style: filled
          ? IconButton.styleFrom(backgroundColor: Colors.white)
          : null,
      icon: Badge(
        isLabelVisible: count > 0,
        backgroundColor: AppColors.accent,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.ink),
      ),
    );
  }
}
