import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/list_repository.dart';
import '../domain/shopping_list.dart' as domain_list;

class ListRepositoryImpl implements ListRepository {
  ListRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<int> createList({required String name, bool favorite = false}) {
    return database
        .into(database.shoppingLists)
        .insert(
          ShoppingListsCompanion.insert(
            name: name,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            favorite: Value(favorite),
          ),
        );
  }

  @override
  Future<List<domain_list.ShoppingList>> listLists() async {
    final rows = await database.select(database.shoppingLists).get();
    return rows
        .map(
          (row) => domain_list.ShoppingList(
            id: row.id,
            name: row.name,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt,
            favorite: row.favorite,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateList({
    required int id,
    String? name,
    bool? favorite,
  }) async {
    final companion = ShoppingListsCompanion(
      name: name == null ? const Value.absent() : Value(name),
      favorite: favorite == null ? const Value.absent() : Value(favorite),
      updatedAt: Value(DateTime.now()),
    );

    await (database.update(
      database.shoppingLists,
    )..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  @override
  Future<void> deleteList(int id) async {
    await (database.delete(
      database.shoppingLists,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<int> duplicateList(int id) async {
    return database.transaction<int>(() async {
      final listRows = await (database.select(
        database.shoppingLists,
      )..where((tbl) => tbl.id.equals(id))).get();

      if (listRows.isEmpty) {
        throw StateError('Lista não encontrada');
      }

      final original = listRows.first;
      final newListId = await createList(
        name: '${original.name} (cópia)',
        favorite: original.favorite,
      );

      final itemRows = await (database.select(
        database.shoppingItems,
      )..where((tbl) => tbl.listId.equals(id))).get();

      for (final item in itemRows) {
        await database.into(database.shoppingItems).insert(
          ShoppingItemsCompanion.insert(
            listId: newListId,
            name: item.name,
            quantity: item.quantity,
            unit: item.unit,
            category: item.category,
            bought: Value(item.bought),
            addedAt: item.addedAt,
          ),
        );
      }

      return newListId;
    });
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final rows = await (database.select(
      database.shoppingLists,
    )..where((tbl) => tbl.id.equals(id))).get();

    if (rows.isEmpty) {
      return;
    }

    final current = rows.first;
    await updateList(id: id, favorite: !current.favorite);
  }
}
