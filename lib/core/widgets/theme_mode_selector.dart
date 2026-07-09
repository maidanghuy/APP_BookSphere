import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedMode = ref.watch(themeModeProvider);

    return DropdownButtonFormField<AppThemeMode>(
      key: ValueKey(selectedMode),
      initialValue: selectedMode,
      decoration: InputDecoration(
        labelText: l10n.theme,
        prefixIcon: const Icon(Icons.contrast),
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(
          value: AppThemeMode.system,
          child: Text(l10n.systemMode),
        ),
        DropdownMenuItem(
          value: AppThemeMode.light,
          child: Text(l10n.lightMode),
        ),
        DropdownMenuItem(value: AppThemeMode.dark, child: Text(l10n.darkMode)),
      ],
      onChanged: (mode) {
        if (mode == null) {
          return;
        }

        ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
    );
  }
}
