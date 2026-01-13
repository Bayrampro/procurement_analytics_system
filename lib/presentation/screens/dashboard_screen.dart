import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../core/extensions/price_extensions.dart';
import '../widgets/stat_card.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/desktop_container.dart';
import 'procurements_list_screen.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repository = ServiceLocator().procurementRepository;
  int _totalCount = 0;
  double _totalSum = 0.0;
  Map<String, int> _platformsData = {};
  Map<String, int> _statusesData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final all = await _repository.getAllProcurements();
      final totalSum = await _repository.getTotalSum();
      final platformsData = await _repository.getProcurementsCountByPlatform();
      final statusesData = await _repository.getProcurementsCountByStatus();

      if (mounted) {
        setState(() {
          _totalCount = all.length;
          _totalSum = totalSum;
          _platformsData = platformsData;
          _statusesData = statusesData;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          child: DesktopContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Статистические карточки
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Всего закупок',
                        value: _totalCount.toString(),
                        icon: Icons.shopping_cart,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: StatCard(
                        title: 'Общая сумма',
                        value: _totalSum.toFormattedPrice(),
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Графики в две колонки
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: BarChartWidget(
                        data: _platformsData,
                        title: 'Закупки по торговым площадкам',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: PieChartWidget(
                        data: _statusesData,
                        title: 'Распределение по статусам',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Быстрые действия
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Быстрые действия',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProcurementsListScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.list, size: 20),
                                label: const Text('Список закупок'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AnalyticsScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.analytics, size: 20),
                                label: const Text('Аналитика'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
