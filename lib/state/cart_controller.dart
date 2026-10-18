import 'package:flutter/foundation.dart';

import 'package:mini_katalog/models/cart_item.dart';
import 'package:mini_katalog/models/product.dart';

/// Sepet durumunu yöneten sınıf (basit state yönetimi simülasyonu).
///
/// [ChangeNotifier] sayesinde sepet her değiştiğinde [notifyListeners]
/// çağrılır; sepeti dinleyen tüm widget'lar (ör. sepet rozeti) yeniden çizilir.
class CartController extends ChangeNotifier {
  /// Bu tutarın üzerindeki siparişlerde kargo ücretsizdir.
  static const double freeShippingThreshold = 1000;

  /// Ücretsiz kargo sınırının altındaki siparişler için kargo ücreti.
  static const double standardShippingFee = 49.90;

  final List<CartItem> _items = [];

  /// Sepetteki satırlar (dışarıdan değiştirilemez bir kopya).
  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  /// Sepetteki toplam ürün adedi (rozette gösterilir).
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Kargo hariç ara toplam.
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee {
    if (_items.isEmpty || subtotal >= freeShippingThreshold) {
      return 0;
    }
    return standardShippingFee;
  }

  double get total => subtotal + shippingFee;

  /// Bir üründen sepette kaç adet olduğunu döndürür.
  int quantityOf(Product product) {
    final index = _indexOf(product);
    return index == -1 ? 0 : _items[index].quantity;
  }

  /// Ürünü sepete ekler. Ürün zaten varsa adedini artırır.
  void add(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      return;
    }
    final index = _indexOf(product);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: quantity));
    } else {
      final current = _items[index];
      _items[index] = current.copyWith(quantity: current.quantity + quantity);
    }
    notifyListeners();
  }

  /// Ürünün adedini bir azaltır; adet sıfırlanırsa ürünü sepetten çıkarır.
  void decrease(Product product) {
    final index = _indexOf(product);
    if (index == -1) {
      return;
    }
    final current = _items[index];
    if (current.quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = current.copyWith(quantity: current.quantity - 1);
    }
    notifyListeners();
  }

  /// Ürünü (tüm adetleriyle) sepetten çıkarır.
  void remove(Product product) {
    final index = _indexOf(product);
    if (index == -1) {
      return;
    }
    _items.removeAt(index);
    notifyListeners();
  }

  /// Sepeti tamamen boşaltır.
  void clear() {
    if (_items.isEmpty) {
      return;
    }
    _items.clear();
    notifyListeners();
  }

  int _indexOf(Product product) {
    return _items.indexWhere((item) => item.product.id == product.id);
  }
}
