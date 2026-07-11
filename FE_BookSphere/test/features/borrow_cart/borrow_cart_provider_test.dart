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

  test('adds item with quantity 1', () {
    final result = notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        quantity: 1,
        availableCopies: 5,
      ),
    );
    expect(result, BorrowCartAddResult.added);
    expect(state().totalQuantity, 1);
    expect(state().distinctBookCount, 1);
  });

  test('adds item with quantity greater than 1', () {
    final result = notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        quantity: 3,
        availableCopies: 5,
      ),
    );
    expect(result, BorrowCartAddResult.added);
    expect(state().totalQuantity, 3);
    expect(state().distinctBookCount, 1);
  });

  test('does not create duplicate bookId', () {
    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        quantity: 1,
        availableCopies: 5,
      ),
    );
    final second = notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        quantity: 2,
        availableCopies: 5,
      ),
    );
    expect(second, BorrowCartAddResult.alreadyExists);
    expect(state().distinctBookCount, 1);
    expect(state().totalQuantity, 1);
  });

  test('updates quantity', () {
    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'Clean Code',
        quantity: 1,
        availableCopies: 5,
      ),
    );
    final result = notifier().updateQuantity(
      bookId: '1',
      quantity: 4,
      availableCopies: 5,
    );
    expect(result, BorrowCartUpdateResult.updated);
    expect(state().totalQuantity, 4);
  });

  test('rejects quantity less than 1', () {
    expect(
      notifier().addBook(
        item: const BorrowCartItem(
          bookId: '1',
          title: 'A',
          quantity: 0,
          availableCopies: 5,
        ),
      ),
      BorrowCartAddResult.invalidQuantity,
    );

    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'A',
        quantity: 2,
        availableCopies: 5,
      ),
    );
    expect(
      notifier().updateQuantity(bookId: '1', quantity: 0, availableCopies: 5),
      BorrowCartUpdateResult.invalidQuantity,
    );
  });

  test('rejects quantity greater than available', () {
    expect(
      notifier().addBook(
        item: const BorrowCartItem(
          bookId: '1',
          title: 'A',
          quantity: 6,
          availableCopies: 5,
        ),
      ),
      BorrowCartAddResult.invalidQuantity,
    );

    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'A',
        quantity: 1,
        availableCopies: 5,
      ),
    );
    expect(
      notifier().updateQuantity(bookId: '1', quantity: 9, availableCopies: 5),
      BorrowCartUpdateResult.invalidQuantity,
    );
  });

  test('totalQuantity and distinctBookCount stay correct', () {
    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'A',
        quantity: 2,
        availableCopies: 5,
      ),
    );
    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '2',
        title: 'B',
        quantity: 1,
        availableCopies: 3,
      ),
    );
    expect(state().distinctBookCount, 2);
    expect(state().totalQuantity, 3);
  });

  test('removes item and clears cart', () {
    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '1',
        title: 'A',
        quantity: 2,
        availableCopies: 5,
      ),
    );
    notifier().addBook(
      item: const BorrowCartItem(
        bookId: '2',
        title: 'B',
        quantity: 1,
        availableCopies: 3,
      ),
    );
    notifier().removeBook('1');
    expect(state().distinctBookCount, 1);
    expect(state().totalQuantity, 1);
    notifier().clearCart();
    expect(state().isEmpty, isTrue);
  });
}
