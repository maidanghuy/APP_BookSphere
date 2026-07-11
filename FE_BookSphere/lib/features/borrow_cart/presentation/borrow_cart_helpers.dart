import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum BorrowCartFeedback { added, unavailable }

BorrowCartFeedback addBookToBorrowCart(WidgetRef ref, BorrowCartItem item) {
  if (!item.isAvailable) {
    return BorrowCartFeedback.unavailable;
  }

  final added = ref.read(borrowCartProvider.notifier).addBook(item);
  return added ? BorrowCartFeedback.added : BorrowCartFeedback.unavailable;
}

void showBorrowCartFeedback(
  BuildContext context,
  WidgetRef ref,
  BorrowCartFeedback feedback,
) {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();

  // Material 3 defaults persist=true when action != null, which keeps the
  // snackbar on screen forever. Force persist: false so duration applies.
  const duration = Duration(seconds: 3);

  switch (feedback) {
    case BorrowCartFeedback.unavailable:
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.bookUnavailable),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          persist: false,
        ),
      );
      return;
    case BorrowCartFeedback.added:
      final count = ref.read(borrowCartProvider).itemCount;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.addedToBorrowList}\n${l10n.borrowListItemCount(count)}',
          ),
          duration: duration,
          behavior: SnackBarBehavior.floating,
          persist: false,
          action: SnackBarAction(
            label: l10n.viewBorrowList,
            onPressed: () {
              messenger.hideCurrentSnackBar();
              context.push('/borrow-cart');
            },
          ),
        ),
      );
  }
}
