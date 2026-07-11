import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';

/// Temporary borrow-list item kept only in Flutter memory (no borrow API).
class BorrowCartItem {
  const BorrowCartItem({
    required this.bookId,
    required this.title,
    this.author,
    this.coverUrl,
    required this.quantity,
    required this.availableCopies,
  });

  final String bookId;
  final String title;
  final String? author;
  final String? coverUrl;
  final int quantity;
  final int availableCopies;

  bool get isAvailable => availableCopies > 0;

  BorrowCartItem copyWith({
    String? bookId,
    String? title,
    String? author,
    String? coverUrl,
    int? quantity,
    int? availableCopies,
  }) {
    return BorrowCartItem(
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      quantity: quantity ?? this.quantity,
      availableCopies: availableCopies ?? this.availableCopies,
    );
  }

  factory BorrowCartItem.fromBookSummary(BookSummary book, {int quantity = 1}) {
    return BorrowCartItem(
      bookId: book.id,
      title: book.title,
      author: book.author,
      quantity: quantity,
      availableCopies: book.availableQuantity ?? 0,
    );
  }

  factory BorrowCartItem.fromBookDetail(BookDetail book, {int quantity = 1}) {
    return BorrowCartItem(
      bookId: book.id,
      title: book.title,
      author: book.author,
      quantity: quantity,
      availableCopies: book.availableQuantity ?? 0,
    );
  }
}
