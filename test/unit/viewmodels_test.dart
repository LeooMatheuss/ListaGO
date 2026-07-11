import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/enums/item_category.dart';
import 'package:listago/features/categorization/domain/learned_category.dart';
import 'package:listago/features/categorization/domain/learned_category_repository.dart';
import 'package:listago/features/items/domain/shopping_item.dart';
import 'package:listago/features/items/presentation/add_item_notifier.dart';
import 'package:listago/features/items/presentation/list_detail_notifier.dart';
import 'package:listago/features/items/providers/item_repository_provider.dart';
import 'package:listago/features/lists/domain/shopping_list.dart';
import 'package:listago/features/lists/presentation/lists_home_notifier.dart';
import 'package:listago/features/lists/domain/list_repository.dart';
import 'package:listago/features/items/domain/item_repository.dart';
import 'package:listago/features/lists/providers/list_repository_provider.dart';
import 'package:listago/features/categorization/providers/learned_category_repository_provider.dart';

class _FakeListRepository implements ListRepository {
  final lists = <ShoppingList>[];

  @override
  Future<int> createList({required String name, bool favorite = false}) async {
    final id = lists.length + 1;
    lists.add(ShoppingList(id: id, name: name, createdAt: DateTime.now(), updatedAt: DateTime.now(), favorite: favorite));
    return id;
  }

  @override
  Future<void> deleteList(int id) async {
    lists.removeWhere((list) => list.id == id);
  }

  @override
  Future<int> duplicateList(int id) async {
    final source = lists.firstWhere((list) => list.id == id);
    return createList(name: '${source.name} (cópia)');
  }

  @override
  Future<List<ShoppingList>> listLists() async => lists;

  @override
  Future<void> toggleFavorite(int id) async {
    final index = lists.indexWhere((list) => list.id == id);
    if (index >= 0) {
      final current = lists[index];
      lists[index] = ShoppingList(id: current.id, name: current.name, createdAt: current.createdAt, updatedAt: current.updatedAt, favorite: !current.favorite);
    }
  }

  @override
  Future<void> updateList({required int id, String? name, bool? favorite}) async {}
}

class _FakeItemRepository implements ItemRepository {
  final items = <ShoppingItem>[];

  @override
  Future<int> addItem({required int listId, required String name, required String quantity, required String unit, required String category, bool bought = false}) async {
    final id = items.length + 1;
    items.add(ShoppingItem(id: id, listId: listId, name: name, quantity: quantity, unit: unit, category: category, bought: bought, addedAt: DateTime.now()));
    return id;
  }

  @override
  Future<List<ShoppingItem>> listItemsForList(int listId) async => items.where((item) => item.listId == listId).toList();

  @override
  Future<void> markAsBought(int id, {required bool bought}) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final current = items[index];
      items[index] = ShoppingItem(id: current.id, listId: current.listId, name: current.name, quantity: current.quantity, unit: current.unit, category: current.category, bought: bought, addedAt: current.addedAt);
    }
  }

  @override
  Future<void> removeItem(int id) async {
    items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> updateQuantity(int id, {required String quantity}) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final current = items[index];
      items[index] = ShoppingItem(id: current.id, listId: current.listId, name: current.name, quantity: quantity, unit: current.unit, category: current.category, bought: current.bought, addedAt: current.addedAt);
    }
  }
}

class _FakeLearnedCategoryRepository implements LearnedCategoryRepository {
  final Map<String, String> categories = <String, String>{};

  @override
  Future<void> upsertCategory({required String term, required String category}) async {
    categories[term] = category;
  }

  @override
  Future<LearnedCategory?> findByTerm(String term) async {
    final category = categories[term];
    if (category == null) {
      return null;
    }
    return LearnedCategory(id: 1, term: term, category: category, frequencyUsage: 1);
  }
}

void main() {
  test('lists notifier cria e lista compras', () async {
    final container = ProviderContainer(overrides: [
      listRepositoryProvider.overrideWithValue(_FakeListRepository()),
    ]);

    addTearDown(container.dispose);
    final notifier = container.read(listsHomeNotifierProvider.notifier);

    await notifier.criarLista(name: 'Mercado');
    final state = container.read(listsHomeNotifierProvider).value;
    expect(state, isNotNull);
    expect(state!.single.name, 'Mercado');
  });

  test('list detail notifier adiciona e calcula progresso', () async {
    final repository = _FakeItemRepository();
    final container = ProviderContainer(overrides: [
      itemRepositoryProvider.overrideWithValue(repository),
    ]);

    addTearDown(container.dispose);

    final notifier = container.read(listDetailNotifierProvider.notifier);
    await notifier.configureList(1);
    await notifier.adicionarItem(name: 'Arroz', quantity: '1', unit: 'kg', category: ItemCategory.mercearia.name);
    await notifier.marcarComprado(1, bought: true);

    expect(container.read(listDetailNotifierProvider).value, isNotEmpty);
    expect(notifier.progressPercent, 1.0);
  });

  test('add item notifier sugere categoria e aprende correção', () async {
    final repository = _FakeLearnedCategoryRepository();
    final container = ProviderContainer(overrides: [
      learnedCategoryRepositoryProvider.overrideWithValue(repository),
    ]);

    addTearDown(container.dispose);

    final notifier = container.read(addItemNotifierProvider.notifier);
    notifier.updateText('Detergente');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(notifier.state.suggestedCategory, ItemCategory.limpeza);

    await notifier.confirmarCategoria(ItemCategory.limpeza);
    expect(repository.categories['detergente'], ItemCategory.limpeza.name);
  });
}
