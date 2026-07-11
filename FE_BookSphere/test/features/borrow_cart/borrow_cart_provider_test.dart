import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  BorrowCartNotifier notifier() => container.read(borrowCartProvider.notifier);

  BorrowCartState state() => container.read(borrowCartProvider);

  test('cart starts empty', () {
    expect(state().isEmpty, isTrue);
    expect(state().itemCount, 0);
  });

  test('adds available book successfully', () {
    final added = notifier().addBook(
      const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        author: 'Uncle Bob',
        availableCopies: 2,
      ),
    );

    expect(added, isTrue);
    expect(state().itemCount, 1);
    expect(state().contains('1'), isTrue);
    expect(notifier().containsBook('1'), isTrue);
  });

  test('does not add duplicate book', () {
    const item = BorrowCartItem(
      bookId: '1',
      title: 'Clean Code',
      availableCopies: 2,
    );
    expect(notifier().addBook(item), isTrue);
    expect(notifier().addBook(item), isFalse);
    expect(state().itemCount, 1);
  });

  test('does not add unavailable book', () {
    final added = notifier().addBook(
      const BorrowCartItem(
        bookId: '2',
        title: 'Out of Stock',
        availableCopies: 0,
      ),
    );

    expect(added, isFalse);
    expect(state().isEmpty, isTrue);
  });

  test('removes book and updates count', () {
    notifier().addBook(
      const BorrowCartItem(bookId: '1', title: 'A', availableCopies: 1),
    );
    notifier().addBook(
      const BorrowCartItem(bookId: '2', title: 'B', availableCopies: 1),
    );

    notifier().removeBook('1');
    expect(state().itemCount, 1);
    expect(state().contains('1'), isFalse);
    expect(state().contains('2'), isTrue);
  });

  test('clear cart empties all items', () {
    notifier().addBook(
      const BorrowCartItem(bookId: '1', title: 'A', availableCopies: 1),
    );
    notifier().addBook(
      const BorrowCartItem(bookId: '2', title: 'B', availableCopies: 1),
    );

    notifier().clearCart();
    expect(state().isEmpty, isTrue);
    expect(state().itemCount, 0);
  });
}
