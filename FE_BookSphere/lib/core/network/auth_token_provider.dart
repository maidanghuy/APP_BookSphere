abstract class AuthTokenProvider {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> refreshAccessToken();

  Future<void> onRefreshFailed();
}
