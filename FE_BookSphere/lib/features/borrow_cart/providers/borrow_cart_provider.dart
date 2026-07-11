import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BorrowCartState {
  const BorrowCartState({this.items = const []});

  final List<BorrowCartItem> items;

  int get distinctBookCount => items.length;

  int get totalQuantity =>
      items.fold<int>(0, (total, item) => total + item.quantity);

  /// Alias used by badge / floating cart for total quantity.
  int get itemCount => totalQuantity;

  bool get isEmpty => items.isEmpty;

  bool contains(String bookId) {
    return items.any((item) => item.bookId == bookId);
  }

  BorrowCartItem? findByBookId(String bookId) {
    for (final item in items) {
      if (item.bookId == bookId) {
        return item;
      }
    }
    return null;
  }

  int quantityOf(String bookId) => findByBookId(bookId)?.quantity ?? 0;

  BorrowCartState copyWith({List<BorrowCartItem>? items}) {
    return BorrowCartState(items: items ?? this.items);
  }
}

enum BorrowCartAddResult { added, alreadyExists, unavailable, invalidQuantity }

enum BorrowCartUpdateResult { updated, notFound, unavailable, invalidQuantity }

class BorrowCartNotifier extends Notifier<BorrowCartState> {
  @override
  BorrowCartState build() => const BorrowCartState();

  /// Adds a new book line. Does not create duplicates or silently merge.
  BorrowCartAddResult addBook({required BorrowCartItem item}) {
    if (!item.isAvailable) {
      return BorrowCartAddResult.unavailable;
    }
    if (item.quantity < 1) {
      return BorrowCartAddResult.invalidQuantity;
    }
    if (item.quantity > item.availableCopies) {
      return BorrowCartAddResult.invalidQuantity;
    }
    if (state.contains(item.bookId)) {
      return BorrowCartAddResult.alreadyExists;
    }

    state = state.copyWith(items: [...state.items, item]);
    return BorrowCartAddResult.added;
  }

  BorrowCartUpdateResult updateQuantity({
    required String bookId,
    required int quantity,
    required int availableCopies,
  }) {
    if (availableCopies <= 0) {
      return BorrowCartUpdateResult.unavailable;
    }
    if (quantity < 1) {
      return BorrowCartUpdateResult.invalidQuantity;
    }
    if (quantity > availableCopies) {
      return BorrowCartUpdateResult.invalidQuantity;
    }

    final index = state.items.indexWhere((e) => e.bookId == bookId);
    if (index < 0) {
      return BorrowCartUpdateResult.notFound;
    }

    final existing = state.items[index];
    final updated = [...state.items];
    updated[index] = existing.copyWith(
      quantity: quantity,
      availableCopies: availableCopies,
    );
    state = state.copyWith(items: updated);
    return BorrowCartUpdateResult.updated;
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

  BorrowCartItem? getItem(String bookId) => state.findByBookId(bookId);
}

final borrowCartProvider =
    NotifierProvider<BorrowCartNotifier, BorrowCartState>(
      BorrowCartNotifier.new,
    );
