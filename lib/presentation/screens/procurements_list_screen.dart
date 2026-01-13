import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/procurement.dart';
import '../../core/extensions/price_extensions.dart';
import '../../core/extensions/date_extensions.dart';
import '../widgets/filter_dialog.dart';
import '../widgets/desktop_container.dart';
import 'procurement_details_screen.dart';

class ProcurementsListScreen extends StatefulWidget {
  const ProcurementsListScreen({super.key});

  @override
  State<ProcurementsListScreen> createState() => _ProcurementsListScreenState();
}

class _ProcurementsListScreenState extends State<ProcurementsListScreen> {
  final _repository = ServiceLocator().procurementRepository;
  List<Procurement> _procurements = [];
  List<Procurement> _filteredProcurements = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Фильтры
  String? _selectedPlatform;
  String? _selectedCategory;
  String? _selectedStatus;
  double? _minPrice;
  double? _maxPrice;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadProcurements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProcurements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final procurements = await _repository.getProcurementsByFilters(
        platform: _selectedPlatform,
        category: _selectedCategory,
        status: _selectedStatus,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        startDate: _startDate,
        endDate: _endDate,
      );
      setState(() {
        _procurements = procurements;
        _applySearch();
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

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredProcurements = _procurements;
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredProcurements = _procurements.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.customer.toLowerCase().contains(query) ||
            p.platform.toLowerCase().contains(query);
      }).toList();
    }
    setState(() {});
  }

  Future<void> _showFilters() async {
    final categories = _procurements.map((p) => p.category).toSet().toList();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(
        selectedPlatform: _selectedPlatform,
        selectedCategory: _selectedCategory,
        selectedStatus: _selectedStatus,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        startDate: _startDate,
        endDate: _endDate,
        availableCategories: categories,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPlatform = result['platform'];
        _selectedCategory = result['category'];
        _selectedStatus = result['status'];
        _minPrice = result['minPrice'];
        _maxPrice = result['maxPrice'];
        _startDate = result['startDate'];
        _endDate = result['endDate'];
      });
      _loadProcurements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список закупок'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
            tooltip: 'Фильтры',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProcurements,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          DesktopContainer(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по названию, заказчику, площадке...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchQuery = '';
                          _applySearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applySearch();
              },
            ),
          ),
          // Список
          Expanded(
            child: DesktopContainer(
              padding: EdgeInsets.zero,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProcurements.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Закупки не найдены',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredProcurements.length,
                          itemBuilder: (context, index) {
                            final procurement = _filteredProcurements[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(
                                  procurement.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('Заказчик: ${procurement.customer}'),
                                    Text('Площадка: ${procurement.platform}'),
                                    Text('Категория: ${procurement.category}'),
                                    Text('Статус: ${procurement.status}'),
                                    Text('Цена: ${procurement.price.toFormattedPrice()}'),
                                    Text(
                                      'Дата: ${procurement.publishedDate.toFormattedString()}',
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProcurementDetailsScreen(
                                        procurement: procurement,
                                      ),
                                    ),
                                  );
                                  // Обновляем список, если закупка была удалена или изменена
                                  if (result == true) {
                                    _loadProcurements();
                                  }
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
