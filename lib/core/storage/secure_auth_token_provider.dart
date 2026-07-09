import 'package:booksphere_app/core/network/auth_token_provider.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';

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
    throw UnimplementedError(
      'Refresh token flow will be implemented in a later task.',
    );
  }

  @override
  Future<void> onRefreshFailed() {
    return _storageService.clearUserSession();
  }
}
