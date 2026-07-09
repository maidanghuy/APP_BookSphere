import 'package:booksphere_app/shared/models/api_error.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<ApiError>? errors;
  final String? timestamp;
  final String? path;
  final int? status;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.timestamp,
    this.path,
    this.status,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    final errors = json['errors'];

    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      errors: errors is List
          ? errors
                .whereType<Map>()
                .map(
                  (error) =>
                      ApiError.fromJson(Map<String, dynamic>.from(error)),
                )
                .toList()
          : null,
      timestamp: json['timestamp']?.toString(),
      path: json['path']?.toString(),
      status: json['status'] is int ? json['status'] as int : null,
    );
  }
}
