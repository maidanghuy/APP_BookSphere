import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum BorrowCartFeedback { added, alreadyInCart, unavailable }

BorrowCartFeedback addBookToBorrowCart(WidgetRef ref, BorrowCartItem item) {
  if (!item.isAvailable) {
    return BorrowCartFeedback.unavailable;
  }

  final notifier = ref.read(borrowCartProvider.notifier);
  if (notifier.containsBook(item.bookId)) {
    return BorrowCartFeedback.alreadyInCart;
  }

  final added = notifier.addBook(item);
  return added ? BorrowCartFeedback.added : BorrowCartFeedback.alreadyInCart;
}

void showBorrowCartFeedback(
  BuildContext context,
  WidgetRef ref,
  BorrowCartFeedback feedback,
) {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  switch (feedback) {
    case BorrowCartFeedback.unavailable:
      messenger.showSnackBar(SnackBar(content: Text(l10n.bookUnavailable)));
      return;
    case BorrowCartFeedback.alreadyInCart:
      messenger.showSnackBar(SnackBar(content: Text(l10n.alreadyInBorrowList)));
      return;
    case BorrowCartFeedback.added:
      final count = ref.read(borrowCartProvider).itemCount;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.addedToBorrowList}\n${l10n.borrowListItemCount(count)}',
          ),
          action: SnackBarAction(
            label: l10n.viewBorrowList,
            onPressed: () => context.push('/borrow-cart'),
          ),
        ),
      );
  }
}
