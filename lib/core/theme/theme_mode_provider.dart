import 'package:booksphere_app/core/constants/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system('system'),
  light('light'),
  dark('dark');

  const AppThemeMode(this.storageValue);

  final String storageValue;

  ThemeMode get materialThemeMode {
    return switch (this) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }

  static AppThemeMode fromStorageValue(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, AppThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<AppThemeMode> {
  var _hasLoaded = false;

  @override
  AppThemeMode build() {
    if (!_hasLoaded) {
      _hasLoaded = true;
      Future<void>.microtask(loadThemeMode);
    }

    return AppThemeMode.system;
  }

  ThemeMode get materialThemeMode => state.materialThemeMode;

  Future<void> loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    state = AppThemeMode.fromStorageValue(
      preferences.getString(StorageKeys.themeMode),
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(StorageKeys.themeMode, mode.storageValue);
  }
}
