import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import '../../domain/entities/procurement.dart';

class CsvImporter {
  /// Импорт из локального файла (выбор пользователем)
  static Future<List<Procurement>> importFromFile(File file) async {
    final input = file.openRead();
    final csvString = await input.transform(const Utf8Decoder()).join();
    return importFromString(csvString);
  }

  /// Импорт из строки CSV (подходит для ассетов)
  static Future<List<Procurement>> importFromString(String csvContent) async {
    try {
      // Убираем BOM и лишние пробелы
      csvContent = csvContent.trim();
      if (csvContent.isEmpty) {
        throw Exception('CSV файл пуст');
      }

      // Нормализуем окончания строк
      csvContent = csvContent.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

      final fields = const CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
      ).convert(csvContent);

      if (fields.isEmpty) {
        throw Exception('CSV файл пуст после парсинга');
      }

      // Пропускаем заголовок и фильтруем пустые строки
      final dataRows = fields
          .skip(1)
          .where(
            (row) =>
                row.isNotEmpty &&
                row.any((cell) => cell.toString().trim().isNotEmpty),
          )
          .toList();

      final procurements = <Procurement>[];

      if (dataRows.isEmpty) {
        throw Exception(
          'Нет данных после пропуска заголовка. Всего строк: ${fields.length}',
        );
      }

      for (var row in dataRows) {
        // Проверяем, что строка содержит достаточно данных
        final nonEmptyCells = row
            .where((cell) => cell.toString().trim().isNotEmpty)
            .toList();
        if (nonEmptyCells.length < 8) {
          continue; // Пропускаем некорректные строки
        }

        try {
          final id = int.tryParse(row[0].toString());
          final platform = row[1].toString().trim();
          final customer = row[2].toString().trim();
          final title = row[3].toString().trim();
          final category = row[4].toString().trim();
          final price =
              double.tryParse(row[5].toString().replaceAll(' ', '')) ?? 0.0;
          final dateStr = row[6].toString().trim();
          final status = row[7].toString().trim();
          final region = row.length > 8 ? row[8].toString().trim() : '';

          if (platform.isEmpty || customer.isEmpty || title.isEmpty) {
            continue; // Пропускаем некорректные записи
          }

          // Парсим дату
          DateTime publishedDate;
          try {
            final dateParts = dateStr.split('-');
            if (dateParts.length == 3) {
              publishedDate = DateTime(
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
                int.parse(dateParts[2]),
              );
            } else {
              publishedDate = DateTime.now();
            }
          } catch (e) {
            publishedDate = DateTime.now();
          }

          procurements.add(
            Procurement(
              id: id,
              platform: platform,
              customer: customer,
              title: title,
              category: category,
              price: price,
              publishedDate: publishedDate,
              status: status,
              region: region,
            ),
          );
        } catch (e) {
          // Пропускаем некорректные строки
          continue;
        }
      }

      return procurements;
    } catch (e) {
      throw Exception('Ошибка при импорте CSV: $e');
    }
  }
}
