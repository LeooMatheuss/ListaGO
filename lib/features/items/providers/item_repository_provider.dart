import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/item_repository_impl.dart';
import '../domain/item_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ItemRepositoryImpl(database);
});
