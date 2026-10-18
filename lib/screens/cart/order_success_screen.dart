import 'package:flutter/material.dart';

import 'package:mini_katalog/theme/app_colors.dart';
import 'package:mini_katalog/utils/formatters.dart';

/// Sipariş tamamlandıktan sonra gösterilen onay sayfası (simülasyon).
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.itemCount,
    required this.total,
  });

  final String orderNumber;
  final int itemCount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  color: AppColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Siparişin alındı!',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sipariş numaran: #$orderNumber',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.accent,
                  ),
                  title: Text('$itemCount ürün'),
                  subtitle: const Text('Ödenen tutar (simülasyon)'),
                  trailing: Text(
                    formatPrice(total),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bu uygulama bir eğitim projesidir; gerçek bir ödeme veya teslimat yapılmaz.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
              const Spacer(),
              FilledButton(
                key: const Key('continueShoppingButton'),
                // Aradaki tüm sayfaları kapatıp ana sayfaya döner.
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Alışverişe Devam Et'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
