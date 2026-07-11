import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/features/books/data/book_models.dart';
import 'package:booksphere_app/features/borrows/data/borrow_api.dart';
import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
import 'package:dio/dio.dart';

class BorrowException implements Exception {
  const BorrowException({required this.code, this.message, this.statusCode});

  final String code;
  final String? message;
  final int? statusCode;

  @override
  String toString() => 'BorrowException(code: $code, message: $message)';
}

class BorrowRepository {
  const BorrowRepository(this._borrowApi);

  final BorrowApi _borrowApi;

  Future<BorrowDetailResponse> createBorrow({
    required int bookId,
    required int quantity,
    required DateTime dueDate,
  }) async {
    try {
      final isoDueDate = dueDate.toIso8601String();
      final request = BorrowCreateRequest(
        dueDate: isoDueDate,
        items: [BorrowItemRequest(bookId: bookId, quantity: quantity)],
      );
      return await _borrowApi.createBorrow(request);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<BookDetailResponse> getBookDetail(int bookId) async {
    try {
      return await _borrowApi.getBookDetail(bookId);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<BorrowPageResponse> searchBorrows({
    String? status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      return await _borrowApi.searchBorrows(
        status: status,
        page: page,
        size: size,
      );
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<BorrowDetailResponse> getBorrowDetail(int borrowId) async {
    try {
      return await _borrowApi.getBorrowDetail(borrowId);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<BorrowDetailResponse> returnBorrow(int borrowId) async {
    try {
      return await _borrowApi.returnBorrow(borrowId);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  BorrowException _mapDioError(DioException error) {
    final apiException = ApiException.fromDioException(error);
    final code = _resolveErrorCode(apiException);
    
    return BorrowException(
      code: code ?? 'UNKNOWN_ERROR',
      message: apiException.message,
      statusCode: apiException.statusCode,
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

    final rawError = apiException.rawError;
    if (rawError is Map) {
      final code = rawError['code']?.toString();
      if (code != null && code.isNotEmpty) {
        return code;
      }
      final errorField = rawError['error']?.toString();
      if (errorField != null && errorField.isNotEmpty) {
        return errorField;
      }
    }
    
    return null;
  }
}
