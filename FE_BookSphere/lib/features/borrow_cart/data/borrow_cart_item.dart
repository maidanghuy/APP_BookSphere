import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';

/// Temporary borrow-list item kept only in Flutter memory (no borrow API).
class BorrowCartItem {
  const BorrowCartItem({
    required this.bookId,
    required this.title,
    this.author,
    this.coverUrl,
    required this.availableCopies,
    this.quantity = 1,
  });

  final String bookId;
  final String title;
  final String? author;
  final String? coverUrl;
  final int availableCopies;
  final int quantity;

  bool get isAvailable => availableCopies > 0;

  BorrowCartItem copyWith({
    String? bookId,
    String? title,
    String? author,
    String? coverUrl,
    int? availableCopies,
    int? quantity,
  }) {
    return BorrowCartItem(
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      availableCopies: availableCopies ?? this.availableCopies,
      quantity: quantity ?? this.quantity,
    );
  }

  factory BorrowCartItem.fromBookSummary(BookSummary book) {
    return BorrowCartItem(
      bookId: book.id,
      title: book.title,
      author: book.author,
      availableCopies: book.availableQuantity ?? 0,
    );
  }

  factory BorrowCartItem.fromBookDetail(BookDetail book) {
    return BorrowCartItem(
      bookId: book.id,
      title: book.title,
      author: book.author,
      availableCopies: book.availableQuantity ?? 0,
    );
  }
}
