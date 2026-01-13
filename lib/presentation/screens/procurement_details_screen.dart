import 'package:flutter/material.dart';
import '../../domain/entities/procurement.dart';
import '../../core/extensions/price_extensions.dart';
import '../../core/extensions/date_extensions.dart';
import '../../core/di/service_locator.dart';
import '../widgets/desktop_container.dart';
import '../widgets/procurement_form_dialog.dart';

class ProcurementDetailsScreen extends StatefulWidget {
  final Procurement procurement;

  const ProcurementDetailsScreen({
    super.key,
    required this.procurement,
  });

  @override
  State<ProcurementDetailsScreen> createState() => _ProcurementDetailsScreenState();
}

class _ProcurementDetailsScreenState extends State<ProcurementDetailsScreen> {
  late Procurement _procurement;
  final _repository = ServiceLocator().procurementRepository;

  @override
  void initState() {
    super.initState();
    _procurement = widget.procurement;
  }

  Future<void> _editProcurement() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProcurementFormDialog(procurement: _procurement),
    );
    if (result == true) {
      // Обновляем данные закупки
      if (_procurement.id != null) {
        final updated = await _repository.getProcurementById(_procurement.id!);
        if (updated != null && mounted) {
          setState(() {
            _procurement = updated;
          });
        }
      }
    }
  }

  Future<void> _deleteProcurement() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text(
          'Вы уверены, что хотите удалить закупку "${_procurement.title}"?',
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
    if (confirmed == true && _procurement.id != null) {
      try {
        await _repository.deleteProcurement(_procurement.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Закупка успешно удалена'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true); // Возвращаемся назад с флагом обновления
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка удаления: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали закупки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProcurement,
            tooltip: 'Редактировать',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProcurement,
            tooltip: 'Удалить',
            color: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: DesktopContainer(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _procurement.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  _buildDetailRow('ID', _procurement.id?.toString() ?? 'N/A'),
                  _buildDetailRow('Торговая площадка', _procurement.platform),
                  _buildDetailRow('Заказчик', _procurement.customer),
                  _buildDetailRow('Категория', _procurement.category),
                  _buildDetailRow(
                    'Стоимость',
                    _procurement.price.toFormattedPrice(),
                  ),
                  _buildDetailRow(
                    'Дата публикации',
                    _procurement.publishedDate.toFormattedString(),
                  ),
                  _buildDetailRow('Статус', _procurement.status),
                  _buildDetailRow('Регион', _procurement.region),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
