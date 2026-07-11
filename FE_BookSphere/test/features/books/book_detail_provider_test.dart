import 'package:booksphere_app/features/books/data/book_repository.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart';
import 'package:booksphere_app/features/books/providers/book_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBookRepository extends Mock implements BookRepository {}

void main() {
  late _MockBookRepository repository;

  setUp(() {
    repository = _MockBookRepository();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [bookRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('loads book detail successfully for bookId', () async {
    when(() => repository.getBookDetail('1')).thenAnswer(
      (_) async => const BookDetail(
        id: '1',
        title: 'Clean Code',
        author: 'Robert C. Martin',
        availableQuantity: 3,
      ),
    );

    final container = createContainer();
    final subscription = container.listen(bookDetailProvider('1'), (_, _) {});
    addTearDown(subscription.close);

    final book = await container.read(bookDetailProvider('1').future);

    expect(book.id, '1');
    expect(book.title, 'Clean Code');
    verify(() => repository.getBookDetail('1')).called(1);
  });

  test('surfaces not-found error', () async {
    when(() => repository.getBookDetail('99')).thenAnswer(
      (_) async => throw const BookException(
        message: 'Book not found',
        code: 'BOOK_NOT_FOUND',
        statusCode: 404,
      ),
    );

    final container = createContainer();
    Object? capturedError;
    final subscription = container.listen(bookDetailProvider('99'), (_, next) {
      if (next.hasError) {
        capturedError = next.error;
      }
    });
    addTearDown(subscription.close);

    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(capturedError, isA<BookException>());
    expect((capturedError! as BookException).code, 'BOOK_NOT_FOUND');
  });

  test('keeps separate state for different book ids', () async {
    when(
      () => repository.getBookDetail('1'),
    ).thenAnswer((_) async => const BookDetail(id: '1', title: 'Book A'));
    when(
      () => repository.getBookDetail('2'),
    ).thenAnswer((_) async => const BookDetail(id: '2', title: 'Book B'));

    final container = createContainer();
    final subA = container.listen(bookDetailProvider('1'), (_, _) {});
    final subB = container.listen(bookDetailProvider('2'), (_, _) {});
    addTearDown(subA.close);
    addTearDown(subB.close);

    final bookA = await container.read(bookDetailProvider('1').future);
    final bookB = await container.read(bookDetailProvider('2').future);

    expect(bookA.title, 'Book A');
    expect(bookB.title, 'Book B');
  });

  test('retry invalidates and reloads', () async {
    var calls = 0;
    when(() => repository.getBookDetail('1')).thenAnswer((_) async {
      calls += 1;
      return BookDetail(id: '1', title: 'Call $calls');
    });

    final container = createContainer();
    final subscription = container.listen(bookDetailProvider('1'), (_, _) {});
    addTearDown(subscription.close);

    final first = await container.read(bookDetailProvider('1').future);
    expect(first.title, 'Call 1');

    container.invalidate(bookDetailProvider('1'));
    final second = await container.read(bookDetailProvider('1').future);
    expect(second.title, 'Call 2');
    expect(calls, 2);
  });
}
