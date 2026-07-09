import 'package:booksphere_app/core/widgets/language_icon_button.dart';
import 'package:booksphere_app/core/widgets/theme_mode_icon_button.dart';
import 'package:flutter/material.dart';

class AppTopLeftActions extends StatelessWidget {
  const AppTopLeftActions({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 8),
        child: Material(
          color: colorScheme.surfaceContainerHighest,
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
          shape: StadiumBorder(
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [LanguageIconButton(), ThemeModeIconButton()],
            ),
          ),
        ),
      ),
    );
  }
}
