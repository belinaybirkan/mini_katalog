import 'package:flutter/material.dart';

import 'package:mini_katalog/models/product.dart';

/// Ürün sepete eklendiğinde altta kısa bir bilgi mesajı gösterir.
void showAddedToCartSnackBar(
  BuildContext context,
  Product product, {
  int quantity = 1,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final message = quantity > 1
      ? '${product.name} ($quantity adet) sepete eklendi'
      : '${product.name} sepete eklendi';

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}
