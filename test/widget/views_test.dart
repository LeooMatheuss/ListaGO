import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/enums/item_category.dart';
import 'package:listago/core/theme/app_theme.dart';
import 'package:listago/features/categorization/domain/learned_category.dart';
import 'package:listago/features/categorization/domain/learned_category_repository.dart';
import 'package:listago/features/categorization/providers/learned_category_repository_provider.dart';
import 'package:listago/features/items/domain/item_repository.dart';
import 'package:listago/features/items/domain/shopping_item.dart';
import 'package:listago/features/items/presentation/add_item_view.dart';
import 'package:listago/features/items/presentation/list_detail_notifier.dart';
import 'package:listago/features/items/presentation/widgets/shopping_item_tile.dart';
import 'package:listago/features/items/providers/item_repository_provider.dart';
import 'package:listago/features/lists/domain/list_repository.dart';
import 'package:listago/features/lists/domain/shopping_list.dart';
import 'package:listago/features/lists/presentation/lists_home_view.dart';
import 'package:listago/features/lists/providers/list_repository_provider.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeListRepository implements ListRepository {
  _FakeListRepository({List<ShoppingList>? initial}) : _lists = initial ?? [];

  final List<ShoppingList> _lists;

  @override
  Future<int> createList({required String name, bool favorite = false}) async {
    final id = _lists.length + 1;
    _lists.add(ShoppingList(
      id: id,
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      favorite: favorite,
    ));
    return id;
  }

  @override
  Future<void> deleteList(int id) async =>
      _lists.removeWhere((l) => l.id == id);

  @override
  Future<int> duplicateList(int id) async {
    final source = _lists.firstWhere((l) => l.id == id);
    return createList(name: '${source.name} (cópia)');
  }

  @override
  Future<List<ShoppingList>> listLists() async => List.unmodifiable(_lists);

  @override
  Future<void> toggleFavorite(int id) async {
    final i = _lists.indexWhere((l) => l.id == id);
    if (i >= 0) {
      final l = _lists[i];
      _lists[i] = ShoppingList(
        id: l.id,
        name: l.name,
        createdAt: l.createdAt,
        updatedAt: l.updatedAt,
        favorite: !l.favorite,
      );
    }
  }

  @override
  Future<void> updateList({
    required int id,
    String? name,
    bool? favorite,
  }) async {}
}

class _FakeItemRepository implements ItemRepository {
  final List<ShoppingItem> _items = [];

  @override
  Future<int> addItem({
    required int listId,
    required String name,
    required String quantity,
    required String unit,
    required String category,
    bool bought = false,
  }) async {
    final id = _items.length + 1;
    _items.add(ShoppingItem(
      id: id,
      listId: listId,
      name: name,
      quantity: quantity,
      unit: unit,
      category: category,
      bought: bought,
      addedAt: DateTime.now(),
    ));
    return id;
  }

  @override
  Future<List<ShoppingItem>> listItemsForList(int listId) async =>
      _items.where((item) => item.listId == listId).toList();

  @override
  Future<void> markAsBought(int id, {required bool bought}) async {
    final i = _items.indexWhere((item) => item.id == id);
    if (i >= 0) {
      final item = _items[i];
      _items[i] = ShoppingItem(
        id: item.id,
        listId: item.listId,
        name: item.name,
        quantity: item.quantity,
        unit: item.unit,
        category: item.category,
        bought: bought,
        addedAt: item.addedAt,
      );
    }
  }

  @override
  Future<void> removeItem(int id) async =>
      _items.removeWhere((item) => item.id == id);

  @override
  Future<void> updateQuantity(int id, {required String quantity}) async {}
}

class _FakeLearnedCategoryRepository implements LearnedCategoryRepository {
  final Map<String, String> _categories = {};

  @override
  Future<LearnedCategory?> findByTerm(String term) async {
    final cat = _categories[term];
    if (cat == null) return null;
    return LearnedCategory(
      id: 1,
      term: term,
      category: cat,
      frequencyUsage: 1,
    );
  }

  @override
  Future<void> upsertCategory({
    required String term,
    required String category,
  }) async {
    _categories[term] = category;
  }
}

/// Notifier pré-configurado para testes de AddItemView (listId = 1).
class _PreConfiguredListDetailNotifier extends ListDetailNotifier {
  @override
  Future<List<ShoppingItem>> build() async {
    listId = 1;
    return const [];
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ListsHomeView', () {
    testWidgets('exibe estado vazio quando não há listas', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            listRepositoryProvider.overrideWithValue(_FakeListRepository()),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const ListsHomeView(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Nenhuma lista ainda'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_basket_outlined), findsOneWidget);
    });

    testWidgets('cria lista via dialog e exibe na tela', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            listRepositoryProvider.overrideWithValue(_FakeListRepository()),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const ListsHomeView(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Mercado');
      await tester.tap(find.text('Criar'));
      await tester.pumpAndSettle();

      expect(find.text('Mercado'), findsOneWidget);
    });
  });

  group('AddItemView — sugestão de categoria', () {
    testWidgets('exibe categoria sugerida ao digitar nome do produto', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            learnedCategoryRepositoryProvider.overrideWithValue(
              _FakeLearnedCategoryRepository(),
            ),
            itemRepositoryProvider.overrideWithValue(_FakeItemRepository()),
            listDetailNotifierProvider.overrideWith(
              () => _PreConfiguredListDetailNotifier(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const AddItemView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Nome do produto'),
        'Detergente',
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump();

      final limpezaChips = tester
          .widgetList<ChoiceChip>(find.byType(ChoiceChip))
          .where((chip) => (chip.label as Text).data == 'Limpeza');

      expect(limpezaChips, isNotEmpty);
      expect(limpezaChips.first.selected, isTrue);
    });
  });

  group('ShoppingItemTile', () {
    testWidgets('chama onToggleBought ao marcar item como comprado', (
      tester,
    ) async {
      bool? toggledValue;

      final item = ShoppingItem(
        id: 1,
        listId: 1,
        name: 'Arroz',
        quantity: '1',
        unit: 'kg',
        category: ItemCategory.mercearia.name,
        bought: false,
        addedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ShoppingItemTile(
              item: item,
              onToggleBought: (value) => toggledValue = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(toggledValue, isTrue);
    });

    testWidgets('exibe tachado quando item está comprado', (tester) async {
      final item = ShoppingItem(
        id: 1,
        listId: 1,
        name: 'Leite',
        quantity: '1',
        unit: 'l',
        category: ItemCategory.laticinios.name,
        bought: true,
        addedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ShoppingItemTile(
              item: item,
              onToggleBought: (_) {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Leite'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });
  });
}
