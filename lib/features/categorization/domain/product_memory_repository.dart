import 'product_memory.dart';

abstract interface class ProductMemoryRepository {
  Future<void> registerUsage({
    required String normalizedName,
    required String category,
  });
  Future<List<ProductMemory>> historyFor(String normalizedName);
}
