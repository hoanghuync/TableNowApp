import 'package:intl/intl.dart';

class MoneyUtils {
  static final NumberFormat _formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '?', decimalDigits: 0);

  static String format(double amount) => _formatter.format(amount);
}
