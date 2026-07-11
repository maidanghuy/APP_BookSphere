import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/features/books/data/book_api.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/data/models/book_page.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:dio/dio.dart';

class BookException implements Exception {
  const BookException({
    required this.message,
    this.code,
    this.statusCode,
    this.apiException,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final ApiException? apiException;

  @override
  String toString() =>
      'BookException(code: $code, statusCode: $statusCode, message: $message)';
}

class BookRepository {
  const BookRepository(this._bookApi);

  final BookApi _bookApi;

  Future<BookPage> getBooks({
    required int page,
    required int size,
    String? keyword,
    String? categoryId,
  }) async {
    try {
      return await _bookApi.getBooks(
        page: page,
        size: size,
        keyword: keyword,
        categoryId: categoryId,
      );
    } on DioException catch (error) {
      throw _mapDioError(error, fallbackMessage: 'Failed to load books.');
    }
  }

  Future<List<CategorySummary>> getCategories() async {
    try {
      return await _bookApi.getCategories();
    } on DioException catch (error) {
      throw _mapDioError(error, fallbackMessage: 'Failed to load categories.');
    }
  }

  Future<BookDetail> getBookDetail(String bookId) async {
    final trimmedId = bookId.trim();
    if (trimmedId.isEmpty) {
      throw const BookException(
        message: 'Book ID is required.',
        code: 'INVALID_BOOK_ID',
        statusCode: 400,
      );
    }

    try {
      return await _bookApi.getBookDetail(trimmedId);
    } on DioException catch (error) {
      throw _mapDioError(error, fallbackMessage: 'Failed to load book detail.');
    }
  }

  BookException _mapDioError(
    DioException error, {
    required String fallbackMessage,
  }) {
    final apiException = ApiException.fromDioException(error);
    final code = _resolveErrorCode(apiException);

    return BookException(
      message: apiException.message.isNotEmpty
          ? apiException.message
          : fallbackMessage,
      code: code,
      statusCode: apiException.statusCode,
      apiException: apiException,
    );
  }

  String? _resolveErrorCode(ApiException apiException) {
    final errors = apiException.errors;
    if (errors != null) {
      for (final error in errors) {
        final code = error.code;
        if (code != null && code.isNotEmpty) {
          return code;
        }
      }
    }

    final statusCode = apiException.statusCode;
    if (statusCode == 401) {
      return 'UNAUTHORIZED';
    }
    if (statusCode == 403) {
      return 'FORBIDDEN';
    }
    if (statusCode == 404) {
      return 'BOOK_NOT_FOUND';
    }
    if (statusCode == null || statusCode == 0) {
      return 'NETWORK_ERROR';
    }
    if (statusCode >= 500) {
      return 'SERVER_UNAVAILABLE';
    }
    return 'UNKNOWN_ERROR';
  }
}
