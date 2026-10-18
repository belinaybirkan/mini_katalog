import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart_controller.dart';

import 'test_helpers.dart';

void main() {
  late CartController cart;
  late int notifyCount;

  const cheapProduct = Product(
    id: 100,
    name: 'Ucuz Ürün',
    tagline: '',
    description: '',
    price: 200,
    category: 'Aksesuar',
    image: 'assets/images/products/mouse.png',
    stock: 5,
  );

  setUp(() {
    cart = CartController();
    notifyCount = 0;
    cart.addListener(() => notifyCount++);
  });

  tearDown(() => cart.dispose());

  test('başlangıçta sepet boştur', () {
    expect(cart.isEmpty, isTrue);
    expect(cart.totalQuantity, 0);
    expect(cart.total, 0);
  });

  test('aynı ürün iki kez eklenince adet artar', () {
    cart.add(sampleProduct);
    cart.add(sampleProduct);

    expect(cart.items, hasLength(1));
    expect(cart.quantityOf(sampleProduct), 2);
    expect(cart.totalQuantity, 2);
    expect(notifyCount, 2);
  });

  test('belirli adette ekleme yapılabilir', () {
    cart.add(sampleProduct, quantity: 3);
    expect(cart.quantityOf(sampleProduct), 3);
  });

  test('decrease adedi azaltır, sıfırda ürünü çıkarır', () {
    cart.add(sampleProduct, quantity: 2);
    cart.decrease(sampleProduct);
    expect(cart.quantityOf(sampleProduct), 1);

    cart.decrease(sampleProduct);
    expect(cart.quantityOf(sampleProduct), 0);
    expect(cart.isEmpty, isTrue);
  });

  test('remove ürünü tamamen çıkarır', () {
    cart.add(sampleProduct, quantity: 2);
    cart.add(cheapProduct);
    cart.remove(sampleProduct);

    expect(cart.items.single.product, cheapProduct);
  });

  test('1000 TL altında kargo ücreti eklenir', () {
    cart.add(cheapProduct, quantity: 2); // 400 TL

    expect(cart.subtotal, 400);
    expect(cart.shippingFee, CartController.standardShippingFee);
    expect(cart.total, closeTo(449.90, 0.001));
  });

  test('1000 TL ve üzerinde kargo ücretsizdir', () {
    cart.add(cheapProduct, quantity: 5); // 1000 TL

    expect(cart.shippingFee, 0);
    expect(cart.total, 1000);
  });

  test('clear sepeti boşaltır', () {
    cart.add(sampleProduct);
    cart.add(cheapProduct);
    cart.clear();

    expect(cart.isEmpty, isTrue);
    expect(cart.total, 0);
  });

  test('items listesi dışarıdan değiştirilemez', () {
    cart.add(sampleProduct);
    expect(() => cart.items.clear(), throwsUnsupportedError);
  });
}
