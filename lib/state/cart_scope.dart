import 'package:flutter/widgets.dart';

import 'package:mini_katalog/state/cart_controller.dart';

/// [CartController]'ı widget ağacının altındaki tüm sayfalara ulaştırır.
///
/// [InheritedNotifier] kullanıldığı için sepet değiştiğinde
/// [CartScope.of] ile sepeti okuyan widget'lar otomatik olarak yeniden çizilir.
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Sepeti okur ve sepet değiştiğinde widget'ın yeniden çizilmesini sağlar.
  /// `build` metotları içinde kullanılır.
  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'Widget ağacında CartScope bulunamadı.');
    return scope!.notifier!;
  }

  /// Sepeti yalnızca okur, değişiklikleri dinlemez.
  /// Buton tıklamaları gibi olay (event) metotlarında kullanılır.
  static CartController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'Widget ağacında CartScope bulunamadı.');
    return scope!.notifier!;
  }
}
