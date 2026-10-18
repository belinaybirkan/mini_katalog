import 'package:flutter/material.dart';

import 'package:mini_katalog/theme/app_colors.dart';

/// Uygulamanın basit Material 3 teması.
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Poppins';

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.accent)
        .copyWith(
          primary: AppColors.ink,
          onPrimary: Colors.white,
          secondary: AppColors.accent,
          onSecondary: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.ink,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }
}
