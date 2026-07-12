import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'enums/item_category.dart';
import 'enums/measurement_unit.dart';
import 'tables/learned_categories.dart';
import 'tables/product_memories.dart';
import 'tables/shopping_items.dart';
import 'tables/shopping_lists.dart';

part 'app_database.g.dart';

QueryExecutor _openDatabase() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'listago.sqlite'));
    return NativeDatabase(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(_openDatabase());
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
      await _createIndexes();
    },
    onUpgrade: (m, from, to) async {
      await m.createAll();
      await _createIndexes();
    },
  );

  Future<void> _createIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_items_list_id '
      'ON shopping_items (list_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_items_list_bought '
      'ON shopping_items (list_id, bought)',
    );
  }
}
