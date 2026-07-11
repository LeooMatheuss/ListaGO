import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:listago/core/database/app_database.dart';
import 'package:listago/core/database/enums/item_category.dart';
import 'package:listago/core/database/enums/measurement_unit.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('permite inserir e recuperar dados em cada tabela', () async {
    final listId = await database
        .into(database.shoppingLists)
        .insert(
          ShoppingListsCompanion.insert(
            name: 'Compras da semana',
            createdAt: DateTime(2026, 7, 11),
            updatedAt: DateTime(2026, 7, 11),
            favorite: const Value(true),
          ),
        );

    final itemId = await database
        .into(database.shoppingItems)
        .insert(
          ShoppingItemsCompanion.insert(
            listId: listId,
            name: 'Maçã',
            quantity: '2',
            unit: MeasurementUnit.unidade,
            category: ItemCategory.hortifruti,
            bought: const Value(false),
            addedAt: DateTime(2026, 7, 11),
          ),
        );

    await database
        .into(database.learnedCategories)
        .insert(
          LearnedCategoriesCompanion.insert(
            term: 'tomate',
            category: ItemCategory.hortifruti,
            frequencyUsage: const Value(3),
          ),
        );

    await database
        .into(database.productMemories)
        .insert(
          ProductMemoriesCompanion.insert(
            normalizedName: 'banana-prata',
            associatedCategory: ItemCategory.hortifruti,
            lastUsedAt: DateTime(2026, 7, 11),
          ),
        );

    final savedList = await database.managers.shoppingLists.getSingle();
    final savedItem = await database.managers.shoppingItems.getSingle();
    final savedCategory = await database.managers.learnedCategories.getSingle();
    final savedMemory = await database.managers.productMemories.getSingle();

    expect(savedList.name, 'Compras da semana');
    expect(savedList.favorite, isTrue);
    expect(savedItem.name, 'Maçã');
    expect(savedItem.unit, MeasurementUnit.unidade);
    expect(savedItem.category, ItemCategory.hortifruti);
    expect(savedCategory.term, 'tomate');
    expect(savedMemory.normalizedName, 'banana-prata');
    expect(savedMemory.associatedCategory, ItemCategory.hortifruti);
    expect(itemId, isNonZero);
  });
}
