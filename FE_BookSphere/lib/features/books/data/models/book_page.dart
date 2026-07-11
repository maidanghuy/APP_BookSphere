import 'package:booksphere_app/features/books/data/models/book_summary.dart';

int _parseInt(Object? value, {int fallback = 0}) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

/// Paginated book list mapped from backend `PageResponse<BookResponse>`.
///
/// Backend shape under `data`:
/// `{ content, page, size, totalElements, totalPages }`
class BookPage {
  const BookPage({
    required this.items,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.totalElements,
  });

  final List<BookSummary> items;
  final int page;
  final int size;
  final int totalPages;
  final int totalElements;

  bool get isLast {
    if (totalPages <= 0) {
      return true;
    }
    return page >= totalPages - 1;
  }

  bool get hasMore => !isLast;

  factory BookPage.fromJson(Map<String, dynamic> json) {
    final rawContent = json['content'];
    final items = <BookSummary>[];
    if (rawContent is List) {
      for (final item in rawContent) {
        if (item is Map) {
          items.add(BookSummary.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return BookPage(
      items: items,
      page: _parseInt(json['page']),
      size: _parseInt(json['size'], fallback: 10),
      totalPages: _parseInt(json['totalPages']),
      totalElements: _parseInt(json['totalElements']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': items.map((item) => item.toJson()).toList(),
      'page': page,
      'size': size,
      'totalPages': totalPages,
      'totalElements': totalElements,
    };
  }
}
