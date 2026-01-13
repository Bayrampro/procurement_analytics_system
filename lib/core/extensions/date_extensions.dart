import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toFormattedString() {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  String toMonthYearString() {
    return DateFormat('MM.yyyy').format(this);
  }
}
