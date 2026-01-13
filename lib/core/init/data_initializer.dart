import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

import '../../data/data_sources/csv_importer.dart';
import '../di/service_locator.dart';

/// Инициализация данных при первом запуске.
class DataInitializer {
  Future<void> seedIfEmpty() async {
    final repository = ServiceLocator().procurementRepository;
    final existing = await repository.getAllProcurements();
    if (existing.isNotEmpty) {
      if (kDebugMode) {
        print('Данные уже загружены: ${existing.length} записей');
      }
      return;
    }

    // Пробуем загрузить из assets
    try {
      if (kDebugMode) {
        print('Попытка загрузить данные из assets/procurements_source.csv...');
      }
      final csv = await rootBundle.loadString('assets/procurements_source.csv');
      if (kDebugMode) {
        print('Размер CSV файла: ${csv.length} символов');
        print('Первые 200 символов: ${csv.substring(0, csv.length > 200 ? 200 : csv.length)}');
      }
      final procurements = await CsvImporter.importFromString(csv);
      if (kDebugMode) {
        print('Распарсено записей: ${procurements.length}');
      }
      if (procurements.isNotEmpty) {
        await repository.insertProcurements(procurements);
        // Проверяем, что данные действительно сохранились
        final saved = await repository.getAllProcurements();
        if (kDebugMode) {
          print('✅ Загружено ${procurements.length} записей из assets');
          print('✅ Проверка: в базе данных ${saved.length} записей');
        }
        return;
      } else {
        if (kDebugMode) {
          print('⚠️ CSV файл пуст или не содержит данных после парсинга');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Ошибка загрузки из assets: $e');
      }
      
      // Пробуем альтернативный путь
      try {
        if (kDebugMode) {
          print('Попытка загрузить данные из procurements_source.csv (без префикса assets/)...');
        }
        final csv = await rootBundle.loadString('procurements_source.csv');
        final procurements = await CsvImporter.importFromString(csv);
        if (procurements.isNotEmpty) {
          await repository.insertProcurements(procurements);
          if (kDebugMode) {
            print('✅ Загружено ${procurements.length} записей');
          }
          return;
        }
      } catch (e2) {
        if (kDebugMode) {
          print('❌ Ошибка загрузки из альтернативного пути: $e2');
        }
      }
    }
  }
}

