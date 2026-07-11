enum BorrowStatus {
  borrowing,
  overdue,
  returned,
  cancelled;

  String get value => name.toUpperCase();

  static BorrowStatus fromValue(String value) {
    return BorrowStatus.values.firstWhere(
      (element) => element.value == value.toUpperCase(),
      orElse: () => BorrowStatus.borrowing,
    );
  }
}
