import 'shopping_item.dart';

abstract interface class ItemRepository {
  Future<int> addItem({
    required int listId,
    required String name,
    required String quantity,
    required String unit,
    required String category,
    bool bought = false,
  });
  Future<List<ShoppingItem>> listItemsForList(int listId);
  Future<void> markAsBought(int id, {required bool bought});
  Future<void> removeItem(int id);
  Future<void> updateQuantity(int id, {required String quantity});
}
