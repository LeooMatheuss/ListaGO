import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enums/item_category.dart';
import 'enums/measurement_unit.dart';
import 'tables/learned_categories.dart';
import 'tables/product_memories.dart';
import 'tables/shopping_items.dart';
import 'tables/shopping_lists.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(NativeDatabase.memory());
  ref.onDispose(database.close);
  return database;
});

@DriftDatabase(
  tables: [ShoppingLists, ShoppingItems, LearnedCategories, ProductMemories],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < to) {
        await m.createAll();
      }
    },
  );
}
