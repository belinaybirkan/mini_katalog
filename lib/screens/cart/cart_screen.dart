import 'package:flutter/material.dart';

import 'package:mini_katalog/screens/cart/order_success_screen.dart';
import 'package:mini_katalog/state/cart_controller.dart';
import 'package:mini_katalog/state/cart_scope.dart';
import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/formatters.dart';
import 'package:mini_katalog/widgets/cart_item_tile.dart';
import 'package:mini_katalog/widgets/empty_state.dart';

/// Sepet sayfası (simülasyon). Gerçek bir ödeme alınmaz.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context, CartController cart) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sepeti temizle'),
          content: const Text('Sepetteki tüm ürünler silinsin mi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Temizle'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      cart.clear();
    }
  }

  void _checkout(BuildContext context, CartController cart) {
    final itemCount = cart.totalQuantity;
    final total = cart.total;
    final orderNumber =
        (DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');

    cart.clear();

    // Navigator.push + MaterialPageRoute ile sipariş onay sayfası açılır.
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => OrderSuccessScreen(
          orderNumber: 'MK$orderNumber',
          itemCount: itemCount,
          total: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: const Text('Temizle'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Sepetin boş',
              message: 'Beğendiğin ürünleri sepete ekleyerek alışverişe başla.',
              actionLabel: 'Alışverişe başla',
              onAction: () => Navigator.maybePop(context),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CartItemTile(
                          key: ValueKey(item.product.id),
                          item: item,
                        ),
                      );
                    },
                  ),
                ),
                _CartSummary(
                  cart: cart,
                  onCheckout: () => _checkout(context, cart),
                ),
              ],
            ),
    );
  }
}

/// Sepetin altındaki toplam tutar ve "Siparişi Tamamla" alanı.
class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.cart, required this.onCheckout});

  final CartController cart;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final shippingText = cart.shippingFee == 0
        ? 'Ücretsiz'
        : formatPrice(cart.shippingFee);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryRow(
                label: 'Ara toplam (${cart.totalQuantity} ürün)',
                value: formatPrice(cart.subtotal),
              ),
              const SizedBox(height: 6),
              _SummaryRow(label: 'Kargo', value: shippingText),
              if (cart.shippingFee > 0) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${formatPrice(CartController.freeShippingThreshold)} ve üzeri siparişlerde kargo ücretsiz.',
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ),
              ],
              const Divider(height: 24),
              _SummaryRow(
                label: 'Toplam',
                value: formatPrice(cart.total),
                emphasized: true,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bu bir eğitim simülasyonudur, gerçek ödeme alınmaz.',
                        style: TextStyle(fontSize: 12, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('checkoutButton'),
                onPressed: onCheckout,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Siparişi Tamamla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)
        : const TextStyle(color: AppColors.muted);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: emphasized
              ? style.copyWith(color: AppColors.accent)
              : const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
