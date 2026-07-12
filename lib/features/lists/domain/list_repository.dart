import 'shopping_list.dart';

abstract interface class ListRepository {
  Future<int> createList({required String name, bool favorite = false});
  Future<List<ShoppingList>> listLists();
  Future<void> updateList({required int id, String? name, bool? favorite});
  Future<void> deleteList(int id);
  Future<int> duplicateList(int id);
  Future<void> toggleFavorite(int id);
}
