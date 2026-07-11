import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/enums/item_category.dart';
import 'package:listago/features/categorization/domain/category_service.dart';
import 'package:listago/features/categorization/domain/learned_category.dart';
import 'package:listago/features/categorization/domain/learned_category_repository.dart';

class _FakeLearnedCategoryRepository implements LearnedCategoryRepository {
  final Map<String, String> _categories = {};

  @override
  Future<void> upsertCategory({
    required String term,
    required String category,
  }) async {
    _categories[term] = category;
  }

  @override
  Future<LearnedCategory?> findByTerm(String term) async {
    if (_categories[term] == null) return null;
    return LearnedCategory(
      id: 1,
      term: term,
      category: _categories[term]!,
      frequencyUsage: 1,
    );
  }
}

void main() {
  late CategoryService service;

  setUp(() {
    service = CategoryService(
      learnedCategoryRepository: _FakeLearnedCategoryRepository(),
    );
  });

  test('categoriza por match exato', () async {
    final category = await service.categorize('Detergente');
    expect(category, ItemCategory.limpeza);
  });

  test('categoriza por match de frase contida', () async {
    final category = await service.categorize('pão de queijo');
    expect(category, ItemCategory.padaria);
  });

  test('categoriza por palavra simples quando não há frase completa', () async {
    final category = await service.categorize('maçã verde');
    expect(category, ItemCategory.hortifruti);
  });

  test('retorna outros para termos sem correspondência', () async {
    final category = await service.categorize('item aleatorio');
    expect(category, ItemCategory.outros);
  });

  test('prioriza termo aprendido sobre seed dictionary', () async {
    final repository = _FakeLearnedCategoryRepository();
    final categoryService = CategoryService(
      learnedCategoryRepository: repository,
    );

    await repository.upsertCategory(term: 'leite', category: 'laticinios');

    final category = await categoryService.categorize('Leite');
    expect(category, ItemCategory.laticinios);
  });
}
