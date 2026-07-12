class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.favorite,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool favorite;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingList &&
        other.id == id &&
        other.name == name &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.favorite == favorite;
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt, favorite);
}
