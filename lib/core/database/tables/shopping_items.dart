import 'package:drift/drift.dart';

import '../enums/item_category.dart';
import '../enums/measurement_unit.dart';
import 'shopping_lists.dart';

class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId =>
      integer().references(ShoppingLists, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get quantity => text()();
  TextColumn get unit => text().map(const MeasurementUnitConverter())();
  TextColumn get category => text().map(const ItemCategoryConverter())();
  BoolColumn get bought => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();
}
