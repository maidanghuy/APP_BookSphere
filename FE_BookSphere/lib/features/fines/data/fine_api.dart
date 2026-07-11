import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class FineApi {
  const FineApi(this._dioClient);

  final DioClient _dioClient;

  /// GET /api/fines?userId=&status=&page=&size=&sortBy=&sortDir=
  Future<Response<Object?>> getFines({
    required String userId,
    String? status,
    int page = 0,
    int size = 20,
  }) {
    final params = <String, dynamic>{
      'userId': userId,
      'page': page,
      'size': size,
      'sortBy': 'createdAt',
      'sortDir': 'desc',
    };
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }
    return _dioClient.get<Object?>(
      ApiEndpoints.fines,
      queryParameters: params,
    );
  }

  /// GET /api/fines/{fineId}
  Future<Response<Object?>> getFineById(String fineId) {
    return _dioClient.get<Object?>(ApiEndpoints.fineDetail(fineId));
  }

  /// POST /api/fines/{fineId}/pay
  Future<Response<Object?>> payFine(
    String fineId,
    Map<String, dynamic> body,
  ) {
    return _dioClient.post<Object?>(
      ApiEndpoints.finePayment(fineId),
      data: body,
    );
  }
}
