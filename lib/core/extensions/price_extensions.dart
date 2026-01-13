import 'package:intl/intl.dart';

extension PriceExtensions on double {
  String toFormattedPrice() {
    final formatter = NumberFormat('#,###', 'ru_RU');
    return '${formatter.format(this)} ₽';
  }
}
