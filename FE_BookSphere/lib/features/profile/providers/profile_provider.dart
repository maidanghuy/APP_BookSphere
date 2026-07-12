import 'package:booksphere_app/core/storage/local_cache_service.dart';
import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/profile/data/profile_api.dart';
import 'package:booksphere_app/features/profile/data/profile_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// BS-APP-24 + BS-APP-28
class ProfileInfo {
  const ProfileInfo({
    this.username,
    this.fullName,
    this.email,
    this.phone,
    this.role,
    this.isActive,
  });

  final String? username;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? role;
  final bool? isActive;
}

final _profileApiProvider = Provider<ProfileApi>((ref) {
  return ProfileApi(ref.watch(dioClientProvider));
});

/// Fetches profile from GET /api/auth/me.
/// Falls back to local SecureStorage if network fails.
/// Caches non-sensitive fields via LocalCacheService.
final profileProvider = FutureProvider<ProfileInfo>((ref) async {
  final api = ref.watch(_profileApiProvider);
  final storage = SecureStorageService();

  try {
    final resp = await api.getMe();
    final info = _fromResponse(resp);

    // Persist to SecureStorage for offline use
    if (info.username != null) await storage.saveUsername(info.username!);
    if (info.fullName != null) await storage.saveFullName(info.fullName!);
    if (info.role != null) await storage.saveUserRole(info.role!);

    // Cache non-sensitive fields
    await LocalCacheService.saveUserInfo({
      'username': info.username,
      'fullName': info.fullName,
      'email': info.email,
      'phone': info.phone,
      'role': info.role,
      'isActive': info.isActive?.toString(),
    });

    return info;
  } catch (_) {
    // Fallback: read from SecureStorage
    final results = await Future.wait([
      storage.getUsername(),
      storage.getFullName(),
      storage.getUserRole(),
    ]);

    final fromStorage = ProfileInfo(
      username: results[0],
      fullName: results[1],
      role: results[2],
    );

    // If storage also empty, try local cache
    if (_isEmpty(fromStorage)) {
      return _fromCache(await LocalCacheService.loadUserInfo());
    }

    return fromStorage;
  }
});

ProfileInfo _fromResponse(ProfileResponse r) => ProfileInfo(
      username: r.username,
      fullName: r.fullName,
      email: r.email,
      phone: r.phone,
      role: r.role,
      isActive: r.isActive,
    );

ProfileInfo _fromCache(Map<String, String?> map) => ProfileInfo(
      username: map['username'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      isActive: map['isActive'] == 'true',
    );

bool _isEmpty(ProfileInfo info) =>
    (info.username == null || info.username!.isEmpty) &&
    (info.fullName == null || info.fullName!.isEmpty);
