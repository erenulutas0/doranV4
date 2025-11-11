import 'package:intl/intl.dart';

class PriceFormatter {
  static String format(double price) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  static String formatWithoutSymbol(double price) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(price);
  }
}

