import '../../data/data_sources/database.dart';
import '../../data/repos/procurement_repository_impl.dart';
import '../../domain/repos/procurement_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final AppDatabase _database;
  late final ProcurementRepository _procurementRepository;

  void init() {
    _database = AppDatabase();
    _procurementRepository = ProcurementRepositoryImpl(_database);
  }

  AppDatabase get database => _database;
  ProcurementRepository get procurementRepository => _procurementRepository;
}
