import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/features/profile/data/profile_models.dart';

/// Calls GET /api/auth/me via API Gateway (requires Bearer token).
class ProfileApi {
  const ProfileApi(this._dioClient);

  final DioClient _dioClient;

  Future<ProfileResponse> getMe() async {
    final response = await _dioClient.get<Object?>(ApiEndpoints.me);
    final data = response.data;
    if (data is Map) {
      return ProfileResponse.fromJson(Map<String, dynamic>.from(data));
    }
    return const ProfileResponse();
  }
}
