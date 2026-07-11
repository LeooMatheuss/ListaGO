import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/product_memory_repository_impl.dart';
import '../domain/product_memory_repository.dart';

final productMemoryRepositoryProvider = Provider<ProductMemoryRepository>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return ProductMemoryRepositoryImpl(database);
});
