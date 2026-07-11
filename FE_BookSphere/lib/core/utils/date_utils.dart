class AppDateUtils {
  const AppDateUtils._();

  /// Parses ISO 8601 string or LocalDateTime string (e.g. "2026-07-24T10:30:00")
  /// and returns formatted dd/MM/yyyy HH:mm. Returns '--' if null or invalid.
  static String formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '--';
    try {
      final dt = DateTime.parse(raw);
      final local = dt.toLocal();
      final d = local.day.toString().padLeft(2, '0');
      final m = local.month.toString().padLeft(2, '0');
      final y = local.year;
      final h = local.hour.toString().padLeft(2, '0');
      final min = local.minute.toString().padLeft(2, '0');
      return '$d/$m/$y $h:$min';
    } on Object {
      return '--';
    }
  }

  /// Returns only the date part: dd/MM/yyyy
  static String formatDateOnly(String? raw) {
    if (raw == null || raw.isEmpty) return '--';
    try {
      final dt = DateTime.parse(raw);
      final local = dt.toLocal();
      final d = local.day.toString().padLeft(2, '0');
      final m = local.month.toString().padLeft(2, '0');
      return '$d/${m}/${local.year}';
    } on Object {
      return '--';
    }
  }
}
