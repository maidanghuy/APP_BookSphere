import 'package:flutter/material.dart';
import 'package:booksphere_app/core/theme/app_colors.dart';
import 'package:booksphere_app/core/theme/app_radius.dart';
import 'package:booksphere_app/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
      outline: AppColors.outline,
    );
    return _theme(scheme).copyWith(scaffoldBackgroundColor: AppColors.background);
  }

  static ThemeData get darkTheme => _theme(
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
  );

  static ThemeData _theme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTextStyles.textTheme,
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        shadowColor: scheme.shadow.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgBorder),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
          textStyle: AppTextStyles.label,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
          textStyle: AppTextStyles.label,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        constraints: BoxConstraints(minHeight: 48),
        border: OutlineInputBorder(borderRadius: AppRadius.mdBorder),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdBorder,
          borderSide: BorderSide(color: AppColors.outline),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smBorder),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: AppTextStyles.caption,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 72,
        indicatorShape: RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
        labelTextStyle: WidgetStatePropertyAll(AppTextStyles.caption),
      ),
    );
  }
}
