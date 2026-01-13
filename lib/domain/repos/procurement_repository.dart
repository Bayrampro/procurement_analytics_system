import '../entities/procurement.dart';

abstract class ProcurementRepository {
  Future<List<Procurement>> getAllProcurements();
  Future<Procurement?> getProcurementById(int id);
  Future<List<Procurement>> getProcurementsByFilters({
    String? platform,
    String? category,
    String? status,
    double? minPrice,
    double? maxPrice,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<int> insertProcurement(Procurement procurement);
  Future<void> insertProcurements(List<Procurement> procurements);
  Future<void> updateProcurement(Procurement procurement);
  Future<void> deleteProcurement(int id);
  Future<void> deleteAllProcurements();
  
  // Analytics methods
  Future<Map<String, int>> getProcurementsCountByPlatform();
  Future<double> getTotalSum();
  Future<Map<String, int>> getProcurementsCountByStatus();
  Future<Map<String, int>> getProcurementsCountByCategory();
  Future<Map<DateTime, int>> getProcurementsByDate();
}
