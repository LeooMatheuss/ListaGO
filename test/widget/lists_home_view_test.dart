import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/theme/app_theme.dart';
import 'package:listago/features/lists/domain/list_repository.dart';
import 'package:listago/features/lists/domain/shopping_list.dart';
import 'package:listago/features/lists/presentation/lists_home_view.dart';
import 'package:listago/features/lists/providers/list_repository_provider.dart';

class _FakeListRepository implements ListRepository {
  _FakeListRepository({List<ShoppingList>? initialLists})
      : _lists = List<ShoppingList>.from(initialLists ?? const []);

  final List<ShoppingList> _lists;

  @override
  Future<int> createList({required String name, bool favorite = false}) async {
    final id = _lists.length + 1;
    _lists.add(
      ShoppingList(
        id: id,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        favorite: favorite,
      ),
    );
    return id;
  }

  @override
  Future<void> deleteList(int id) async => _lists.removeWhere((list) => list.id == id);

  @override
  Future<int> duplicateList(int id) async => 2;

  @override
  Future<List<ShoppingList>> listLists() async => List.unmodifiable(_lists);

  @override
  Future<void> toggleFavorite(int id) async {
    final index = _lists.indexWhere((list) => list.id == id);
    if (index >= 0) {
      final list = _lists[index];
      _lists[index] = ShoppingList(
        id: list.id,
        name: list.name,
        createdAt: list.createdAt,
        updatedAt: list.updatedAt,
        favorite: !list.favorite,
      );
    }
  }

  @override
  Future<void> updateList({required int id, String? name, bool? favorite}) async {}
}

void main() {
  testWidgets('mostra estado vazio quando não há listas', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listRepositoryProvider.overrideWithValue(_FakeListRepository()),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const ListsHomeView()),
      ),
    );

    await tester.pump();

    expect(find.text('Nenhuma lista ainda'), findsOneWidget);
  });

  testWidgets('mostra lista populada e permite favoritar', (tester) async {
    final list = ShoppingList(
      id: 1,
      name: 'Mercado',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      favorite: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          listRepositoryProvider.overrideWithValue(
            _FakeListRepository(initialLists: [list]),
          ),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const ListsHomeView()),
      ),
    );

    await tester.pump();

    expect(find.text('Mercado'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star_border));
    await tester.pump();

    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
