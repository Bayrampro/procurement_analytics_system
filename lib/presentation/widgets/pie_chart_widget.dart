import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, int> data;
  final String title;

  const PieChartWidget({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Нет данных для отображения',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final entries = data.entries.toList();
    final total = data.values.reduce((a, b) => a + b);

    final modernColors = [
      const Color(0xFF6366F1), // Индиго
      const Color(0xFF10B981), // Зеленый
      const Color(0xFFF59E0B), // Оранжевый
      const Color(0xFF8B5CF6), // Фиолетовый
      const Color(0xFFEF4444), // Красный
      const Color(0xFF06B6D4), // Циан
      const Color(0xFFEC4899), // Розовый
      const Color(0xFF84CC16), // Лайм
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
            ),
            const SizedBox(height: 20),
            Builder(
              builder: (context) {
                // Используем MediaQuery для определения ширины экрана
                final screenWidth = MediaQuery.of(context).size.width;
                // Увеличиваем размер для широких экранов
                final chartSize = screenWidth > 1200 ? 280.0 :
                                 screenWidth > 800 ? 240.0 : 
                                 screenWidth > 600 ? 200.0 : 160.0;
                return Row(
                  children: [
                    SizedBox(
                      width: chartSize,
                      height: chartSize,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: chartSize > 240 ? 65 : chartSize > 200 ? 55 : 45,
                          sections: entries.asMap().entries.map((entry) {
                            final index = entry.key;
                            final dataEntry = entry.value;
                            final percentage = (dataEntry.value / total * 100);
                            return PieChartSectionData(
                              value: dataEntry.value.toDouble(),
                              title: '${percentage.toStringAsFixed(1)}%',
                              color: modernColors[index % modernColors.length],
                              radius: chartSize > 240 ? 75 : chartSize > 200 ? 65 : 55,
                              titleStyle: TextStyle(
                                fontSize: chartSize > 240 ? 11 : chartSize > 200 ? 10 : 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: entries.asMap().entries.map((entry) {
                          final index = entry.key;
                          final dataEntry = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: modernColors[index % modernColors.length],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    dataEntry.key,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
