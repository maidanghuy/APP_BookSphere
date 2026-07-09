import 'package:booksphere_app/core/localization/app_locales.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageIconButton extends ConsumerWidget {
  const LanguageIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedLocale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      tooltip: l10n.selectLanguage,
      icon: const Icon(Icons.language),
      iconSize: 22,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) {
        return AppLocales.supportedLocales.map((locale) {
          final isSelected = locale.languageCode == selectedLocale.languageCode;

          return PopupMenuItem<Locale>(
            value: locale,
            child: _CheckedMenuItem(
              isSelected: isSelected,
              label: _label(context, locale),
            ),
          );
        }).toList();
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

class _CheckedMenuItem extends StatelessWidget {
  const _CheckedMenuItem({required this.isSelected, required this.label});

  final bool isSelected;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(isSelected ? Icons.check : Icons.language, size: 18),
        const SizedBox(width: 12),
        Text(label),
      ],
    );
  }
}
