import 'dart:developer' as dev;
import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/features/books/data/book_models.dart';
import 'package:booksphere_app/features/borrows/data/borrow_models.dart';

class BorrowApi {
  const BorrowApi(this._dioClient);

  final DioClient _dioClient;

  Future<BorrowDetailResponse> createBorrow(BorrowCreateRequest request) async {
    try {
      final response = await _dioClient.post<Object?>(
        ApiEndpoints.borrows,
        data: request.toJson(),
      );
      final responseData = response.data;
      dev.log('BorrowApi.createBorrow Response: $responseData');

      if (responseData is! Map) {
        throw Exception('Invalid response format: $responseData');
      }

      final data = responseData['data'];
      if (data is! Map) {
        throw Exception('Invalid response data format: $data');
      }

      final detail = BorrowDetailResponse.fromJson(Map<String, dynamic>.from(data));
      dev.log('BorrowApi.createBorrow Parsed Successfully: ${detail.toJson()}');
      return detail;
    } catch (e, s) {
      dev.log('BorrowApi.createBorrow Exception: $e', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<BookDetailResponse> getBookDetail(int bookId) async {
    try {
      final response = await _dioClient.get<Object?>(
        ApiEndpoints.bookDetail(bookId.toString()),
      );
      final responseData = response.data;
      dev.log('BorrowApi.getBookDetail Response: $responseData');

      if (responseData is! Map) {
        throw Exception('Invalid response format: $responseData');
      }

      final data = responseData['data'];
      if (data is! Map) {
        throw Exception('Invalid response data format: $data');
      }

      return BookDetailResponse.fromJson(Map<String, dynamic>.from(data));
    } catch (e, s) {
      dev.log('BorrowApi.getBookDetail Exception: $e', error: e, stackTrace: s);
      rethrow;
    }
  }
}
