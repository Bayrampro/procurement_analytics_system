import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/date_extensions.dart';

class FilterDialog extends StatefulWidget {
  final String? selectedPlatform;
  final String? selectedCategory;
  final String? selectedStatus;
  final double? minPrice;
  final double? maxPrice;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> availableCategories;

  const FilterDialog({
    super.key,
    this.selectedPlatform,
    this.selectedCategory,
    this.selectedStatus,
    this.minPrice,
    this.maxPrice,
    this.startDate,
    this.endDate,
    required this.availableCategories,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String? _selectedPlatform;
  late String? _selectedCategory;
  late String? _selectedStatus;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedPlatform = widget.selectedPlatform;
    _selectedCategory = widget.selectedCategory;
    _selectedStatus = widget.selectedStatus;
    _minPriceController = TextEditingController(
      text: widget.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.maxPrice?.toString() ?? '',
    );
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Фильтры'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Платформа
            DropdownButtonFormField<String>(
              value: _selectedPlatform,
              decoration: const InputDecoration(
                labelText: 'Торговая площадка',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Все'),
                ),
                ...AppConstants.platforms.map((platform) {
                  return DropdownMenuItem<String>(
                    value: platform,
                    child: Text(platform),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPlatform = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Категория
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Все'),
                ),
                ...widget.availableCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Статус
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Статус',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Все'),
                ),
                ...AppConstants.statuses.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Цена
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Мин. цена',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Макс. цена',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Даты
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(
                      _startDate != null
                          ? 'С: ${_startDate!.toFormattedString()}'
                          : 'Начальная дата',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(
                      _endDate != null
                          ? 'По: ${_endDate!.toFormattedString()}'
                          : 'Конечная дата',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedPlatform = null;
              _selectedCategory = null;
              _selectedStatus = null;
              _minPriceController.clear();
              _maxPriceController.clear();
              _startDate = null;
              _endDate = null;
            });
          },
          child: const Text('Сбросить'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'platform': _selectedPlatform,
              'category': _selectedCategory,
              'status': _selectedStatus,
              'minPrice': _minPriceController.text.isNotEmpty
                  ? double.tryParse(_minPriceController.text)
                  : null,
              'maxPrice': _maxPriceController.text.isNotEmpty
                  ? double.tryParse(_maxPriceController.text)
                  : null,
              'startDate': _startDate,
              'endDate': _endDate,
            });
          },
          child: const Text('Применить'),
        ),
      ],
    );
  }
}
