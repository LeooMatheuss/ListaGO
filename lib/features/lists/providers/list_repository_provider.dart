import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/list_repository_impl.dart';
import '../domain/list_repository.dart';

final listRepositoryProvider = Provider<ListRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ListRepositoryImpl(database);
});
