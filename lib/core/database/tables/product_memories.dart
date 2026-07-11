import 'package:drift/drift.dart';

import '../enums/item_category.dart';

class ProductMemories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get normalizedName => text()();
  TextColumn get associatedCategory => text().map(const ItemCategoryConverter())();
  DateTimeColumn get lastUsedAt => dateTime()();
}
