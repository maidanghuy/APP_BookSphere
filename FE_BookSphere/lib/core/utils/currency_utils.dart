import 'package:intl/intl.dart';

class CurrencyUtils {
  const CurrencyUtils._();

  static final _vndFormatter = NumberFormat('#,##0', 'vi_VN');

  /// Formats a number as VND, e.g. 15000 → "15.000 ₫"
  static String formatVND(num amount) {
    return '${_vndFormatter.format(amount)} ₫';
  }
}
