import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/models/product_spec.dart';
import 'package:mini_katalog/screens/product_detail/image_preview_screen.dart';
import 'package:mini_katalog/state/cart_scope.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/category_style.dart';
import 'package:mini_katalog/utils/formatters.dart';
import 'package:mini_katalog/widgets/added_to_cart_snackbar.dart';
import 'package:mini_katalog/widgets/cart_icon_button.dart';
import 'package:mini_katalog/widgets/product_image.dart';
import 'package:mini_katalog/widgets/quantity_selector.dart';

/// Ürün detay sayfası. Gösterilecek ürün, route argümanı olarak gelir.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  int get _maxQuantity => math.max(1, math.min(widget.product.stock, 10));

  void _increase() {
    if (_quantity < _maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decrease() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  void _addToCart() {
    final product = widget.product;
    CartScope.read(context).add(product, quantity: _quantity);
    showAddedToCartSnackBar(context, product, quantity: _quantity);
    setState(() => _quantity = 1);
  }

  /// Navigator.push + MaterialPageRoute örneği: görseli tam ekranda açar.
  void _openImagePreview() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ImagePreviewScreen(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final textTheme = Theme.of(context).textTheme;
    final quantityInCart = CartScope.of(context).quantityOf(product);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailHeader(product: product, onImageTap: _openImagePreview),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoryLabel(category: product.category),
                    const SizedBox(height: 10),
                    Text(
                      product.name,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.tagline,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _RatingRow(
                          rating: product.rating,
                          reviewCount: product.reviewCount,
                        ),
                        _StockBadge(stock: product.stock),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      formatPrice(product.price),
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (quantityInCart > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Sepetinde $quantityInCart adet var',
                        key: const Key('inCartText'),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    const _SectionTitle('Açıklama'),
                    Text(
                      product.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF374151),
                        height: 1.6,
                      ),
                    ),
                    if (product.specs.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const _SectionTitle('Özellikler'),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < product.specs.length; i++) ...[
                            if (i > 0) const SizedBox(width: 10),
                            Expanded(child: _SpecBox(spec: product.specs[i])),
                          ],
                        ],
                      ),
                    ],
                    if (product.colors.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const _SectionTitle('Renk Seçenekleri'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final color in product.colors)
                            Chip(
                              label: Text(color),
                              backgroundColor: AppColors.background,
                              side: const BorderSide(color: AppColors.border),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Alt bar: adet seçici + Sepete Ekle butonu
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                QuantitySelector(
                  quantity: _quantity,
                  onDecrease: _quantity > 1 ? _decrease : null,
                  onIncrease: _quantity < _maxQuantity ? _increase : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    key: const Key('addToCartButton'),
                    onPressed: product.inStock ? _addToCart : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: Text(product.inStock ? 'Sepete Ekle' : 'Tükendi'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Görsel, geri butonu ve sepet butonundan oluşan üst alan.
class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.product, required this.onImageTap});

  final Product product;
  final VoidCallback onImageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        color: CategoryStyle.of(product.category).background,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: onImageTap,
                child: ProductImage(path: product.image, width: 210, height: 210),
              ),
            ),
            Positioned(
              top: 8,
              left: 12,
              child: IconButton(
                tooltip: 'Geri',
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
              ),
            ),
            const Positioned(
              top: 8,
              right: 12,
              child: CartIconButton(filled: true),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: IconButton(
                tooltip: 'Büyüt',
                onPressed: onImageTap,
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                icon: const Icon(Icons.zoom_in_rounded, color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 14, color: style.foreground),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: style.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 20, color: AppColors.star),
        const SizedBox(width: 4),
        Text(
          formatRating(rating),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount yorum)',
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final inStock = stock > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: inStock ? AppColors.successSoft : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        inStock ? 'Stokta $stock adet' : 'Stokta yok',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: inStock ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// "Özellikler" bölümündeki tek bir kutucuk (ör. PİL / 30 saat).
class _SpecBox extends StatelessWidget {
  const _SpecBox({required this.spec});

  final ProductSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spec.label,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Text(
            spec.value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
