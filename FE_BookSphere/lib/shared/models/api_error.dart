class ApiError {
  final String? field;
  final String? code;
  final String message;

  const ApiError({this.field, this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      field: json['field']?.toString(),
      code: json['code']?.toString(),
      message: json['message']?.toString() ?? 'Unknown error',
    );
  }
}
