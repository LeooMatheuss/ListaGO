class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.bought,
    required this.addedAt,
  });

  final int id;
  final int listId;
  final String name;
  final String quantity;
  final String unit;
  final String category;
  final bool bought;
  final DateTime addedAt;
}
