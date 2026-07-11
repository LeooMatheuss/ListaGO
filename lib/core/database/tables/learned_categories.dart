import 'package:drift/drift.dart';

import '../enums/item_category.dart';

class LearnedCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get term => text()();
  TextColumn get category => text().map(const ItemCategoryConverter())();
  IntColumn get frequencyUsage => integer().withDefault(const Constant(1))();
}
