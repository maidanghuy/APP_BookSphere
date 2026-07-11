int _parseInt(dynamic value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

bool _parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    return value.toLowerCase() == 'true';
  }
  if (value is num) {
    return value.toInt() != 0;
  }
  return false;
}

class BookDetailResponse {
  final int id;
  final String title;
  final String author;
  final String? isbn;
  final int totalQuantity;
  final int availableQuantity;
  final String? description;
  final bool isActive;

  BookDetailResponse({
    required this.id,
    required this.title,
    required this.author,
    this.isbn,
    required this.totalQuantity,
    required this.availableQuantity,
    this.description,
    required this.isActive,
  });

  factory BookDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookDetailResponse(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      isbn: json['isbn']?.toString(),
      totalQuantity: _parseInt(json['totalQuantity']),
      availableQuantity: _parseInt(json['availableQuantity']),
      description: json['description']?.toString(),
      isActive: _parseBool(json['isActive'] ?? json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'totalQuantity': totalQuantity,
      'availableQuantity': availableQuantity,
      'description': description,
      'isActive': isActive,
    };
  }
}
