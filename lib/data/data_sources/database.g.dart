// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProcurementTableTable extends ProcurementTable
    with TableInfo<$ProcurementTableTable, ProcurementTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProcurementTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerMeta = const VerificationMeta(
    'customer',
  );
  @override
  late final GeneratedColumn<String> customer = GeneratedColumn<String>(
    'customer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedDateMeta = const VerificationMeta(
    'publishedDate',
  );
  @override
  late final GeneratedColumn<DateTime> publishedDate =
      GeneratedColumn<DateTime>(
        'published_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    platform,
    customer,
    title,
    category,
    price,
    publishedDate,
    status,
    region,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'procurement_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProcurementTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('customer')) {
      context.handle(
        _customerMeta,
        customer.isAcceptableOrUnknown(data['customer']!, _customerMeta),
      );
    } else if (isInserting) {
      context.missing(_customerMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('published_date')) {
      context.handle(
        _publishedDateMeta,
        publishedDate.isAcceptableOrUnknown(
          data['published_date']!,
          _publishedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProcurementTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProcurementTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      customer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      publishedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
    );
  }

  @override
  $ProcurementTableTable createAlias(String alias) {
    return $ProcurementTableTable(attachedDatabase, alias);
  }
}

class ProcurementTableData extends DataClass
    implements Insertable<ProcurementTableData> {
  final int id;
  final String platform;
  final String customer;
  final String title;
  final String category;
  final double price;
  final DateTime publishedDate;
  final String status;
  final String region;
  const ProcurementTableData({
    required this.id,
    required this.platform,
    required this.customer,
    required this.title,
    required this.category,
    required this.price,
    required this.publishedDate,
    required this.status,
    required this.region,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['platform'] = Variable<String>(platform);
    map['customer'] = Variable<String>(customer);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['price'] = Variable<double>(price);
    map['published_date'] = Variable<DateTime>(publishedDate);
    map['status'] = Variable<String>(status);
    map['region'] = Variable<String>(region);
    return map;
  }

  ProcurementTableCompanion toCompanion(bool nullToAbsent) {
    return ProcurementTableCompanion(
      id: Value(id),
      platform: Value(platform),
      customer: Value(customer),
      title: Value(title),
      category: Value(category),
      price: Value(price),
      publishedDate: Value(publishedDate),
      status: Value(status),
      region: Value(region),
    );
  }

  factory ProcurementTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProcurementTableData(
      id: serializer.fromJson<int>(json['id']),
      platform: serializer.fromJson<String>(json['platform']),
      customer: serializer.fromJson<String>(json['customer']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<double>(json['price']),
      publishedDate: serializer.fromJson<DateTime>(json['publishedDate']),
      status: serializer.fromJson<String>(json['status']),
      region: serializer.fromJson<String>(json['region']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'platform': serializer.toJson<String>(platform),
      'customer': serializer.toJson<String>(customer),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<double>(price),
      'publishedDate': serializer.toJson<DateTime>(publishedDate),
      'status': serializer.toJson<String>(status),
      'region': serializer.toJson<String>(region),
    };
  }

  ProcurementTableData copyWith({
    int? id,
    String? platform,
    String? customer,
    String? title,
    String? category,
    double? price,
    DateTime? publishedDate,
    String? status,
    String? region,
  }) => ProcurementTableData(
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
  ProcurementTableData copyWithCompanion(ProcurementTableCompanion data) {
    return ProcurementTableData(
      id: data.id.present ? data.id.value : this.id,
      platform: data.platform.present ? data.platform.value : this.platform,
      customer: data.customer.present ? data.customer.value : this.customer,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      publishedDate: data.publishedDate.present
          ? data.publishedDate.value
          : this.publishedDate,
      status: data.status.present ? data.status.value : this.status,
      region: data.region.present ? data.region.value : this.region,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProcurementTableData(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('customer: $customer, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('publishedDate: $publishedDate, ')
          ..write('status: $status, ')
          ..write('region: $region')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    platform,
    customer,
    title,
    category,
    price,
    publishedDate,
    status,
    region,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProcurementTableData &&
          other.id == this.id &&
          other.platform == this.platform &&
          other.customer == this.customer &&
          other.title == this.title &&
          other.category == this.category &&
          other.price == this.price &&
          other.publishedDate == this.publishedDate &&
          other.status == this.status &&
          other.region == this.region);
}

class ProcurementTableCompanion extends UpdateCompanion<ProcurementTableData> {
  final Value<int> id;
  final Value<String> platform;
  final Value<String> customer;
  final Value<String> title;
  final Value<String> category;
  final Value<double> price;
  final Value<DateTime> publishedDate;
  final Value<String> status;
  final Value<String> region;
  const ProcurementTableCompanion({
    this.id = const Value.absent(),
    this.platform = const Value.absent(),
    this.customer = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.publishedDate = const Value.absent(),
    this.status = const Value.absent(),
    this.region = const Value.absent(),
  });
  ProcurementTableCompanion.insert({
    this.id = const Value.absent(),
    required String platform,
    required String customer,
    required String title,
    required String category,
    required double price,
    required DateTime publishedDate,
    required String status,
    required String region,
  }) : platform = Value(platform),
       customer = Value(customer),
       title = Value(title),
       category = Value(category),
       price = Value(price),
       publishedDate = Value(publishedDate),
       status = Value(status),
       region = Value(region);
  static Insertable<ProcurementTableData> custom({
    Expression<int>? id,
    Expression<String>? platform,
    Expression<String>? customer,
    Expression<String>? title,
    Expression<String>? category,
    Expression<double>? price,
    Expression<DateTime>? publishedDate,
    Expression<String>? status,
    Expression<String>? region,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platform != null) 'platform': platform,
      if (customer != null) 'customer': customer,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (publishedDate != null) 'published_date': publishedDate,
      if (status != null) 'status': status,
      if (region != null) 'region': region,
    });
  }

  ProcurementTableCompanion copyWith({
    Value<int>? id,
    Value<String>? platform,
    Value<String>? customer,
    Value<String>? title,
    Value<String>? category,
    Value<double>? price,
    Value<DateTime>? publishedDate,
    Value<String>? status,
    Value<String>? region,
  }) {
    return ProcurementTableCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (customer.present) {
      map['customer'] = Variable<String>(customer.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (publishedDate.present) {
      map['published_date'] = Variable<DateTime>(publishedDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProcurementTableCompanion(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('customer: $customer, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('publishedDate: $publishedDate, ')
          ..write('status: $status, ')
          ..write('region: $region')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProcurementTableTable procurementTable = $ProcurementTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [procurementTable];
}

typedef $$ProcurementTableTableCreateCompanionBuilder =
    ProcurementTableCompanion Function({
      Value<int> id,
      required String platform,
      required String customer,
      required String title,
      required String category,
      required double price,
      required DateTime publishedDate,
      required String status,
      required String region,
    });
typedef $$ProcurementTableTableUpdateCompanionBuilder =
    ProcurementTableCompanion Function({
      Value<int> id,
      Value<String> platform,
      Value<String> customer,
      Value<String> title,
      Value<String> category,
      Value<double> price,
      Value<DateTime> publishedDate,
      Value<String> status,
      Value<String> region,
    });

class $$ProcurementTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProcurementTableTable> {
  $$ProcurementTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customer => $composableBuilder(
    column: $table.customer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProcurementTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProcurementTableTable> {
  $$ProcurementTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customer => $composableBuilder(
    column: $table.customer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProcurementTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProcurementTableTable> {
  $$ProcurementTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get customer =>
      $composableBuilder(column: $table.customer, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedDate => $composableBuilder(
    column: $table.publishedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);
}

class $$ProcurementTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProcurementTableTable,
          ProcurementTableData,
          $$ProcurementTableTableFilterComposer,
          $$ProcurementTableTableOrderingComposer,
          $$ProcurementTableTableAnnotationComposer,
          $$ProcurementTableTableCreateCompanionBuilder,
          $$ProcurementTableTableUpdateCompanionBuilder,
          (
            ProcurementTableData,
            BaseReferences<
              _$AppDatabase,
              $ProcurementTableTable,
              ProcurementTableData
            >,
          ),
          ProcurementTableData,
          PrefetchHooks Function()
        > {
  $$ProcurementTableTableTableManager(
    _$AppDatabase db,
    $ProcurementTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProcurementTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProcurementTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProcurementTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> customer = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<DateTime> publishedDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> region = const Value.absent(),
              }) => ProcurementTableCompanion(
                id: id,
                platform: platform,
                customer: customer,
                title: title,
                category: category,
                price: price,
                publishedDate: publishedDate,
                status: status,
                region: region,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String platform,
                required String customer,
                required String title,
                required String category,
                required double price,
                required DateTime publishedDate,
                required String status,
                required String region,
              }) => ProcurementTableCompanion.insert(
                id: id,
                platform: platform,
                customer: customer,
                title: title,
                category: category,
                price: price,
                publishedDate: publishedDate,
                status: status,
                region: region,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProcurementTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProcurementTableTable,
      ProcurementTableData,
      $$ProcurementTableTableFilterComposer,
      $$ProcurementTableTableOrderingComposer,
      $$ProcurementTableTableAnnotationComposer,
      $$ProcurementTableTableCreateCompanionBuilder,
      $$ProcurementTableTableUpdateCompanionBuilder,
      (
        ProcurementTableData,
        BaseReferences<
          _$AppDatabase,
          $ProcurementTableTable,
          ProcurementTableData
        >,
      ),
      ProcurementTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProcurementTableTableTableManager get procurementTable =>
      $$ProcurementTableTableTableManager(_db, _db.procurementTable);
}
