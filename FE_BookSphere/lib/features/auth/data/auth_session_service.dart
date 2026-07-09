import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/core/utils/jwt_utils.dart';
import 'package:dio/dio.dart';

enum AuthSessionStatus { authenticated, unauthenticated, connectionError }

class AuthSessionService {
  const AuthSessionService({
    required SecureStorageService secureStorageService,
    required DioClient dioClient,
  }) : this._(secureStorageService, dioClient);

  const AuthSessionService._(this._secureStorageService, this._dioClient);

  final SecureStorageService _secureStorageService;
  final DioClient _dioClient;

  Future<AuthSessionStatus> checkSession() async {
    final accessToken = await _secureStorageService.getAccessToken();
    final refreshToken = await _secureStorageService.getRefreshToken();

    if (_isBlank(accessToken) && _isBlank(refreshToken)) {
      return AuthSessionStatus.unauthenticated;
    }

    if (!_isBlank(accessToken)) {
      final expiryDate = JwtUtils.expiryDate(accessToken!);
      if (expiryDate == null) {
        await clearSession();
        return AuthSessionStatus.unauthenticated;
      }

      if (!JwtUtils.isExpired(accessToken)) {
        return AuthSessionStatus.authenticated;
      }

      if (_isBlank(refreshToken)) {
        await clearSession();
        return AuthSessionStatus.unauthenticated;
      }
    }

    try {
      final refreshed = await refreshTokenIfNeeded();
      return refreshed
          ? AuthSessionStatus.authenticated
          : AuthSessionStatus.unauthenticated;
    } on AuthSessionConnectionException {
      return AuthSessionStatus.connectionError;
    }
  }

  Future<bool> refreshTokenIfNeeded() async {
    final refreshToken = await _secureStorageService.getRefreshToken();
    if (_isBlank(refreshToken)) {
      await clearSession();
      return false;
    }

    try {
      final response = await _dioClient.post<Object?>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );
      final newAccessToken = _extractAccessToken(response.data);

      if (_isBlank(newAccessToken)) {
        await clearSession();
        return false;
      }

      await _secureStorageService.saveAccessToken(newAccessToken!);
      return true;
    } on Object catch (error) {
      if (_isConnectionError(error)) {
        throw const AuthSessionConnectionException();
      }

      await clearSession();
      return false;
    }
  }

  Future<void> clearSession() {
    return _secureStorageService.clearUserSession();
  }

  String? _extractAccessToken(Object? responseData) {
    if (responseData is! Map) {
      return null;
    }

    final data = Map<String, dynamic>.from(responseData);
    final nestedData = data['data'];

    if (nestedData is Map) {
      final accessToken = nestedData['accessToken']?.toString();
      if (!_isBlank(accessToken)) {
        return accessToken;
      }
    }

    final accessToken = data['accessToken']?.toString();
    if (!_isBlank(accessToken)) {
      return accessToken;
    }

    return null;
  }

  bool _isConnectionError(Object error) {
    if (error is DioException) {
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

    if (error is ApiException) {
      return error.statusCode == null;
    }

    return false;
  }

  bool _isBlank(String? value) {
    return value == null || value.isEmpty;
  }
}

class AuthSessionConnectionException implements Exception {
  const AuthSessionConnectionException();
}
