/// Navigation args for Book Detail Add / Edit borrow-cart modes.
enum BookDetailMode { add, edit }

class BookDetailRouteArgs {
  const BookDetailRouteArgs({
    this.mode = BookDetailMode.add,
    this.initialQuantity,
  });

  final BookDetailMode mode;
  final int? initialQuantity;
}
