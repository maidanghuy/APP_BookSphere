import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/features/books/data/models/book_page.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:dio/dio.dart';

class BookApi {
  const BookApi(this._dioClient);

  final DioClient _dioClient;

  /// GET /api/books
  ///
  /// Supported query params from BookController:
  /// keyword, categoryId, page (0-based), size, sortBy, sortDir.
  /// Availability is not a backend query parameter.
  Future<BookPage> getBooks({
    required int page,
    required int size,
    String? keyword,
    String? categoryId,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'size': size,
      'sortBy': 'id',
      'sortDir': 'asc',
    };

    final trimmedKeyword = keyword?.trim();
    if (trimmedKeyword != null && trimmedKeyword.isNotEmpty) {
      queryParameters['keyword'] = trimmedKeyword;
    }

    final trimmedCategoryId = categoryId?.trim();
    if (trimmedCategoryId != null && trimmedCategoryId.isNotEmpty) {
      queryParameters['categoryId'] = trimmedCategoryId;
    }

    final response = await _dioClient.get<Object?>(
      ApiEndpoints.books,
      queryParameters: queryParameters,
    );

    return _parseBookPage(response.data);
  }

  /// GET /api/categories
  Future<List<CategorySummary>> getCategories() async {
    final response = await _dioClient.get<Object?>(ApiEndpoints.categories);
    return _parseCategories(response.data);
  }

  BookPage _parseBookPage(Object? responseData) {
    if (responseData is! Map) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.books),
        error: 'Unexpected books response format.',
        type: DioExceptionType.badResponse,
      );
    }

    final root = Map<String, dynamic>.from(responseData);
    final rawData = root['data'];

    if (rawData is Map) {
      return BookPage.fromJson(Map<String, dynamic>.from(rawData));
    }

    throw DioException(
      requestOptions: RequestOptions(path: ApiEndpoints.books),
      error: root['message']?.toString() ?? 'Failed to load books.',
      type: DioExceptionType.badResponse,
    );
  }

  List<CategorySummary> _parseCategories(Object? responseData) {
    if (responseData is! Map) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.categories),
        error: 'Unexpected categories response format.',
        type: DioExceptionType.badResponse,
      );
    }

    final root = Map<String, dynamic>.from(responseData);
    final rawData = root['data'];

    if (rawData is List) {
      return rawData
          .whereType<Map>()
          .map(
            (item) => CategorySummary.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    }

    throw DioException(
      requestOptions: RequestOptions(path: ApiEndpoints.categories),
      error: root['message']?.toString() ?? 'Failed to load categories.',
      type: DioExceptionType.badResponse,
    );
  }
}
