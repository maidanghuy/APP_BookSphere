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
  });

  final String bookId;
  final String title;
  final String? author;
  final String? coverUrl;
  final int availableCopies;

  bool get isAvailable => availableCopies > 0;

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
