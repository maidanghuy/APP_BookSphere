import 'package:booksphere_app/core/config/app_config.dart';
import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/network/auth_interceptor.dart';
import 'package:booksphere_app/core/network/auth_token_provider.dart';
import 'package:booksphere_app/core/network/network_constants.dart';
import 'package:booksphere_app/shared/models/api_response.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient({
    Dio? dio,
    AuthTokenProvider? authTokenProvider,
    List<Interceptor> interceptors = const [],
  }) : _dio = dio ?? Dio(_baseOptions()) {
    if (authTokenProvider != null) {
      _dio.interceptors.add(
        AuthInterceptor(dio: _dio, tokenProvider: authTokenProvider),
      );
    }

    _dio.interceptors.add(_ApiResponseInterceptor());
    _dio.interceptors.add(_ApiErrorInterceptor());
    _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;

  Dio get rawDio => _dio;

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      sendTimeout: NetworkConstants.sendTimeout,
      headers: const {
        NetworkConstants.acceptHeader: NetworkConstants.applicationJson,
        NetworkConstants.contentTypeHeader: NetworkConstants.applicationJson,
      },
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}

class _ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = response.data;

    if (responseData is Map && responseData.containsKey('success')) {
      final apiResponse = ApiResponse<Object?>.fromJson(
        Map<String, dynamic>.from(responseData),
        (json) => json,
      );

      if (!apiResponse.success) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: ApiException(
              statusCode: apiResponse.status ?? response.statusCode,
              message: apiResponse.message.isNotEmpty
                  ? apiResponse.message
                  : 'API request failed.',
              path: apiResponse.path ?? response.requestOptions.path,
              errors: apiResponse.errors,
              rawError: responseData,
            ),
          ),
        );
        return;
      }
    }

    handler.next(response);
  }
}

class _ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = ApiException.fromDioException(err);

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
        message: apiException.message,
        stackTrace: err.stackTrace,
      ),
    );
  }
}
