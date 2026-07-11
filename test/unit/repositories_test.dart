import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/app_database.dart';
import 'package:listago/features/categorization/data/learned_category_repository_impl.dart';
import 'package:listago/features/categorization/data/product_memory_repository_impl.dart';
import 'package:listago/features/items/data/item_repository_impl.dart';
import 'package:listago/features/lists/data/list_repository_impl.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('listas, itens e categorias funcionam via repositórios', () async {
    final lists = ListRepositoryImpl(database);
    final items = ItemRepositoryImpl(database);
    final categories = LearnedCategoryRepositoryImpl(database);
    final memories = ProductMemoryRepositoryImpl(database);

    final listId = await lists.createList(name: 'Mercado da semana');
    expect(listId, isNonZero);

    final createdLists = await lists.listLists();
    expect(createdLists.single.name, 'Mercado da semana');

    await lists.toggleFavorite(listId);
    final toggledLists = await lists.listLists();
    expect(toggledLists.single.favorite, isTrue);

    final itemId = await items.addItem(
      listId: listId,
      name: 'Maçã',
      quantity: '2',
      unit: 'kg',
      category: 'hortifruti',
    );
    expect(itemId, isNonZero);

    final storedItems = await items.listItemsForList(listId);
    expect(storedItems.single.name, 'Maçã');
    expect(storedItems.single.quantity, '2');
    expect(storedItems.single.unit, 'kg');

    await items.markAsBought(itemId, bought: true);
    final boughtItems = await items.listItemsForList(listId);
    expect(boughtItems.single.bought, isTrue);

    await categories.upsertCategory(term: 'tomate', category: 'hortifruti');
    await categories.upsertCategory(term: 'tomate', category: 'hortifruti');
    final learned = await categories.findByTerm('tomate');
    expect(learned, isNotNull);
    expect(learned!.category, 'hortifruti');
    expect(learned.frequencyUsage, 2);

    await memories.registerUsage(
      normalizedName: 'maca-verde',
      category: 'hortifruti',
    );
    final history = await memories.historyFor('maca-verde');
    expect(history.single.associatedCategory, 'hortifruti');
  });
}
