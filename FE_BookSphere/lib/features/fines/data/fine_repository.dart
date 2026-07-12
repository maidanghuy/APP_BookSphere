import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/fines/data/fine_api.dart';
import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:dio/dio.dart';

class FineRepository {
  const FineRepository({
    required FineApi fineApi,
    required SecureStorageService storageService,
  })  : _fineApi = fineApi,
        _storageService = storageService;

  final FineApi _fineApi;
  final SecureStorageService _storageService;

  Future<List<FineResponse>> getMyFines({String? status}) async {
    final userId = await _storageService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw const FineException(message: 'User session not found.');
    }

    final response = await _fineApi.getFines(
      userId: userId,
      status: status,
    );

    return _parsePageContent(response.data);
  }

  Future<FineResponse> getFineById(String fineId) async {
    final response = await _fineApi.getFineById(fineId);
    return _parseSingle(response.data);
  }

  Future<FinePaymentResponse> payFine(
    String fineId,
    PayFineRequest request,
  ) async {
    try {
      final response = await _fineApi.payFine(fineId, request.toJson());
      return _parsePayment(response.data);
    } on DioException catch (e) {
      final apiEx = e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioException(e);
      throw FineException(message: apiEx.message, apiException: apiEx);
    }
  }

  // ── Parsers ───────────────────────────────────────────────

  List<FineResponse> _parsePageContent(Object? responseData) {
    if (responseData is! Map) {
      throw const FineException(message: 'Unexpected response format.');
    }

    final root = Map<String, dynamic>.from(responseData);
    final rawData = root['data'];

    if (rawData is Map) {
      // PageResponse: { content: [...], page, size, totalElements, totalPages }
      final page = Map<String, dynamic>.from(rawData);
      final content = page['content'];
      if (content is List) {
        return content
            .whereType<Map>()
            .map((e) => FineResponse.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    if (rawData is List) {
      return rawData
          .whereType<Map>()
          .map((e) => FineResponse.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    throw FineException(
      message: root['message']?.toString() ?? 'Failed to load fines.',
    );
  }

  FineResponse _parseSingle(Object? responseData) {
    if (responseData is! Map) {
      throw const FineException(message: 'Unexpected response format.');
    }

    final root = Map<String, dynamic>.from(responseData);
    final rawData = root['data'];

    if (rawData is Map) {
      return FineResponse.fromJson(Map<String, dynamic>.from(rawData));
    }

    throw FineException(
      message: root['message']?.toString() ?? 'Failed to load fine detail.',
    );
  }

  FinePaymentResponse _parsePayment(Object? responseData) {
    if (responseData is! Map) {
      throw const FineException(message: 'Unexpected response format.');
    }

    final root = Map<String, dynamic>.from(responseData);
    final rawData = root['data'];

    if (rawData is Map) {
      return FinePaymentResponse.fromJson(Map<String, dynamic>.from(rawData));
    }

    throw FineException(
      message: root['message']?.toString() ?? 'Failed to process payment.',
    );
  }
}

class FineException implements Exception {
  const FineException({required this.message, this.apiException});

  final String message;
  final ApiException? apiException;

  int? get statusCode => apiException?.statusCode;

  @override
  String toString() => 'FineException(message: $message)';
}
