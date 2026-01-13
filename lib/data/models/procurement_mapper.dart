import '../../domain/entities/procurement.dart';
import '../data_sources/database.dart';

extension ProcurementMapper on ProcurementTableData {
  Procurement toEntity() {
    return Procurement(
      id: id,
      platform: platform,
      customer: customer,
      title: title,
      category: category,
      price: price,
      publishedDate: publishedDate,
      status: status,
      region: region,
    );
  }
}

extension ProcurementCompanionMapper on Procurement {
  ProcurementTableCompanion toCompanion() {
    return ProcurementTableCompanion.insert(
      platform: platform,
      customer: customer,
      title: title,
      category: category,
      price: price,
      publishedDate: publishedDate,
      status: status,
      region: region,
    );
  }
}
