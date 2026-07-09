import 'package:flutter/material.dart';

class AppLocales {
  const AppLocales._();

  static const Locale vi = Locale('vi');
  static const Locale en = Locale('en');
  static const Locale ja = Locale('ja');

  static const List<Locale> supportedLocales = [vi, en, ja];

  static Locale fromLanguageCode(String? languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => vi,
    );
  }
}
