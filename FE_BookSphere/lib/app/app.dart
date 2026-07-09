import 'package:booksphere_app/app/router.dart';
import 'package:booksphere_app/core/constants/app_constants.dart';
import 'package:booksphere_app/core/localization/app_locales.dart';
import 'package:booksphere_app/core/localization/locale_provider.dart';
import 'package:booksphere_app/core/theme/app_theme.dart';
import 'package:booksphere_app/core/theme/theme_mode_provider.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookSphereApp extends StatelessWidget {
  const BookSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _BookSphereMaterialApp());
  }
}

class _BookSphereMaterialApp extends ConsumerWidget {
  const _BookSphereMaterialApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appThemeMode.materialThemeMode,
      locale: locale,
      supportedLocales: AppLocales.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
