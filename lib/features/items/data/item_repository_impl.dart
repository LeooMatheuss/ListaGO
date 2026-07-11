import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums/item_category.dart';
import '../../../core/database/enums/measurement_unit.dart';
import '../domain/item_repository.dart';
import '../domain/shopping_item.dart' as domain_item;

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<int> addItem({
    required int listId,
    required String name,
    required String quantity,
    required String unit,
    required String category,
    bool bought = false,
  }) {
    return database
        .into(database.shoppingItems)
        .insert(
          ShoppingItemsCompanion.insert(
            listId: listId,
            name: name,
            quantity: quantity,
            unit: _parseUnit(unit),
            category: _parseCategory(category),
            bought: Value(bought),
            addedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<List<domain_item.ShoppingItem>> listItemsForList(int listId) async {
    final rows = await (database.select(
      database.shoppingItems,
    )..where((tbl) => tbl.listId.equals(listId))).get();

    return rows
        .map(
          (row) => domain_item.ShoppingItem(
            id: row.id,
            listId: row.listId,
            name: row.name,
            quantity: row.quantity,
            category: row.category.name,
            unit: row.unit.name,
            bought: row.bought,
            addedAt: row.addedAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> markAsBought(int id, {required bool bought}) async {
    await (database.update(database.shoppingItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(ShoppingItemsCompanion(bought: Value(bought)));
  }

  @override
  Future<void> removeItem(int id) async {
    await (database.delete(
      database.shoppingItems,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> updateQuantity(int id, {required String quantity}) async {
    await (database.update(database.shoppingItems)
          ..where((tbl) => tbl.id.equals(id)))
        .write(ShoppingItemsCompanion(quantity: Value(quantity)));
  }

  MeasurementUnit _parseUnit(String value) {
    return MeasurementUnit.values.firstWhere(
      (unit) => unit.name == value,
      orElse: () => MeasurementUnit.unidade,
    );
  }

  ItemCategory _parseCategory(String value) {
    return ItemCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ItemCategory.outros,
    );
  }
}
