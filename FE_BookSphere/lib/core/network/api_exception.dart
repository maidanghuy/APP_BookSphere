import 'package:booksphere_app/shared/models/api_error.dart';
import 'package:booksphere_app/shared/models/api_response.dart';
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? path;
  final List<ApiError>? errors;
  final Object? rawError;

  const ApiException({
    this.statusCode,
    required this.message,
    this.path,
    this.errors,
    this.rawError,
  });

  factory ApiException.fromDioException(DioException exception) {
    final existingError = exception.error;
    if (existingError is ApiException) {
      return existingError;
    }

    final response = exception.response;
    final responseData = response?.data;
    final apiResponse = _tryParseApiResponse(responseData);
    final statusCode = apiResponse?.status ?? response?.statusCode;

    return ApiException(
      statusCode: statusCode,
      message: _resolveMessage(exception, apiResponse, statusCode),
      path: apiResponse?.path ?? response?.requestOptions.path,
      errors: apiResponse?.errors,
      rawError: existingError ?? responseData ?? exception.message,
    );
  }

  static ApiResponse<Object?>? _tryParseApiResponse(Object? data) {
    if (data is! Map) {
      return null;
    }

    return ApiResponse<Object?>.fromJson(
      Map<String, dynamic>.from(data),
      (json) => json,
    );
  }

  static String _resolveMessage(
    DioException exception,
    ApiResponse<Object?>? apiResponse,
    int? statusCode,
  ) {
    final responseMessage = apiResponse?.message;
    if (responseMessage != null && responseMessage.isNotEmpty) {
      return responseMessage;
    }

    return switch (statusCode) {
      400 => 'Bad request.',
      401 => 'Unauthorized request.',
      403 => 'Forbidden request.',
      404 => 'Resource not found.',
      409 => 'Request conflict.',
      422 => 'Request validation failed.',
      429 => 'Too many requests.',
      500 => 'Internal server error.',
      503 => 'Service unavailable.',
      _ => _messageForDioType(exception),
    };
  }

  static String _messageForDioType(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout => 'Connection timeout.',
      DioExceptionType.sendTimeout => 'Send timeout.',
      DioExceptionType.receiveTimeout => 'Receive timeout.',
      DioExceptionType.transformTimeout => 'Response transform timeout.',
      DioExceptionType.badCertificate => 'Bad SSL certificate.',
      DioExceptionType.badResponse => 'Unexpected API response.',
      DioExceptionType.cancel => 'Request was cancelled.',
      DioExceptionType.connectionError => 'Network connection error.',
      DioExceptionType.unknown =>
        exception.message ?? 'Unexpected network error.',
    };
  }

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message)';
  }
}
