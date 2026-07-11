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

/// Book detail mapped from backend `BookDetailResponse`.
///
/// Fields: id, title, author, isbn, publisher, publishedYear, categoryId,
/// categoryName, totalQuantity, availableQuantity, description, isActive,
/// createdAt, updatedAt.
/// Cover URL and language are not provided by the current Book Service.
class BookDetail {
  const BookDetail({
    required this.id,
    required this.title,
    this.author,
    this.isbn,
    this.publisher,
    this.publishedYear,
    this.categoryId,
    this.categoryName,
    this.totalQuantity,
    this.availableQuantity,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String? author;
  final String? isbn;
  final String? publisher;
  final int? publishedYear;
  final String? categoryId;
  final String? categoryName;
  final int? totalQuantity;
  final int? availableQuantity;
  final String? description;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  bool get isAvailable => (availableQuantity ?? 0) > 0;

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    final title = json['title']?.toString().trim();
    return BookDetail(
      id: _idToString(json['id']),
      title: (title == null || title.isEmpty) ? '' : title,
      author: json['author']?.toString(),
      isbn: json['isbn']?.toString(),
      publisher: json['publisher']?.toString(),
      publishedYear: _parseNullableInt(json['publishedYear']),
      categoryId: json['categoryId'] == null
          ? null
          : _idToString(json['categoryId']),
      categoryName: json['categoryName']?.toString(),
      totalQuantity: _parseNullableInt(json['totalQuantity']),
      availableQuantity: _parseNullableInt(json['availableQuantity']),
      description: json['description']?.toString(),
      isActive: _parseNullableBool(json['isActive'] ?? json['active']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'publisher': publisher,
      'publishedYear': publishedYear,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'totalQuantity': totalQuantity,
      'availableQuantity': availableQuantity,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
