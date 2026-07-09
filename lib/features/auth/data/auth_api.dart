import 'package:booksphere_app/core/constants/api_endpoints.dart';
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
          message: 'Hệ thống tạm thời không khả dụng. Vui lòng thử lại sau.',
          code: 'AUTH_LOGIN_INVALID_RESPONSE',
        );
      }

      final loginResponse = LoginResponse.fromJson(
        Map<String, dynamic>.from(responseData),
      );
      if (!loginResponse.isValid) {
        throw const AuthLoginException(
          message: 'Hệ thống tạm thời không khả dụng. Vui lòng thử lại sau.',
          code: 'AUTH_LOGIN_INVALID_RESPONSE',
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
      message: _messageForLoginError(
        code: code,
        statusCode: statusCode,
        dioException: error,
      ),
      code: code,
      statusCode: statusCode,
    );
  }

  String _messageForLoginError({
    required String? code,
    required int? statusCode,
    required DioException dioException,
  }) {
    return switch (code) {
      'AUTH_INVALID_CREDENTIALS' => 'Tên đăng nhập hoặc mật khẩu không đúng.',
      'AUTH_ACCOUNT_INACTIVE' =>
        'Tài khoản đã bị khóa hoặc chưa được kích hoạt.',
      _ when statusCode == 401 => 'Tên đăng nhập hoặc mật khẩu không đúng.',
      _ when statusCode == 500 || statusCode == 503 =>
        'Hệ thống tạm thời không khả dụng. Vui lòng thử lại sau.',
      _ when _isNetworkError(dioException) =>
        'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng hoặc API Gateway.',
      _ => 'Không thể đăng nhập. Vui lòng thử lại.',
    };
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
    if (message.contains('AUTH_INVALID_CREDENTIALS')) {
      return 'AUTH_INVALID_CREDENTIALS';
    }
    if (message.contains('AUTH_ACCOUNT_INACTIVE')) {
      return 'AUTH_ACCOUNT_INACTIVE';
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
