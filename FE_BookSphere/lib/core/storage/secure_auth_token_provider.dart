import 'package:booksphere_app/core/config/app_config.dart';
import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/auth_token_provider.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';

class SecureAuthTokenProvider implements AuthTokenProvider {
  SecureAuthTokenProvider(this._storageService);

  final SecureStorageService _storageService;

  @override
  Future<String?> getAccessToken() {
    return _storageService.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() {
    return _storageService.getRefreshToken();
  }

  @override
  Future<String?> refreshAccessToken() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    try {
      final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );
      final responseData = response.data;
      if (responseData == null) return null;
      
      final success = responseData['success'] == true;
      if (!success) return null;
      
      final data = responseData['data'];
      String? newAccessToken;
      if (data is Map) {
        newAccessToken = data['accessToken']?.toString();
      } else {
        newAccessToken = responseData['accessToken']?.toString();
      }
      
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await _storageService.saveAccessToken(newAccessToken);
        return newAccessToken;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> onRefreshFailed() {
    return _storageService.clearUserSession();
  }
}
