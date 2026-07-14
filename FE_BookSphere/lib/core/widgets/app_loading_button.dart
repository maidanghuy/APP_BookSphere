import 'package:flutter/material.dart';

class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final Widget button;
    if (!isLoading && icon == null) {
      button = FilledButton(onPressed: effectiveOnPressed, child: Text(label));
    } else {
      button = FilledButton.icon(
        onPressed: effectiveOnPressed,
        icon: isLoading
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(label),
      );
    }

    if (!isExpanded) {
      return button;
    }
    return SizedBox(width: double.infinity, child: button);
  }
}
