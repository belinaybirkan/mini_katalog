import 'package:mini_katalog/models/product.dart';

/// Sepetteki bir satır: hangi üründen kaç adet olduğu.
class CartItem {
  const CartItem({required this.product, this.quantity = 1});

  final Product product;
  final int quantity;

  /// Bu satırın toplam tutarı (birim fiyat x adet).
  double get totalPrice => product.price * quantity;

  /// Adedi değiştirilmiş yeni bir kopya döndürür.
  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }

  /// Sepet satırını JSON biçimine çevirir (ör. siparişi bir API'ye göndermek için).
  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
