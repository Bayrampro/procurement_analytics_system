import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, int> data;
  final String title;

  const BarChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

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
    final maxValue = data.values.reduce((a, b) => a > b ? a : b);
    // Улучшаем масштабирование - округляем до ближайшего целого сверху
    final roundedMax = (maxValue * 1.2).ceil().toDouble();
    final adjustedMax = roundedMax < maxValue + 1 ? maxValue + 1.0 : roundedMax;

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
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: 280,
                  width: constraints.maxWidth > 0 ? constraints.maxWidth : double.infinity,
                  child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: adjustedMax,
                  minY: 0,
                  groupsSpace: 12,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      tooltipBgColor: const Color(0xFF6366F1),
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toInt().toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < entries.length) {
                            final label = entries[index].key;
                            // Сокращаем длинные названия более агрессивно
                            String displayLabel = label;
                            if (label.length > 10) {
                              final words = label.split(' ');
                              if (words.length >= 2) {
                                // Берем только первое слово для длинных названий
                                displayLabel = words[0];
                                if (displayLabel.length > 10) {
                                  displayLabel = '${displayLabel.substring(0, 8)}...';
                                }
                              } else {
                                displayLabel = label.length > 10 
                                    ? '${label.substring(0, 8)}...' 
                                    : label;
                              }
                            }
                            
                            // Поворачиваем текст под углом для экономии места
                            return Transform.rotate(
                              angle: -0.6, // Около -35 градусов
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 80,
                                padding: const EdgeInsets.only(top: 16.0, right: 4),
                                child: Text(
                                  displayLabel,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 120,
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      left: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  barGroups: entries.asMap().entries.map((entry) {
                    final index = entry.key;
                    final dataEntry = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: dataEntry.value.toDouble(),
                          color: _getColorForIndex(index),
                          width: 32,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: adjustedMax,
                            color: Colors.grey.shade100,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF6366F1), // Индиго
      const Color(0xFF10B981), // Зеленый
      const Color(0xFFF59E0B), // Оранжевый
      const Color(0xFF8B5CF6), // Фиолетовый
      const Color(0xFFEF4444), // Красный
      const Color(0xFF06B6D4), // Циан
      const Color(0xFFEC4899), // Розовый
      const Color(0xFF84CC16), // Лайм
    ];
    return colors[index % colors.length];
  }
}
