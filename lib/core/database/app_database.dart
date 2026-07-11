import 'package:drift/drift.dart';

import 'enums/item_category.dart';
import 'enums/measurement_unit.dart';
import 'tables/learned_categories.dart';
import 'tables/product_memories.dart';
import 'tables/shopping_items.dart';
import 'tables/shopping_lists.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  ShoppingLists,
  ShoppingItems,
  LearnedCategories,
  ProductMemories,
])
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
