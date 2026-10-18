import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/app.dart';

import 'test_helpers.dart';

/// Uygulamayı telefon boyutunda (360 x 800) başlatır.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MiniKatalogApp(repository: FakeProductRepository(loadTestProducts())),
  );
  await tester.pumpAndSettle();
}

/// Sepet butonunun üzerindeki rozette verilen sayı yazıyor mu?
Finder cartBadge(String count) {
  return find.descendant(
    of: find.byKey(const Key('cartButton')),
    matching: find.text(count),
  );
}

/// Ekranda açık olan SnackBar'ın kapanmasını bekler.
Future<void> waitForSnackBar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Ana sayfa başlık, banner, kategori ve ürünleri gösterir', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('Kategoriler'), findsOneWidget);
    expect(find.text('Öne Çıkanlar'), findsOneWidget);
    expect(find.text('Aura Kulaklık Max'), findsWidgets);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('Detaydan sepete ekleme, sepet ve sipariş akışı', (tester) async {
    await pumpApp(tester);

    // Ana sayfadaki ürüne dokun -> detay sayfası (named route + argüman)
    await tester.tap(find.text('Aura Kulaklık Max').first);
    await tester.pumpAndSettle();
    expect(find.text('Açıklama'), findsOneWidget);
    expect(find.text('Özellikler'), findsOneWidget);

    // Adedi 2 yap ve sepete ekle
    await tester.tap(find.byTooltip('Artır'));
    await tester.pump();
    expect(
      tester.widget<Text>(find.byKey(const Key('quantityText'))).data,
      '2',
    );

    await tester.tap(find.byKey(const Key('addToCartButton')));
    await tester.pump();
    expect(cartBadge('2'), findsOneWidget);
    expect(find.text('Sepetinde 2 adet var'), findsOneWidget);
    await waitForSnackBar(tester);

    // Sepete git
    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();
    expect(find.text('Sepetim'), findsOneWidget);
    expect(find.text('Aura Kulaklık Max'), findsOneWidget);
    expect(find.text('₺8.598'), findsWidgets); // 2 x ₺4.299
    expect(find.text('Ücretsiz'), findsOneWidget); // 1000 TL üstü kargo

    // Siparişi tamamla -> onay sayfası
    await tester.tap(find.byKey(const Key('checkoutButton')));
    await tester.pumpAndSettle();
    expect(find.text('Siparişin alındı!'), findsOneWidget);

    // Ana sayfaya dön, sepet boşalmış olmalı
    await tester.tap(find.byKey(const Key('continueShoppingButton')));
    await tester.pumpAndSettle();
    expect(find.text('Keşfet'), findsOneWidget);
    expect(cartBadge('2'), findsNothing);
  });

  testWidgets('Karttaki + butonu ürünü sepete ekler', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Sepete ekle').first);
    await tester.pump();
    expect(cartBadge('1'), findsOneWidget);

    await waitForSnackBar(tester);
  });

  testWidgets('Sepette adet artırma, azaltma ve silme', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Sepete ekle').first);
    await tester.pump();
    await waitForSnackBar(tester);

    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Artır'));
    await tester.pump();
    expect(
      tester.widget<Text>(find.byKey(const Key('quantityText'))).data,
      '2',
    );

    await tester.tap(find.byTooltip('Azalt'));
    await tester.pump();
    expect(
      tester.widget<Text>(find.byKey(const Key('quantityText'))).data,
      '1',
    );

    await tester.tap(find.byTooltip('Sepetten çıkar'));
    await tester.pumpAndSettle();
    expect(find.text('Sepetin boş'), findsOneWidget);
  });

  testWidgets('Boş sepet mesajı ve geri dönüş', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();
    expect(find.text('Sepetin boş'), findsOneWidget);

    await tester.tap(find.text('Alışverişe başla'));
    await tester.pumpAndSettle();
    expect(find.text('Keşfet'), findsOneWidget);
  });

  testWidgets('Arama sonucu ve kategori filtresi', (tester) async {
    await pumpApp(tester);

    // Ana sayfada ara -> ürün listesi (query argümanı ile)
    await tester.enterText(find.byType(TextField), 'hoparlor');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Arama sonuçları'), findsOneWidget);
    expect(find.text('Boom Mini Hoparlör'), findsOneWidget);
    expect(find.text('1 ürün bulundu'), findsOneWidget);

    // Aramayı temizle ve "Ses" kategorisini seç
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('16 ürün bulundu'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Ses'));
    await tester.pumpAndSettle();
    expect(find.text('3 ürün bulundu'), findsOneWidget);

    // Sonuç yoksa boş durum gösterilir
    await tester.enterText(find.byType(TextField), 'buzdolabi');
    await tester.pumpAndSettle();
    expect(find.text('Sonuç bulunamadı'), findsOneWidget);
  });
}
