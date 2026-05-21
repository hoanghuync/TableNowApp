import 'package:intl/intl.dart';

class MoneyFormatter {
  static final _vnd = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
  static String vnd(double value) => _vnd.format(value);
}
