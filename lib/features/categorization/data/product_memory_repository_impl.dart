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
    await database
        .into(database.productMemories)
        .insert(
          ProductMemoriesCompanion.insert(
            normalizedName: normalizedName,
            associatedCategory: _parseCategory(category),
            lastUsedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<List<domain_memory.ProductMemory>> historyFor(String normalizedName) async {
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
