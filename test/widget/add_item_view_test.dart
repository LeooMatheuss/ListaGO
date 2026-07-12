import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/theme/app_theme.dart';
import 'package:listago/features/categorization/domain/learned_category.dart';
import 'package:listago/features/categorization/domain/learned_category_repository.dart';
import 'package:listago/features/categorization/providers/learned_category_repository_provider.dart';
import 'package:listago/features/items/domain/item_repository.dart';
import 'package:listago/features/items/domain/shopping_item.dart';
import 'package:listago/features/items/presentation/add_item_view.dart';
import 'package:listago/features/items/presentation/list_detail_notifier.dart';
import 'package:listago/features/items/providers/item_repository_provider.dart';

class _FakeLearnedCategoryRepository implements LearnedCategoryRepository {
  @override
  Future<LearnedCategory?> findByTerm(String term) async => null;

  @override
  Future<void> upsertCategory({
    required String term,
    required String category,
  }) async {}
}

class _FakeItemRepository implements ItemRepository {
  @override
  Future<int> addItem({
    required int listId,
    required String name,
    required String quantity,
    required String unit,
    required String category,
    bool bought = false,
  }) async => 1;

  @override
  Future<List<ShoppingItem>> listItemsForList(int listId) async => const [];

  @override
  Future<void> markAsBought(int id, {required bool bought}) async {}

  @override
  Future<void> removeItem(int id) async {}

  @override
  Future<void> updateQuantity(int id, {required String quantity}) async {}
}

class _PreConfiguredListDetailNotifier extends ListDetailNotifier {
  @override
  Future<List<ShoppingItem>> build() async => const [];
}

void main() {
  testWidgets('sugere categoria ao digitar e permite sobrescrever', (
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
        child: MaterialApp(theme: AppTheme.light(), home: const AddItemView()),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'Detergente');
    await tester.pump();

    expect(find.text('Limpeza'), findsOneWidget);

    await tester.tap(find.text('Limpeza'));
    await tester.pump();

    expect(find.text('Limpeza'), findsWidgets);
  });
}
