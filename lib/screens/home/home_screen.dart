import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mini_katalog/data/product_repository.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/product_filter.dart';
import 'package:mini_katalog/widgets/app_search_field.dart';
import 'package:mini_katalog/widgets/cart_icon_button.dart';
import 'package:mini_katalog/widgets/category_card.dart';
import 'package:mini_katalog/widgets/empty_state.dart';
import 'package:mini_katalog/widgets/product_card.dart';
import 'package:mini_katalog/widgets/section_header.dart';

/// Ana sayfa (Keşfet): arama, banner, kategoriler, öne çıkan ve popüler ürünler.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productsFuture = widget.repository.loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _productsFuture = widget.repository.loadProducts();
    });
  }

  /// Ürün listesi sayfasını, Route Arguments ile veri göndererek açar.
  void _openProductList(
    List<Product> products, {
    String? title,
    String? category,
    String query = '',
  }) {
    Navigator.pushNamed(
      context,
      AppRoutes.productList,
      arguments: ProductListArgs(
        products: products,
        title: title,
        category: category,
        query: query,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return EmptyState(
                  icon: Icons.cloud_off_rounded,
                  title: 'Ürünler yüklenemedi',
                  message: '${snapshot.error}',
                  actionLabel: 'Tekrar dene',
                  onAction: _retry,
                );
              }
              final products = snapshot.data ?? const <Product>[];
              return _buildContent(products);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<Product> products) {
    final textTheme = Theme.of(context).textTheme;
    final categories = categoriesOf(products);
    final featured = products.where((product) => product.isFeatured).toList();
    final popular = filterProducts(products, sort: SortOption.topRated)
        .take(4)
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // Başlık + sepet butonu
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keşfet',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Sana uygun cihazı bul.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const CartIconButton(),
            ],
          ),
        ),

        // Arama kutusu: Enter'a basınca ürün listesine gider
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: AppSearchField(
            controller: _searchController,
            hintText: 'Ürün veya kategori ara...',
            onSubmitted: (value) {
              _openProductList(
                products,
                title: 'Arama sonuçları',
                query: value.trim(),
              );
            },
          ),
        ),

        // Banner (Image.asset)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: GestureDetector(
            onTap: () => _openProductList(products, title: 'Tüm Ürünler'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1200 / 450,
                child: Image.asset(
                  'assets/images/banner.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Kategoriler (yatay ListView.builder)
        const SectionHeader(title: 'Kategoriler'),
        SizedBox(
          height: 112,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CategoryCard(
                  category: category,
                  onTap: () => _openProductList(
                    products,
                    title: category,
                    category: category,
                  ),
                ),
              );
            },
          ),
        ),

        // Öne çıkan ürünler (yatay ListView.builder)
        SectionHeader(
          title: 'Öne Çıkanlar',
          actionLabel: 'Tümünü gör',
          onAction: () => _openProductList(products, title: 'Tüm Ürünler'),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: 168,
                  child: ProductCard(product: featured[index]),
                ),
              );
            },
          ),
        ),

        // Popüler ürünler (GridView ile kart tabanlı tasarım)
        SectionHeader(
          title: 'Popüler Ürünler',
          actionLabel: 'Tümünü gör',
          onAction: () => _openProductList(
            products,
            title: 'Tüm Ürünler',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
            itemCount: popular.length,
            itemBuilder: (context, index) {
              return ProductCard(product: popular[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutlinedButton.icon(
            onPressed: () => _openProductList(products, title: 'Tüm Ürünler'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.grid_view_rounded),
            label: Text('Tüm ürünleri gör (${products.length})'),
          ),
        ),
      ],
    );
  }
}
