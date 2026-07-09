import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeIconButton extends ConsumerWidget {
  const ThemeModeIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedMode = ref.watch(themeModeProvider);

    return PopupMenuButton<AppThemeMode>(
      tooltip: l10n.selectTheme,
      icon: Icon(_iconFor(selectedMode)),
      iconSize: 22,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (mode) {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
      itemBuilder: (context) {
        return AppThemeMode.values.map((mode) {
          final isSelected = mode == selectedMode;

          return PopupMenuItem<AppThemeMode>(
            value: mode,
            child: Row(
              children: [
                Icon(isSelected ? Icons.check : _iconFor(mode), size: 18),
                const SizedBox(width: 12),
                Text(_label(context, mode)),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  IconData _iconFor(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => Icons.brightness_auto,
      AppThemeMode.light => Icons.light_mode,
      AppThemeMode.dark => Icons.dark_mode,
    };
  }

  String _label(BuildContext context, AppThemeMode mode) {
    final l10n = context.l10n;

    return switch (mode) {
      AppThemeMode.system => l10n.systemMode,
      AppThemeMode.light => l10n.lightMode,
      AppThemeMode.dark => l10n.darkMode,
    };
  }
}
