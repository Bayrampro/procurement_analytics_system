class AppConstants {
  static const String appName = 'Анализ торговых площадок';
  static const String databaseName = 'procurements.db';
  
  // Максимальная ширина контента для десктопа
  static const double maxContentWidth = 1400.0;
  static const double desktopPadding = 32.0;
  static const double cardSpacing = 24.0;
  
  // Статусы закупок
  static const List<String> statuses = [
    'Объявлена',
    'Завершена',
    'Отменена',
  ];
  
  // Торговые площадки
  static const List<String> platforms = [
    'ЕИС',
    'РТС-Тендер',
    'СберАСТ',
    'Фабрикант',
  ];
}
