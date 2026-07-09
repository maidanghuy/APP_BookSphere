import 'package:booksphere_app/core/localization/app_locales.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedLocale = ref.watch(localeProvider);

    return DropdownButtonFormField<Locale>(
      key: ValueKey(selectedLocale.languageCode),
      initialValue: selectedLocale,
      decoration: InputDecoration(
        labelText: l10n.language,
        prefixIcon: const Icon(Icons.language),
        border: const OutlineInputBorder(),
      ),
      items: AppLocales.supportedLocales.map((locale) {
        return DropdownMenuItem(
          value: locale,
          child: Text(_label(context, locale)),
        );
      }).toList(),
      onChanged: (locale) {
        if (locale == null) {
          return;
        }

        ref.read(localeProvider.notifier).setLocale(locale);
      },
    );
  }

  String _label(BuildContext context, Locale locale) {
    final l10n = context.l10n;

    return switch (locale.languageCode) {
      'vi' => l10n.vietnamese,
      'en' => l10n.english,
      'ja' => l10n.japanese,
      _ => l10n.vietnamese,
    };
  }
}
