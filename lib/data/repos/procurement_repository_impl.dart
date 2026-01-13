import 'package:drift/drift.dart';

import '../../domain/entities/procurement.dart';
import '../../domain/repos/procurement_repository.dart';
import '../data_sources/database.dart';
import '../models/procurement_mapper.dart';

class ProcurementRepositoryImpl implements ProcurementRepository {
  final AppDatabase _database;

  ProcurementRepositoryImpl(this._database);

  @override
  Future<List<Procurement>> getAllProcurements() async {
    final query = _database.select(_database.procurementTable)
      ..orderBy([(t) => OrderingTerm.asc(t.id)]);
    final results = await query.get();
    return results.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Procurement?> getProcurementById(int id) async {
    final query = _database.select(_database.procurementTable)
      ..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    return result?.toEntity();
  }

  @override
  Future<List<Procurement>> getProcurementsByFilters({
    String? platform,
    String? category,
    String? status,
    double? minPrice,
    double? maxPrice,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var query = _database.select(_database.procurementTable);

    if (platform != null && platform.isNotEmpty) {
      query = query..where((t) => t.platform.equals(platform));
    }
    if (category != null && category.isNotEmpty) {
      query = query..where((t) => t.category.equals(category));
    }
    if (status != null && status.isNotEmpty) {
      query = query..where((t) => t.status.equals(status));
    }
    if (minPrice != null) {
      query = query..where((t) => t.price.isBiggerOrEqualValue(minPrice));
    }
    if (maxPrice != null) {
      query = query..where((t) => t.price.isSmallerOrEqualValue(maxPrice));
    }
    if (startDate != null) {
      query = query..where((t) => t.publishedDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query = query..where((t) => t.publishedDate.isSmallerOrEqualValue(endDate));
    }

    query = query..orderBy([(t) => OrderingTerm.asc(t.id)]);

    final results = await query.get();
    return results.map((e) => e.toEntity()).toList();
  }

  @override
  Future<int> insertProcurement(Procurement procurement) async {
    return await _database
        .into(_database.procurementTable)
        .insert(procurement.toCompanion());
  }

  @override
  Future<void> insertProcurements(List<Procurement> procurements) async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.procurementTable,
        procurements.map((p) => p.toCompanion()).toList(),
      );
    });
  }

  @override
  Future<void> updateProcurement(Procurement procurement) async {
    if (procurement.id == null) {
      throw Exception('Cannot update procurement without id');
    }
    await (_database.update(_database.procurementTable)
          ..where((t) => t.id.equals(procurement.id!)))
        .write(procurement.toCompanion());
  }

  @override
  Future<void> deleteProcurement(int id) async {
    await (_database.delete(_database.procurementTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<void> deleteAllProcurements() async {
    await _database.delete(_database.procurementTable).go();
  }

  @override
  Future<Map<String, int>> getProcurementsCountByPlatform() async {
    final all = await getAllProcurements();
    final map = <String, int>{};
    for (var p in all) {
      map[p.platform] = (map[p.platform] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<double> getTotalSum() async {
    final all = await getAllProcurements();
    double sum = 0.0;
    for (var p in all) {
      sum += p.price;
    }
    return sum;
  }

  @override
  Future<Map<String, int>> getProcurementsCountByStatus() async {
    final all = await getAllProcurements();
    final map = <String, int>{};
    for (var p in all) {
      map[p.status] = (map[p.status] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<Map<String, int>> getProcurementsCountByCategory() async {
    final all = await getAllProcurements();
    final map = <String, int>{};
    for (var p in all) {
      map[p.category] = (map[p.category] ?? 0) + 1;
    }
    return map;
  }

  @override
  Future<Map<DateTime, int>> getProcurementsByDate() async {
    final all = await getAllProcurements();
    final map = <DateTime, int>{};
    for (var p in all) {
      final date = DateTime(p.publishedDate.year, p.publishedDate.month, p.publishedDate.day);
      map[date] = (map[date] ?? 0) + 1;
    }
    return map;
  }
}
