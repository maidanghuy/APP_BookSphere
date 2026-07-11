import 'package:booksphere_app/shared/enums/borrow_status.dart';

int _parseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

String _parseDate(dynamic value) {
  if (value is String) {
    return value;
  }
  if (value is List) {
    final list = List<dynamic>.from(value);
    if (list.length >= 3) {
      final year = list[0];
      final month = list[1].toString().padLeft(2, '0');
      final day = list[2].toString().padLeft(2, '0');
      if (list.length >= 6) {
        final hour = list[3].toString().padLeft(2, '0');
        final minute = list[4].toString().padLeft(2, '0');
        final second = list[5].toString().padLeft(2, '0');
        return '$year-$month-$day $hour:$minute:$second';
      }
      return '$year-$month-$day';
    }
  }
  return value?.toString() ?? '';
}

class BorrowItemRequest {
  final int bookId;
  final int quantity;

  BorrowItemRequest({required this.bookId, required this.quantity});

  factory BorrowItemRequest.fromJson(Map<String, dynamic> json) {
    return BorrowItemRequest(
      bookId: _parseInt(json['bookId']),
      quantity: _parseInt(json['quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'quantity': quantity,
    };
  }
}

class BorrowCreateRequest {
  final String dueDate; // ISO date string format
  final List<BorrowItemRequest> items;

  BorrowCreateRequest({required this.dueDate, required this.items});

  factory BorrowCreateRequest.fromJson(Map<String, dynamic> json) {
    return BorrowCreateRequest(
      dueDate: _parseDate(json['dueDate']),
      items: json['items'] is List
          ? (json['items'] as List)
              .map((e) => BorrowItemRequest.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dueDate': dueDate,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class BorrowItemResponse {
  final int id;
  final int bookId;
  final String bookTitle;
  final String bookAuthor;
  final int quantity;
  final String status;

  BorrowItemResponse({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.quantity,
    required this.status,
  });

  factory BorrowItemResponse.fromJson(Map<String, dynamic> json) {
    return BorrowItemResponse(
      id: _parseInt(json['id']),
      bookId: _parseInt(json['bookId']),
      bookTitle: json['bookTitle']?.toString() ?? '',
      bookAuthor: json['bookAuthor']?.toString() ?? '',
      quantity: _parseInt(json['quantity']),
      status: json['status']?.toString() ?? 'BORROWED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'quantity': quantity,
      'status': status,
    };
  }
}

class BorrowDetailResponse {
  final int id;
  final int userId;
  final String username;
  final String memberName;
  final int totalItems;
  final String borrowDate;
  final String dueDate;
  final String? returnDate;
  final String status;
  final List<BorrowItemResponse> items;

  BorrowDetailResponse({
    required this.id,
    required this.userId,
    required this.username,
    required this.memberName,
    required this.totalItems,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    required this.items,
  });

  BorrowStatus get borrowStatus => BorrowStatus.fromValue(status);

  factory BorrowDetailResponse.fromJson(Map<String, dynamic> json) {
    return BorrowDetailResponse(
      id: _parseInt(json['id']),
      userId: _parseInt(json['userId']),
      username: json['username']?.toString() ?? '',
      memberName: json['memberName']?.toString() ?? '',
      totalItems: _parseInt(json['totalItems']),
      borrowDate: _parseDate(json['borrowDate']),
      dueDate: _parseDate(json['dueDate']),
      returnDate: json['returnDate'] != null ? _parseDate(json['returnDate']) : null,
      status: json['status']?.toString() ?? 'BORROWING',
      items: json['items'] is List
          ? (json['items'] as List)
              .map((e) => BorrowItemResponse.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'memberName': memberName,
      'totalItems': totalItems,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'returnDate': returnDate,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class BorrowResponse {
  final int id;
  final int userId;
  final String username;
  final String memberName;
  final int totalItems;
  final String borrowDate;
  final String dueDate;
  final String? returnDate;
  final String status;

  BorrowResponse({
    required this.id,
    required this.userId,
    required this.username,
    required this.memberName,
    required this.totalItems,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
  });

  BorrowStatus get borrowStatus => BorrowStatus.fromValue(status);

  factory BorrowResponse.fromJson(Map<String, dynamic> json) {
    return BorrowResponse(
      id: _parseInt(json['id']),
      userId: _parseInt(json['userId']),
      username: json['username']?.toString() ?? '',
      memberName: json['memberName']?.toString() ?? '',
      totalItems: _parseInt(json['totalItems']),
      borrowDate: _parseDate(json['borrowDate']),
      dueDate: _parseDate(json['dueDate']),
      returnDate: json['returnDate'] != null ? _parseDate(json['returnDate']) : null,
      status: json['status']?.toString() ?? 'BORROWING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'memberName': memberName,
      'totalItems': totalItems,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'returnDate': returnDate,
      'status': status,
    };
  }
}

class BorrowPageResponse {
  final List<BorrowResponse> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  BorrowPageResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory BorrowPageResponse.fromJson(Map<String, dynamic> json) {
    return BorrowPageResponse(
      content: json['content'] is List
          ? (json['content'] as List)
              .map((e) => BorrowResponse.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
      page: _parseInt(json['page']),
      size: _parseInt(json['size']),
      totalElements: _parseInt(json['totalElements']),
      totalPages: _parseInt(json['totalPages']),
      last: json['last'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((e) => e.toJson()).toList(),
      'page': page,
      'size': size,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'last': last,
    };
  }
}

