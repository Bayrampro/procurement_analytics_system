import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/procurement.dart';
import '../../core/di/service_locator.dart';

class ProcurementFormDialog extends StatefulWidget {
  final Procurement? procurement;

  const ProcurementFormDialog({
    super.key,
    this.procurement,
  });

  @override
  State<ProcurementFormDialog> createState() => _ProcurementFormDialogState();
}

class _ProcurementFormDialogState extends State<ProcurementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _repository = ServiceLocator().procurementRepository;

  late TextEditingController _platformController;
  late TextEditingController _customerController;
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _statusController;
  late TextEditingController _regionController;
  late DateTime _publishedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.procurement;
    _platformController = TextEditingController(text: p?.platform ?? '');
    _customerController = TextEditingController(text: p?.customer ?? '');
    _titleController = TextEditingController(text: p?.title ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _statusController = TextEditingController(text: p?.status ?? '');
    _regionController = TextEditingController(text: p?.region ?? '');
    _publishedDate = p?.publishedDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _platformController.dispose();
    _customerController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _statusController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _publishedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _publishedDate) {
      setState(() {
        _publishedDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final procurement = Procurement(
        id: widget.procurement?.id,
        platform: _platformController.text.trim(),
        customer: _customerController.text.trim(),
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        price: double.tryParse(_priceController.text.replaceAll(' ', '')) ?? 0.0,
        publishedDate: _publishedDate,
        status: _statusController.text.trim(),
        region: _regionController.text.trim(),
      );

      if (widget.procurement == null) {
        // Создание новой закупки
        await _repository.insertProcurement(procurement);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Закупка успешно создана'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Обновление существующей закупки
        await _repository.updateProcurement(procurement);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Закупка успешно обновлена'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Возвращаем true для обновления списка
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.procurement != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isEdit ? Icons.edit : Icons.add,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? 'Редактировать закупку' : 'Создать закупку',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Форма
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Площадка
                      TextFormField(
                        controller: _platformController,
                        decoration: InputDecoration(
                          labelText: 'Площадка *',
                          prefixIcon: const Icon(Icons.store),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле обязательно для заполнения';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Заказчик
                      TextFormField(
                        controller: _customerController,
                        decoration: InputDecoration(
                          labelText: 'Заказчик *',
                          prefixIcon: const Icon(Icons.business),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле обязательно для заполнения';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Предмет закупки
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Предмет закупки *',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле обязательно для заполнения';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Категория
                      TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Категория *',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле обязательно для заполнения';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Цена
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Цена *',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле обязательно для заполнения';
                          }
                          final price = double.tryParse(value.replaceAll(' ', ''));
                          if (price == null || price < 0) {
                            return 'Введите корректную цену';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Дата публикации
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Дата публикации *',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            DateFormat('dd.MM.yyyy').format(_publishedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Статус
                      TextFormField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          labelText: 'Статус *',
                          prefixIcon: const Icon(Icons.info),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Поле обязательно для заполнения';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Регион
                      TextFormField(
                        controller: _regionController,
                        decoration: InputDecoration(
                          labelText: 'Регион',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Кнопки
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('Отмена'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(isEdit ? 'Сохранить' : 'Создать'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
