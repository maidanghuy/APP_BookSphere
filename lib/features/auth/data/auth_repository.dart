import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_api.dart';
import 'package:booksphere_app/features/auth/data/auth_models.dart';

class AuthRepository {
  const AuthRepository(this._authApi, this._secureStorageService);

  final AuthApi _authApi;
  final SecureStorageService _secureStorageService;

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _authApi.login(
      LoginRequest(username: username, password: password),
    );

    await _secureStorageService.saveAccessToken(response.accessToken);
    await _secureStorageService.saveRefreshToken(response.refreshToken);

    final role = response.role;
    if (role != null && role.isNotEmpty) {
      await _secureStorageService.saveUserRole(role);
    }

    final userId = response.userId;
    if (userId != null && userId.isNotEmpty) {
      await _secureStorageService.saveUserId(userId);
    }

    return response;
  }
}
