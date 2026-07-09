import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final authSessionServiceProvider = Provider<AuthSessionService>((ref) {
  return AuthSessionService(
    secureStorageService: ref.watch(secureStorageServiceProvider),
    dioClient: ref.watch(dioClientProvider),
  );
});
