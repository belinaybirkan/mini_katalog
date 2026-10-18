import 'package:flutter/material.dart';

import 'package:mini_katalog/data/product_repository.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/screens/cart/cart_screen.dart';
import 'package:mini_katalog/screens/home/home_screen.dart';
import 'package:mini_katalog/screens/product_detail/product_detail_screen.dart';
import 'package:mini_katalog/screens/product_list/product_list_screen.dart';
import 'package:mini_katalog/screens/route_error_screen.dart';

/// Uygulamadaki sayfaların isimleri (Named Routes).
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String productList = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
}

/// Ürün listesi sayfasına gönderilen argümanlar (Route Arguments).
class ProductListArgs {
  const ProductListArgs({
    required this.products,
    this.title,
    this.category,
    this.query = '',
  });

  /// Listelenecek ürünler.
  final List<Product> products;

  /// Sayfa başlığı. Boşsa "Tüm Ürünler" yazılır.
  final String? title;

  /// Başlangıçta seçili olacak kategori.
  final String? category;

  /// Başlangıçtaki arama metni.
  final String query;
}

/// Sayfa yönlendirmelerini tek yerden yöneten sınıf.
class AppRouter {
  AppRouter({required this.repository});

  final ProductRepository repository;

  /// Argüman almayan sayfalar: [MaterialApp.routes] haritası.
  late final Map<String, WidgetBuilder> routes = {
    AppRoutes.home: (context) => HomeScreen(repository: repository),
    AppRoutes.cart: (context) => const CartScreen(),
  };

  /// Argüman alan sayfalar: [MaterialApp.onGenerateRoute].
  ///
  /// `Navigator.pushNamed(context, AppRoutes.productDetail, arguments: urun)`
  /// çağrısındaki `arguments` burada [RouteSettings.arguments] ile okunur.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.productList:
        final listArgs = settings.arguments;
        if (listArgs is ProductListArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => ProductListScreen(args: listArgs),
          );
        }
        return _errorRoute(
          settings,
          'Ürün listesi açılırken ProductListArgs gönderilmedi.',
        );
      case AppRoutes.productDetail:
        final product = settings.arguments;
        if (product is Product) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => ProductDetailScreen(product: product),
          );
        }
        return _errorRoute(
          settings,
          'Ürün detayı açılırken Product gönderilmedi.',
        );
    }
    return null;
  }

  /// Tanımsız bir sayfa adı istendiğinde gösterilecek sayfa.
  Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return _errorRoute(settings, '"${settings.name}" adlı sayfa bulunamadı.');
  }

  Route<dynamic> _errorRoute(RouteSettings settings, String message) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => RouteErrorScreen(message: message),
    );
  }
}
