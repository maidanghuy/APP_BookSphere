import 'package:booksphere_app/core/localization/app_locales.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/localization/locale_provider.dart';
import 'package:booksphere_app/core/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// BS-APP-25 – Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentTheme = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Theme ──────────────────────────────────────────
          _SectionLabel(label: l10n.settingsThemeSection),
          Card(
            child: Column(
              children: [
                _RadioTile<AppThemeMode>(
                  title: l10n.systemMode,
                  value: AppThemeMode.system,
                  groupValue: currentTheme,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(v),
                ),
                const Divider(height: 1),
                _RadioTile<AppThemeMode>(
                  title: l10n.lightMode,
                  value: AppThemeMode.light,
                  groupValue: currentTheme,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(v),
                ),
                const Divider(height: 1),
                _RadioTile<AppThemeMode>(
                  title: l10n.darkMode,
                  value: AppThemeMode.dark,
                  groupValue: currentTheme,
                  onChanged: (v) =>
                      ref.read(themeModeProvider.notifier).setThemeMode(v),
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Language ───────────────────────────────────────
          _SectionLabel(label: l10n.settingsLanguageSection),
          Card(
            child: Column(
              children: [
                _RadioTile<Locale>(
                  title: l10n.vietnamese,
                  value: AppLocales.vi,
                  groupValue: currentLocale,
                  onChanged: (v) =>
                      ref.read(localeProvider.notifier).setLocale(v),
                ),
                const Divider(height: 1),
                _RadioTile<Locale>(
                  title: l10n.english,
                  value: AppLocales.en,
                  groupValue: currentLocale,
                  onChanged: (v) =>
                      ref.read(localeProvider.notifier).setLocale(v),
                ),
                const Divider(height: 1),
                _RadioTile<Locale>(
                  title: l10n.japanese,
                  value: AppLocales.ja,
                  groupValue: currentLocale,
                  onChanged: (v) =>
                      ref.read(localeProvider.notifier).setLocale(v),
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

// ── Radio tile ────────────────────────────────────────────────

class _RadioTile<T> extends StatelessWidget {
  const _RadioTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.isLast = false,
  });

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
              ),
            ),
            if (selected)
              Icon(Icons.check, size: 20, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
