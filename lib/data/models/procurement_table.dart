import 'package:drift/drift.dart';

class ProcurementTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get platform => text()();
  TextColumn get customer => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  RealColumn get price => real()();
  DateTimeColumn get publishedDate => dateTime()();
  TextColumn get status => text()();
  TextColumn get region => text()();
}
