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

  test('allows adding the same book multiple times', () {
    const item = BorrowCartItem(
      bookId: '1',
      title: 'Clean Code',
      availableCopies: 5,
    );
    expect(notifier().addBook(item), isTrue);
    expect(notifier().addBook(item), isTrue);
    expect(notifier().addBook(item), isTrue);
    expect(state().items.length, 1);
    expect(state().itemCount, 3);
    expect(state().quantityOf('1'), 3);
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

  test('decrements quantity and removes line at zero', () {
    const item = BorrowCartItem(
      bookId: '1',
      title: 'Clean Code',
      availableCopies: 5,
    );
    notifier().addBook(item);
    notifier().addBook(item);
    notifier().addBook(item);
    expect(state().quantityOf('1'), 3);

    notifier().decrementQuantity('1');
    expect(state().quantityOf('1'), 2);
    expect(state().itemCount, 2);

    notifier().decrementQuantity('1');
    notifier().decrementQuantity('1');
    expect(state().contains('1'), isFalse);
    expect(state().isEmpty, isTrue);
  });

  test('increments quantity from cart controls', () {
    notifier().addBook(
      const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        availableCopies: 5,
      ),
    );
    expect(notifier().incrementQuantity('1'), isTrue);
    expect(state().quantityOf('1'), 2);
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
