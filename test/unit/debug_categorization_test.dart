import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/enums/item_category.dart';
import 'package:listago/features/categorization/domain/category_service.dart';
import 'package:listago/features/categorization/domain/learned_category.dart';
import 'package:listago/features/categorization/domain/learned_category_repository.dart';
import 'package:listago/core/utils/text_normalizer.dart';

class Repo implements LearnedCategoryRepository {
  @override
  Future<LearnedCategory?> findByTerm(String term) async => null;

  @override
  Future<void> upsertCategory({required String term, required String category}) async {}
}

void main() {
  test('debug', () async {
    final service = CategoryService(learnedCategoryRepository: Repo());
    final normalized = TextNormalizer.normalize('produto totalmente inesperado');
    final category = await service.categorize('produto totalmente inesperado');
    expect(normalized, 'produto totalmente inesperado');
    expect(category, ItemCategory.outros);
  });
}
