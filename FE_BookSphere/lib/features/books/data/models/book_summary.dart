String _idToString(Object? value) {
  if (value == null) {
    return '';
  }
  return value.toString();
}

int? _parseNullableInt(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

bool? _parseNullableBool(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true') {
      return true;
    }
    if (normalized == 'false') {
      return false;
    }
  }
  if (value is num) {
    return value.toInt() != 0;
  }
  return null;
}

/// Book list item mapped from backend `BookResponse`.
///
/// Backend fields: id, title, author, isbn, categoryId, categoryName,
/// totalQuantity, availableQuantity, isActive.
/// Cover image is not provided by the current Book Service contract.
class BookSummary {
  const BookSummary({
    required this.id,
    required this.title,
    this.author,
    this.isbn,
    this.categoryId,
    this.categoryName,
    this.totalQuantity,
    this.availableQuantity,
    this.isActive,
  });

  final String id;
  final String title;
  final String? author;
  final String? isbn;
  final String? categoryId;
  final String? categoryName;
  final int? totalQuantity;
  final int? availableQuantity;
  final bool? isActive;

  bool get isAvailable => (availableQuantity ?? 0) > 0;

  factory BookSummary.fromJson(Map<String, dynamic> json) {
    final title = json['title']?.toString().trim();
    return BookSummary(
      id: _idToString(json['id']),
      title: (title == null || title.isEmpty) ? '' : title,
      author: json['author']?.toString(),
      isbn: json['isbn']?.toString(),
      categoryId: json['categoryId'] == null
          ? null
          : _idToString(json['categoryId']),
      categoryName: json['categoryName']?.toString(),
      totalQuantity: _parseNullableInt(json['totalQuantity']),
      availableQuantity: _parseNullableInt(json['availableQuantity']),
      isActive: _parseNullableBool(json['isActive'] ?? json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'totalQuantity': totalQuantity,
      'availableQuantity': availableQuantity,
      'isActive': isActive,
    };
  }
}
