import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/enums/item_category.dart';
import '../domain/shopping_item.dart';
import '../providers/item_repository_provider.dart';

class ListDetailNotifier extends AsyncNotifier<List<ShoppingItem>> {
  late int listId;

  @override
  FutureOr<List<ShoppingItem>> build() async {
    return const <ShoppingItem>[];
  }

  Future<void> configureList(int id) async {
    listId = id;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadItems(id));
  }

  Future<List<ShoppingItem>> _loadItems(int id) async {
    final repository = ref.read(itemRepositoryProvider);
    return repository.listItemsForList(id);
  }

  Future<void> adicionarItem({
    required String name,
    required String quantity,
    required String unit,
    required String category,
  }) async {
    final repository = ref.read(itemRepositoryProvider);
    await repository.addItem(
      listId: listId,
      name: name,
      quantity: quantity,
      unit: unit,
      category: category,
    );
    state = await AsyncValue.guard(() => _loadItems(listId));
  }

  Future<void> removerItem(int id) async {
    final repository = ref.read(itemRepositoryProvider);
    await repository.removeItem(id);
    state = await AsyncValue.guard(() => _loadItems(listId));
  }

  Future<void> marcarComprado(int id, {required bool bought}) async {
    final repository = ref.read(itemRepositoryProvider);
    await repository.markAsBought(id, bought: bought);
    state = await AsyncValue.guard(() => _loadItems(listId));
  }

  Future<void> atualizarQuantidade(int id, {required String quantity}) async {
    final repository = ref.read(itemRepositoryProvider);
    await repository.updateQuantity(id, quantity: quantity);
    state = await AsyncValue.guard(() => _loadItems(listId));
  }

  List<ShoppingItem> itemsByCategory(ItemCategory category) {
    final items = state.hasValue ? state.value! : const <ShoppingItem>[];
    return items.where((item) => item.category == category.name).toList();
  }

  double get progressPercent {
    final items = state.hasValue ? state.value! : const <ShoppingItem>[];
    if (items.isEmpty) {
      return 0;
    }

    final bought = items.where((item) => item.bought).length;
    return bought / items.length;
  }
}

final listDetailNotifierProvider =
    AsyncNotifierProvider<ListDetailNotifier, List<ShoppingItem>>(() {
      return ListDetailNotifier();
    });
