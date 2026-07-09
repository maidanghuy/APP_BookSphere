import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/features/auth/data/auth_models.dart';
import 'package:dio/dio.dart';

class AuthApi {
  const AuthApi(this._dioClient);

  final DioClient _dioClient;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.post<Object?>(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      final responseData = response.data;

      if (responseData is! Map) {
        throw const AuthLoginException(
          code: AppMessageKeys.authLoginInvalidResponse,
        );
      }

      final loginResponse = LoginResponse.fromJson(
        Map<String, dynamic>.from(responseData),
      );
      if (!loginResponse.isValid) {
        throw const AuthLoginException(
          code: AppMessageKeys.authLoginInvalidResponse,
        );
      }

      return loginResponse;
    } on DioException catch (error) {
      throw _mapDioLoginError(error);
    }
  }

  AuthLoginException _mapDioLoginError(DioException error) {
    final apiException = ApiException.fromDioException(error);
    final code = _resolveErrorCode(apiException);
    final statusCode = apiException.statusCode;

    return AuthLoginException(
      code: code ?? _fallbackCodeForLoginError(statusCode, error),
      statusCode: statusCode,
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

    final rawCode = _resolveRawErrorCode(apiException.rawError);
    if (rawCode != null) {
      return rawCode;
    }

    final message = apiException.message.toUpperCase();
    if (message.contains(AppMessageKeys.authInvalidCredentials)) {
      return AppMessageKeys.authInvalidCredentials;
    }
    if (message.contains(AppMessageKeys.authAccountInactive)) {
      return AppMessageKeys.authAccountInactive;
    }

    return null;
  }

  String? _resolveRawErrorCode(Object? rawError) {
    if (rawError is List) {
      for (final item in rawError) {
        final code = _resolveRawErrorCode(item);
        if (code != null) {
          return code;
        }
      }
    }

    if (rawError is Map) {
      final data = Map<String, dynamic>.from(rawError);
      final code = data['code']?.toString();
      if (code != null && code.isNotEmpty) {
        return code;
      }

      return _resolveRawErrorCode(data['errors']) ??
          _resolveRawErrorCode(data['error']) ??
          _resolveRawErrorCode(data['data']);
    }

    return null;
  }

  String _fallbackCodeForLoginError(int? statusCode, DioException error) {
    if (statusCode == 401) {
      return AppMessageKeys.authInvalidCredentials;
    }
    if (statusCode == 500 || statusCode == 503) {
      return AppMessageKeys.serverUnavailable;
    }
    if (_isNetworkError(error)) {
      return AppMessageKeys.networkError;
    }

    return AppMessageKeys.unknownError;
  }

  bool _isNetworkError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.unknown => error.response == null,
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse ||
      DioExceptionType.cancel ||
      DioExceptionType.transformTimeout => false,
    };
  }
}
