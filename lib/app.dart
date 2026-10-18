import 'package:flutter/material.dart';

import 'package:mini_katalog/data/product_repository.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/state/cart_controller.dart';
import 'package:mini_katalog/state/cart_scope.dart';
import 'package:mini_katalog/theme/app_theme.dart';

/// Uygulamanın kök widget'ı.
///
/// Sepet durumu ([CartController]) burada oluşturulur ve [CartScope] ile
/// tüm sayfalara dağıtılır.
class MiniKatalogApp extends StatefulWidget {
  const MiniKatalogApp({super.key, this.repository});

  /// Ürün verisinin kaynağı. Testlerde sahte bir kaynak verilebilir.
  final ProductRepository? repository;

  @override
  State<MiniKatalogApp> createState() => _MiniKatalogAppState();
}

class _MiniKatalogAppState extends State<MiniKatalogApp> {
  final CartController _cart = CartController();
  late final AppRouter _router = AppRouter(
    repository: widget.repository ?? ProductRepository(),
  );

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: _cart,
      child: MaterialApp(
        title: 'Mini Katalog',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: AppRoutes.home,
        routes: _router.routes,
        onGenerateRoute: _router.onGenerateRoute,
        onUnknownRoute: _router.onUnknownRoute,
      ),
    );
  }
}
