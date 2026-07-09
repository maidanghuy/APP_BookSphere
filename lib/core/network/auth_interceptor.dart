import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/network/auth_token_provider.dart';
import 'package:booksphere_app/core/network/network_constants.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  factory AuthInterceptor({
    required Dio dio,
    required AuthTokenProvider tokenProvider,
  }) {
    return AuthInterceptor._(dio, tokenProvider);
  }

  AuthInterceptor._(this._dio, this._tokenProvider);

  static const _retryExtraKey = 'booksphere_retry_after_refresh';

  final Dio _dio;
  final AuthTokenProvider _tokenProvider;
  Future<String?>? _refreshTokenFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldBypassAuth(options.path)) {
      handler.next(options);
      return;
    }

    try {
      final accessToken = await _tokenProvider.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers[NetworkConstants.authorizationHeader] =
            '${NetworkConstants.bearerPrefix} $accessToken';
      }
      handler.next(options);
    } on Object catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: ApiException(
            message: 'Unable to resolve access token.',
            rawError: error,
          ),
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final requestOptions = err.requestOptions;
    final alreadyRetried = requestOptions.extra[_retryExtraKey] == true;

    if (statusCode != 401 ||
        alreadyRetried ||
        _shouldBypassAuth(requestOptions.path)) {
      if (statusCode == 401 && alreadyRetried) {
        await _tokenProvider.onRefreshFailed();
      }
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await _tokenProvider.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _tokenProvider.onRefreshFailed();
        handler.next(err);
        return;
      }

      final newAccessToken = await _refreshAccessToken();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _tokenProvider.onRefreshFailed();
        handler.next(err);
        return;
      }

      final retryOptions = _copyRequestOptionsWithToken(
        requestOptions,
        newAccessToken,
      );
      final response = await _dio.fetch<Object?>(retryOptions);
      handler.resolve(response);
    } on Object {
      await _tokenProvider.onRefreshFailed();
      handler.next(err);
    }
  }

  Future<String?> _refreshAccessToken() {
    final currentRefresh = _refreshTokenFuture;
    if (currentRefresh != null) {
      return currentRefresh;
    }

    final refresh = _tokenProvider.refreshAccessToken();
    _refreshTokenFuture = refresh.whenComplete(() {
      _refreshTokenFuture = null;
    });
    return _refreshTokenFuture!;
  }

  RequestOptions _copyRequestOptionsWithToken(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    return requestOptions.copyWith(
      headers: {
        ...requestOptions.headers,
        NetworkConstants.authorizationHeader:
            '${NetworkConstants.bearerPrefix} $accessToken',
      },
      extra: {...requestOptions.extra, _retryExtraKey: true},
    );
  }

  bool _shouldBypassAuth(String path) {
    final normalizedPath = path.toLowerCase();
    return NetworkConstants.authBypassPathSegments.any(normalizedPath.contains);
  }
}
