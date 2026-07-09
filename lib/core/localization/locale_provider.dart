import 'package:booksphere_app/core/constants/storage_keys.dart';
import 'package:booksphere_app/core/localization/app_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  var _hasLoaded = false;

  @override
  Locale build() {
    if (!_hasLoaded) {
      _hasLoaded = true;
      Future<void>.microtask(loadLocale);
    }

    return AppLocales.vi;
  }

  Locale get currentLocale => state;

  Future<void> loadLocale() async {
    final preferences = await SharedPreferences.getInstance();
    state = AppLocales.fromLanguageCode(
      preferences.getString(StorageKeys.localeCode),
    );
  }

  Future<void> setLocale(Locale locale) async {
    final supportedLocale = AppLocales.fromLanguageCode(locale.languageCode);
    state = supportedLocale;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      StorageKeys.localeCode,
      supportedLocale.languageCode,
    );
  }
}
