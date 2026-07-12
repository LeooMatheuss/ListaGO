import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums/item_category.dart';
import '../domain/product_memory.dart' as domain_memory;
import '../domain/product_memory_repository.dart';

class ProductMemoryRepositoryImpl implements ProductMemoryRepository {
  ProductMemoryRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<void> registerUsage({
    required String normalizedName,
    required String category,
  }) async {
    final existing =
        await (database.select(database.productMemories)
              ..where((tbl) => tbl.normalizedName.equals(normalizedName)))
            .getSingleOrNull();

    final companion = ProductMemoriesCompanion(
      normalizedName: Value(normalizedName),
      associatedCategory: Value(_parseCategory(category)),
      lastUsedAt: Value(DateTime.now()),
    );

    if (existing == null) {
      await database.into(database.productMemories).insert(companion);
      return;
    }

    await (database.update(
      database.productMemories,
    )..where((tbl) => tbl.id.equals(existing.id))).write(companion);
  }

  @override
  Future<List<domain_memory.ProductMemory>> historyFor(
    String normalizedName,
  ) async {
    final rows = await (database.select(
      database.productMemories,
    )..where((tbl) => tbl.normalizedName.equals(normalizedName))).get();

    return rows
        .map(
          (row) => domain_memory.ProductMemory(
            id: row.id,
            normalizedName: row.normalizedName,
            associatedCategory: row.associatedCategory.name,
            lastUsedAt: row.lastUsedAt,
          ),
        )
        .toList();
  }

  ItemCategory _parseCategory(String value) {
    return ItemCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ItemCategory.outros,
    );
  }
}
