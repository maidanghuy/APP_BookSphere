import 'package:booksphere_app/features/books/data/book_repository.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/providers/book_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookDetailProvider = FutureProvider.family
    .autoDispose<BookDetail, String>((ref, bookId) async {
      final repository = ref.watch(bookRepositoryProvider);
      return repository.getBookDetail(bookId);
    });

extension BookDetailProviderX on WidgetRef {
  Future<void> refreshBookDetail(String bookId) async {
    invalidate(bookDetailProvider(bookId));
    try {
      await read(bookDetailProvider(bookId).future);
    } catch (_) {
      // AsyncValue.error already exposes the failure to the UI.
    }
  }
}

BookException? asBookException(Object error) {
  if (error is BookException) {
    return error;
  }

  // Some Riverpod versions wrap provider failures.
  final dynamic candidate = error;
  try {
    final nested = candidate.error;
    if (nested is BookException) {
      return nested;
    }
  } catch (_) {
    // Ignore objects without an `error` field.
  }

  final text = error.toString();
  if (text.contains('BOOK_NOT_FOUND')) {
    return const BookException(
      message: 'Book not found',
      code: 'BOOK_NOT_FOUND',
      statusCode: 404,
    );
  }
  if (text.contains('NETWORK_ERROR')) {
    return const BookException(message: 'Network error', code: 'NETWORK_ERROR');
  }
  if (text.contains('FORBIDDEN')) {
    return const BookException(
      message: 'Forbidden',
      code: 'FORBIDDEN',
      statusCode: 403,
    );
  }
  if (text.contains('SERVER_UNAVAILABLE')) {
    return const BookException(
      message: 'Server unavailable',
      code: 'SERVER_UNAVAILABLE',
      statusCode: 503,
    );
  }
  return null;
}

String? bookDetailErrorCode(Object error) => asBookException(error)?.code;

int? bookDetailErrorStatusCode(Object error) =>
    asBookException(error)?.statusCode;
