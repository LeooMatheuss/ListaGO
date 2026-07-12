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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem &&
        other.id == id &&
        other.listId == listId &&
        other.name == name &&
        other.quantity == quantity &&
        other.unit == unit &&
        other.category == category &&
        other.bought == bought &&
        other.addedAt == addedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, listId, name, quantity, unit, category, bought, addedAt);
}
