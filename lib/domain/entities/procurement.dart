class Procurement {
  final int? id;
  final String platform;
  final String customer;
  final String title;
  final String category;
  final double price;
  final DateTime publishedDate;
  final String status;
  final String region;

  Procurement({
    this.id,
    required this.platform,
    required this.customer,
    required this.title,
    required this.category,
    required this.price,
    required this.publishedDate,
    required this.status,
    required this.region,
  });

  Procurement copyWith({
    int? id,
    String? platform,
    String? customer,
    String? title,
    String? category,
    double? price,
    DateTime? publishedDate,
    String? status,
    String? region,
  }) {
    return Procurement(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      customer: customer ?? this.customer,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      publishedDate: publishedDate ?? this.publishedDate,
      status: status ?? this.status,
      region: region ?? this.region,
    );
  }
}
