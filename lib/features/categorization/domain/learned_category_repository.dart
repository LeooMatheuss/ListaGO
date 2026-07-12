import 'learned_category.dart';

abstract interface class LearnedCategoryRepository {
  Future<void> upsertCategory({required String term, required String category});
  Future<LearnedCategory?> findByTerm(String term);
}
