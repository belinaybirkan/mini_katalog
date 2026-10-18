import 'package:flutter/material.dart';

import 'package:mini_katalog/routes/app_routes.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/product_filter.dart';
import 'package:mini_katalog/widgets/app_search_field.dart';
import 'package:mini_katalog/widgets/cart_icon_button.dart';
import 'package:mini_katalog/widgets/empty_state.dart';
import 'package:mini_katalog/widgets/product_card.dart';

/// Ürün listesi: arama, kategori filtresi, sıralama ve GridView.
///
/// Gerekli veriler [ProductListArgs] ile (Route Arguments) gelir.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, required this.args});

  final ProductListArgs args;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final TextEditingController _searchController;
  late String _query;
  String? _category;
  SortOption _sort = SortOption.recommended;

  @override
  void initState() {
    super.initState();
    _query = widget.args.query;
    _category = widget.args.category;
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openSortSheet() async {
    final selected = await showModalBottomSheet<SortOption>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sırala',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              for (final option in SortOption.values)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(option.label),
                  trailing: option == _sort
                      ? const Icon(Icons.check_rounded, color: AppColors.accent)
                      : null,
                  onTap: () => Navigator.pop(sheetContext, option),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || selected == null) {
      return;
    }
    setState(() => _sort = selected);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = null;
      _sort = SortOption.recommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = widget.args.products;
    final categories = categoriesOf(allProducts);
    final visibleProducts = filterProducts(
      allProducts,
      query: _query,
      category: _category,
      sort: _sort,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title ?? 'Tüm Ürünler'),
        actions: const [CartIconButton(), SizedBox(width: 8)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: AppSearchField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),

          // Kategori filtreleri
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                final String? category = index == 0
                    ? null
                    : categories[index - 1];
                final isSelected = _category == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category ?? 'Tümü'),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _category = category),
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.surface,
                    side: BorderSide(
                      color: isSelected ? AppColors.ink : AppColors.border,
                    ),
                    shape: const StadiumBorder(),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

          // Sonuç sayısı + sıralama
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${visibleProducts.length} ürün bulundu',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openSortSheet,
                  icon: const Icon(Icons.sort_rounded, size: 20),
                  label: Text(_sort.label),
                ),
              ],
            ),
          ),

          // Ürün kartları (GridView.builder)
          Expanded(
            child: visibleProducts.isEmpty
                ? EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Sonuç bulunamadı',
                    message: 'Farklı bir kelime dene veya filtreleri temizle.',
                    actionLabel: 'Filtreleri temizle',
                    onAction: _clearFilters,
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                    itemCount: visibleProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: visibleProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
