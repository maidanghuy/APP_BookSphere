import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BorrowCartState {
  const BorrowCartState({this.items = const []});

  final List<BorrowCartItem> items;

  int get itemCount => items.length;

  bool get isEmpty => items.isEmpty;

  bool contains(String bookId) {
    return items.any((item) => item.bookId == bookId);
  }

  BorrowCartState copyWith({List<BorrowCartItem>? items}) {
    return BorrowCartState(items: items ?? this.items);
  }
}

class BorrowCartNotifier extends Notifier<BorrowCartState> {
  @override
  BorrowCartState build() => const BorrowCartState();

  /// Adds a book when available and not already present.
  /// Returns `true` on success, `false` when duplicate or unavailable.
  bool addBook(BorrowCartItem item) {
    if (!item.isAvailable) {
      return false;
    }
    if (state.contains(item.bookId)) {
      return false;
    }
    state = state.copyWith(items: [...state.items, item]);
    return true;
  }

  void removeBook(String bookId) {
    if (!state.contains(bookId)) {
      return;
    }
    state = state.copyWith(
      items: state.items.where((item) => item.bookId != bookId).toList(),
    );
  }

  void clearCart() {
    if (state.isEmpty) {
      return;
    }
    state = const BorrowCartState();
  }

  bool containsBook(String bookId) => state.contains(bookId);
}

final borrowCartProvider =
    NotifierProvider<BorrowCartNotifier, BorrowCartState>(
      BorrowCartNotifier.new,
    );
