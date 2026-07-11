import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_auth_token_provider.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final secureAuthTokenProvider = Provider<SecureAuthTokenProvider>((ref) {
  return SecureAuthTokenProvider(ref.watch(secureStorageServiceProvider));
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(authTokenProvider: ref.watch(secureAuthTokenProvider));
});

final authSessionServiceProvider = Provider<AuthSessionService>((ref) {
  return AuthSessionService(
    secureStorageService: ref.watch(secureStorageServiceProvider),
    dioClient: ref.watch(dioClientProvider),
  );
});
