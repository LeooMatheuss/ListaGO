class ProductMemory {
  const ProductMemory({
    required this.id,
    required this.normalizedName,
    required this.associatedCategory,
    required this.lastUsedAt,
  });

  final int id;
  final String normalizedName;
  final String associatedCategory;
  final DateTime lastUsedAt;
}
