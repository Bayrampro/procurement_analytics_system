import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/desktop_container.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _repository = ServiceLocator().procurementRepository;
  Map<String, int> _platformsData = {};
  Map<String, int> _statusesData = {};
  Map<String, int> _categoriesData = {};
  Map<DateTime, int> _datesData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final platformsData = await _repository.getProcurementsCountByPlatform();
      final statusesData = await _repository.getProcurementsCountByStatus();
      final categoriesData = await _repository.getProcurementsCountByCategory();
      final datesData = await _repository.getProcurementsByDate();

      setState(() {
        _platformsData = platformsData;
        _statusesData = statusesData;
        _categoriesData = categoriesData;
        _datesData = datesData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 1200;
                  final isMedium = constraints.maxWidth > 800;
                  
                  return SingleChildScrollView(
                    child: DesktopContainer(
                      child: isWide
                          ? _buildWideLayout()
                          : isMedium
                              ? _buildMediumLayout()
                              : _buildNarrowLayout(),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildWideLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Первая строка - две колонки
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: BarChartWidget(
                data: _platformsData,
                title: 'Количество закупок по торговым площадкам',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: PieChartWidget(
                data: _statusesData,
                title: 'Распределение закупок по статусам',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Вторая строка - две колонки
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: BarChartWidget(
                data: _categoriesData,
                title: 'Распределение закупок по категориям',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: LineChartWidget(
                data: _datesData,
                title: 'Динамика закупок по времени',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediumLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarChartWidget(
          data: _platformsData,
          title: 'Количество закупок по торговым площадкам',
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PieChartWidget(
                data: _statusesData,
                title: 'Распределение закупок по статусам',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: BarChartWidget(
                data: _categoriesData,
                title: 'Распределение закупок по категориям',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LineChartWidget(
          data: _datesData,
          title: 'Динамика закупок по времени',
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarChartWidget(
          data: _platformsData,
          title: 'Количество закупок по торговым площадкам',
        ),
        const SizedBox(height: 24),
        PieChartWidget(
          data: _statusesData,
          title: 'Распределение закупок по статусам',
        ),
        const SizedBox(height: 24),
        BarChartWidget(
          data: _categoriesData,
          title: 'Распределение закупок по категориям',
        ),
        const SizedBox(height: 24),
        LineChartWidget(
          data: _datesData,
          title: 'Динамика закупок по времени',
        ),
      ],
    );
  }
}
