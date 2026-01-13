import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/service_locator.dart';
import '../../domain/entities/procurement.dart';
import '../../core/extensions/date_extensions.dart';
import '../../core/extensions/price_extensions.dart';
import '../widgets/procurement_form_dialog.dart';
import '../widgets/filter_dialog.dart';
import 'analytics_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _selectedIndex = 0;
  final _homeKey = GlobalKey<_HomeWithListScreenState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final navRail = NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelType: NavigationRailLabelType.all,
          backgroundColor: Colors.white,
          selectedIconTheme: const IconThemeData(
            color: Color(0xFF6366F1),
            size: 28,
          ),
          selectedLabelTextStyle: const TextStyle(
            color: Color(0xFF6366F1),
            fontWeight: FontWeight.w600,
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey.shade600,
            size: 24,
          ),
          unselectedLabelTextStyle: TextStyle(
            color: Colors.grey.shade600,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: Image.asset(
              'assets/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: Text('Главная'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: Text('Аналитика'),
            ),
          ],
        );

        Widget content;
        switch (_selectedIndex) {
          case 1:
            content = const AnalyticsScreen();
          default:
            content = _HomeWithListScreen(key: _homeKey);
        }

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                navRail,
                Container(
                  width: 1,
                  color: Colors.grey.shade200,
                ),
                Expanded(child: content),
              ],
            ),
          );
        } else {
          // На узких экранах показываем обычный bottom navigation
          return Scaffold(
            body: content,
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Главная',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  label: 'Аналитика',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

/// Главный экран для десктопа: статистика + таблица закупок.
class _HomeWithListScreen extends StatefulWidget {
  const _HomeWithListScreen({super.key});

  @override
  State<_HomeWithListScreen> createState() => _HomeWithListScreenState();
}

class _HomeWithListScreenState extends State<_HomeWithListScreen> {
  final _repository = ServiceLocator().procurementRepository;

  bool _isLoading = true;
  List<Procurement> _all = [];
  List<Procurement> _filtered = [];
  String _search = '';

  // Фильтры
  String? _selectedPlatform;
  String? _selectedCategory;
  String? _selectedStatus;
  double? _minPrice;
  double? _maxPrice;
  DateTime? _startDate;
  DateTime? _endDate;

  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Небольшая задержка, чтобы данные успели загрузиться из CSV
    Future.delayed(const Duration(milliseconds: 500), () {
      _load();
    });
  }

  void load() {
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // Используем фильтры для загрузки данных
      final data = await _repository.getProcurementsByFilters(
        platform: _selectedPlatform,
        category: _selectedCategory,
        status: _selectedStatus,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        startDate: _startDate,
        endDate: _endDate,
      );
      if (mounted) {
        setState(() {
          _all = data;
          _applyFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyFilter() {
    if (_search.isEmpty) {
      _filtered = _all;
    } else {
      final q = _search.toLowerCase();
      _filtered = _all.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.customer.toLowerCase().contains(q) ||
            p.platform.toLowerCase().contains(q);
      }).toList();
    }
  }

  Future<void> _showFilters() async {
    // Получаем уникальные категории из всех закупок
    final allProcurements = await _repository.getAllProcurements();
    final categories = allProcurements.map((p) => p.category).toSet().toList();
    
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
      _load();
    }
  }

  void _clearFilter(String filterType) {
    setState(() {
      switch (filterType) {
        case 'platform':
          _selectedPlatform = null;
          break;
        case 'category':
          _selectedCategory = null;
          break;
        case 'status':
          _selectedStatus = null;
          break;
        case 'price':
          _minPrice = null;
          _maxPrice = null;
          break;
        case 'date':
          _startDate = null;
          _endDate = null;
          break;
        case 'all':
          _selectedPlatform = null;
          _selectedCategory = null;
          _selectedStatus = null;
          _minPrice = null;
          _maxPrice = null;
          _startDate = null;
          _endDate = null;
          break;
      }
    });
    _load();
  }

  bool get _hasActiveFilters {
    return _selectedPlatform != null ||
        _selectedCategory != null ||
        _selectedStatus != null ||
        _minPrice != null ||
        _maxPrice != null ||
        _startDate != null ||
        _endDate != null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _rowsPerPage = width > 1400 ? 12 : 8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Фильтры',
          ),
          IconButton(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const ProcurementFormDialog(),
              );
              if (result == true) {
                _load();
              }
            },
            icon: const Icon(Icons.add),
            tooltip: 'Создать закупку',
          ),
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF8FAFC),
              const Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поиск
              TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск по названию, заказчику, площадке...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _search = value;
                    _applyFilter();
                  });
                },
              ),
              // Активные фильтры
              if (_hasActiveFilters) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_selectedPlatform != null)
                      Chip(
                        label: Text('Площадка: $_selectedPlatform'),
                        onDeleted: () => _clearFilter('platform'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (_selectedCategory != null)
                      Chip(
                        label: Text('Категория: $_selectedCategory'),
                        onDeleted: () => _clearFilter('category'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (_selectedStatus != null)
                      Chip(
                        label: Text('Статус: $_selectedStatus'),
                        onDeleted: () => _clearFilter('status'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (_minPrice != null || _maxPrice != null)
                      Chip(
                        label: Text(
                          'Цена: ${_minPrice != null ? _minPrice!.toStringAsFixed(0) : '0'} - ${_maxPrice != null ? _maxPrice!.toStringAsFixed(0) : '∞'}',
                        ),
                        onDeleted: () => _clearFilter('price'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (_startDate != null || _endDate != null)
                      Chip(
                        label: Text(
                          'Дата: ${_startDate != null ? _startDate!.toFormattedString() : '...'} - ${_endDate != null ? _endDate!.toFormattedString() : '...'}',
                        ),
                        onDeleted: () => _clearFilter('date'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    TextButton.icon(
                      onPressed: () => _clearFilter('all'),
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Сбросить все'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      ),
                    )
                  : _filtered.isEmpty
                      ? Center(
                          child: Text(
                            'Нет данных для отображения',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        )
                      : _buildTable(context),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: const Text('Список закупок'),
        rowsPerPage: _rowsPerPage,
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Площадка')),
          DataColumn(label: Text('Заказчик')),
          DataColumn(label: Text('Предмет')),
          DataColumn(label: Text('Категория')),
          DataColumn(label: Text('Статус')),
          DataColumn(label: Text('Цена')),
          DataColumn(label: Text('Дата')),
          DataColumn(label: Text('Действия')),
        ],
        source: _ProcurementsDataSource(
          _filtered,
          onEdit: (procurement) async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => ProcurementFormDialog(procurement: procurement),
            );
            if (result == true) {
              _load();
            }
          },
          onDelete: (procurement) async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Подтверждение удаления'),
                content: Text(
                  'Вы уверены, что хотите удалить закупку "${procurement.title}"?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Отмена'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Удалить'),
                  ),
                ],
              ),
            );
            if (confirmed == true && procurement.id != null) {
              try {
                await _repository.deleteProcurement(procurement.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Закупка успешно удалена'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _load();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка удаления: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}

class _ProcurementsDataSource extends DataTableSource {
  final List<Procurement> _data;
  final Function(Procurement) onEdit;
  final Function(Procurement) onDelete;

  _ProcurementsDataSource(
    this._data, {
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final p = _data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(p.id?.toString() ?? '')),
        DataCell(Text(p.platform)),
        DataCell(Text(p.customer)),
        DataCell(Text(p.title)),
        DataCell(Text(p.category)),
        DataCell(Text(p.status)),
        DataCell(Text(p.price.toFormattedPrice())),
        DataCell(Text(p.publishedDate.toFormattedString())),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: const Color(0xFF6366F1),
                onPressed: () => onEdit(p),
                tooltip: 'Редактировать',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: Colors.red,
                onPressed: () => onDelete(p),
                tooltip: 'Удалить',
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

