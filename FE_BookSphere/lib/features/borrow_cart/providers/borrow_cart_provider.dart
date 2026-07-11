import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BorrowCartState {
  const BorrowCartState({this.items = const []});

  final List<BorrowCartItem> items;

  /// Total quantity across all cart lines.
  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  bool contains(String bookId) {
    return items.any((item) => item.bookId == bookId);
  }

  int quantityOf(String bookId) {
    for (final item in items) {
      if (item.bookId == bookId) {
        return item.quantity;
      }
    }
    return 0;
  }

  BorrowCartState copyWith({List<BorrowCartItem>? items}) {
    return BorrowCartState(items: items ?? this.items);
  }
}

class BorrowCartNotifier extends Notifier<BorrowCartState> {
  @override
  BorrowCartState build() => const BorrowCartState();

  /// Adds a book when available.
  /// If the book is already in the cart, increments its quantity.
  /// Returns `true` on success, `false` when unavailable.
  bool addBook(BorrowCartItem item) {
    if (!item.isAvailable) {
      return false;
    }

    final index = state.items.indexWhere((e) => e.bookId == item.bookId);
    if (index >= 0) {
      final existing = state.items[index];
      final updated = [...state.items];
      updated[index] = existing.copyWith(quantity: existing.quantity + 1);
      state = state.copyWith(items: updated);
      return true;
    }

    state = state.copyWith(items: [...state.items, item.copyWith(quantity: 1)]);
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

  /// Decreases quantity by 1. Removes the line when quantity reaches 0.
  void decrementQuantity(String bookId) {
    final index = state.items.indexWhere((e) => e.bookId == bookId);
    if (index < 0) {
      return;
    }

    final existing = state.items[index];
    if (existing.quantity <= 1) {
      removeBook(bookId);
      return;
    }

    final updated = [...state.items];
    updated[index] = existing.copyWith(quantity: existing.quantity - 1);
    state = state.copyWith(items: updated);
  }

  /// Increases quantity by 1 for an existing cart line.
  bool incrementQuantity(String bookId) {
    final index = state.items.indexWhere((e) => e.bookId == bookId);
    if (index < 0) {
      return false;
    }

    final existing = state.items[index];
    if (!existing.isAvailable) {
      return false;
    }

    final updated = [...state.items];
    updated[index] = existing.copyWith(quantity: existing.quantity + 1);
    state = state.copyWith(items: updated);
    return true;
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
