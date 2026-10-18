import 'package:flutter/material.dart';

import 'package:mini_katalog/widgets/empty_state.dart';

/// Yanlış bir route adı veya eksik argüman olduğunda gösterilen sayfa.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bir sorun oluştu')),
      body: EmptyState(
        icon: Icons.error_outline_rounded,
        title: 'Sayfa açılamadı',
        message: message,
        actionLabel: 'Geri dön',
        onAction: () => Navigator.maybePop(context),
      ),
    );
  }
}
