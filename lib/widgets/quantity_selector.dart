import 'package:flutter/material.dart';

import 'package:mini_katalog/theme/app_colors.dart';

/// [ - ]  2  [ + ] şeklinde adet seçici.
///
/// Buton callback'i null verilirse o buton pasif görünür.
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    this.onDecrease,
    this.onIncrease,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  /// Sepet satırlarında daha küçük boyut için true verilir.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final buttonSize = compact ? 30.0 : 44.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            tooltip: 'Azalt',
            size: buttonSize,
            onPressed: onDecrease,
          ),
          SizedBox(
            width: compact ? 24 : 32,
            child: Text(
              '$quantity',
              key: const Key('quantityText'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 13 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            tooltip: 'Artır',
            size: buttonSize,
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.size,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final double size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.55,
            color: enabled ? AppColors.ink : AppColors.border,
          ),
        ),
      ),
    );
  }
}
