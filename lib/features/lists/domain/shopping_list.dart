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
}
