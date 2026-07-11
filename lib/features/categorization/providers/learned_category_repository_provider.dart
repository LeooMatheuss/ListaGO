import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/learned_category_repository_impl.dart';
import '../domain/learned_category_repository.dart';

final learnedCategoryRepositoryProvider = Provider<LearnedCategoryRepository>((
  ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return LearnedCategoryRepositoryImpl(database);
});
