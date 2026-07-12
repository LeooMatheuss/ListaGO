import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/shopping_list.dart';
import '../providers/list_repository_provider.dart';

class ListsHomeNotifier extends AsyncNotifier<List<ShoppingList>> {
  @override
  FutureOr<List<ShoppingList>> build() async {
    return _loadLists();
  }

  Future<List<ShoppingList>> _loadLists() async {
    final repository = ref.read(listRepositoryProvider);
    return repository.listLists();
  }

  Future<void> criarLista({required String name}) async {
    state = const AsyncLoading();
    final repository = ref.read(listRepositoryProvider);
    await repository.createList(name: name);
    state = await AsyncValue.guard(_loadLists);
  }

  Future<void> deletarLista(int id) async {
    state = const AsyncLoading();
    final repository = ref.read(listRepositoryProvider);
    await repository.deleteList(id);
    state = await AsyncValue.guard(_loadLists);
  }

  Future<void> duplicarLista(int id) async {
    state = const AsyncLoading();
    final repository = ref.read(listRepositoryProvider);
    await repository.duplicateList(id);
    state = await AsyncValue.guard(_loadLists);
  }

  Future<void> alternarFavorito(int id) async {
    state = const AsyncLoading();
    final repository = ref.read(listRepositoryProvider);
    await repository.toggleFavorite(id);
    state = await AsyncValue.guard(_loadLists);
  }
}

final listsHomeNotifierProvider =
    AsyncNotifierProvider<ListsHomeNotifier, List<ShoppingList>>(() {
      return ListsHomeNotifier();
    });
