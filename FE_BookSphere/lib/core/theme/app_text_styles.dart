import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static const headline = TextStyle(fontSize: 28, height: 1.2, fontWeight: FontWeight.w700);
  static const title = TextStyle(fontSize: 18, height: 1.3, fontWeight: FontWeight.w700);
  static const body = TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w400);
  static const label = TextStyle(fontSize: 14, height: 1.3, fontWeight: FontWeight.w600);
  static const caption = TextStyle(fontSize: 12, height: 1.35, fontWeight: FontWeight.w500);

  static TextTheme get textTheme => const TextTheme(
    headlineMedium: headline,
    titleLarge: title,
    titleMedium: TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w700),
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: label,
    labelMedium: caption,
  );
}
