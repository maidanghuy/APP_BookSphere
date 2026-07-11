import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Stepper for selecting borrow quantity against available copies.
class BookQuantitySelector extends StatelessWidget {
  const BookQuantitySelector({
    required this.quantity,
    required this.availableCopies,
    required this.onChanged,
    super.key,
  });

  final int quantity;
  final int availableCopies;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canDecrease = quantity > 1;
    final canIncrease = availableCopies > 0 && quantity < availableCopies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.quantity,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: canDecrease ? () => onChanged(quantity - 1) : null,
              icon: const Icon(Icons.remove),
              tooltip: l10n.quantity,
            ),
            SizedBox(
              width: 56,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: canIncrease ? () => onChanged(quantity + 1) : null,
              icon: const Icon(Icons.add),
              tooltip: l10n.quantity,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          availableCopies > 0
              ? l10n.selectedQuantity(quantity, availableCopies)
              : l10n.bookUnavailable,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: availableCopies > 0
                ? colorScheme.onSurfaceVariant
                : colorScheme.error,
          ),
        ),
      ],
    );
  }
}
