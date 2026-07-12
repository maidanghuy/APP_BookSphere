class ApiEndpoints {
  const ApiEndpoints._();

  static const String authBase = '/api/auth';
  static const String login = '$authBase/login';
  static const String register = '$authBase/register';
  static const String refresh = '$authBase/refresh';
  static const String logout = '$authBase/logout';
  static const String me = '$authBase/me';

  static const String books = '/api/books';
  static const String categories = '/api/categories';
  static const String borrows = '/api/borrows';
  static const String fines = '/api/fines';
  static const String notifications = '/api/notifications';

  static String bookDetail(String bookId) => '$books/$bookId';

  static String borrowDetail(String borrowId) => '$borrows/$borrowId';

  static String returnBorrow(String borrowId) => '$borrows/$borrowId/return';

  static String fineDetail(String fineId) => '$fines/$fineId';

  static String finePayment(String fineId) => '$fines/$fineId/pay';
}
