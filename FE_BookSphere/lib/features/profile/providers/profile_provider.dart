import 'package:booksphere_app/core/storage/local_cache_service.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileInfo {
  const ProfileInfo({
    this.username,
    this.fullName,
    this.role,
  });

  final String? username;
  final String? fullName;
  final String? role;
}

/// BS-APP-24 + BS-APP-28
/// Đọc thông tin profile từ SecureStorage.
/// Cache profile (non-sensitive) vào LocalCacheService để hiển thị nhanh.
final profileProvider = FutureProvider<ProfileInfo>((ref) async {
  final storage = SecureStorageService();

  final results = await Future.wait([
    storage.getUsername(),
    storage.getFullName(),
    storage.getUserRole(),
  ]);

  final info = ProfileInfo(
    username: results[0],
    fullName: results[1],
    role: results[2],
  );

  // Lưu cache user info (không nhạy cảm)
  await LocalCacheService.saveUserInfo({
    'username': info.username,
    'fullName': info.fullName,
    'role': info.role,
  });

  return info;
});

/// Đọc profile từ cache (dùng khi cần hiển thị offline).
Future<ProfileInfo> loadProfileFromCache() async {
  final map = await LocalCacheService.loadUserInfo();
  return ProfileInfo(
    username: map['username'],
    fullName: map['fullName'],
    role: map['role'],
  );
}
