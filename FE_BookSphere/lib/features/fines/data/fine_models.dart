/// Maps to backend FineResponse DTO.
/// Backend fields: id, userId, borrowId, amount (BigDecimal), createdFrom,
/// reason, status, createdAt (LocalDateTime), paidAt (LocalDateTime)
class FineResponse {
  final int id;
  final int borrowId;
  final int userId;
  final double amount;
  final String reason;
  final String status;
  final String? createdFrom;
  final String? createdAt;
  final String? paidAt;

  FineResponse({
    required this.id,
    required this.borrowId,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.status,
    this.createdFrom,
    this.createdAt,
    this.paidAt,
  });

  factory FineResponse.fromJson(Map<String, dynamic> json) {
    return FineResponse(
      id: (json['id'] as num).toInt(),
      borrowId: (json['borrowId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdFrom: json['createdFrom'] as String?,
      createdAt: json['createdAt']?.toString(),
      paidAt: json['paidAt']?.toString(),
    );
  }
}

/// Maps to backend FinePaymentRequest DTO.
class PayFineRequest {
  final String paymentMethod;
  final String paymentStatus;
  final double? amount;

  PayFineRequest({
    required this.paymentMethod,
    required this.paymentStatus,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      if (amount != null) 'amount': amount,
    };
  }
}

/// Maps to backend FinePaymentResponse DTO.
class FinePaymentResponse {
  final int id;
  final int fineId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final String? paidAt;

  FinePaymentResponse({
    required this.id,
    required this.fineId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paidAt,
  });

  factory FinePaymentResponse.fromJson(Map<String, dynamic> json) {
    return FinePaymentResponse(
      id: (json['id'] as num).toInt(),
      fineId: (json['fineId'] as num).toInt(),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      paidAt: json['paidAt']?.toString(),
    );
  }
}

/// Paged response wrapper matching backend PageResponse<T>.
class PageResult<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalPages;
  final int totalElements;

  PageResult({
    required this.content,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.totalElements,
  });
}
