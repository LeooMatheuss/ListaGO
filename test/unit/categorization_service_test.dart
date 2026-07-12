import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/enums/item_category.dart';
import 'package:listago/features/categorization/domain/category_service.dart';
import 'package:listago/features/categorization/domain/learned_category.dart';
import 'package:listago/features/categorization/domain/learned_category_repository.dart';
import 'package:listago/core/utils/text_normalizer.dart';

class _FakeLearnedCategoryRepository implements LearnedCategoryRepository {
  _FakeLearnedCategoryRepository();

  final Map<String, String> categories = <String, String>{};

  @override
  Future<LearnedCategory?> findByTerm(String term) async {
    final category = categories[term];
    if (category == null) {
      return null;
    }

    return LearnedCategory(
      id: 1,
      term: term,
      category: category,
      frequencyUsage: 1,
    );
  }

  @override
  Future<void> upsertCategory({
    required String term,
    required String category,
  }) async {
    categories[term] = category;
  }
}

void main() {
  late CategoryService service;

  setUp(() {
    service = CategoryService(
      learnedCategoryRepository: _FakeLearnedCategoryRepository(),
    );
  });

  test('normaliza texto removendo acentos e pontuação', () {
    expect(TextNormalizer.normalize('Café, pão & leite!'), 'cafe pao leite');
  });

  test('faz match exato do termo normalizado', () async {
    final category = await service.categorize('arroz');
    expect(category, ItemCategory.mercearia);
  });

  test(
    'faz match por termo mais longo quando o nome contém um termo conhecido',
    () async {
      final category = await service.categorize('peito de frango temperado');
      expect(category, ItemCategory.acougue);
    },
  );

  test('usa fallback para outros quando não encontra categoria', () async {
    final category = await service.categorize('produto totalmente inesperado');
    expect(category, ItemCategory.outros);
  });

  test(
    'prioriza a categoria aprendida pelo usuário sobre o seed dictionary',
    () async {
      final repository = _FakeLearnedCategoryRepository();
      final learnedService = CategoryService(
        learnedCategoryRepository: repository,
      );

      await learnedService.learnCategory(
        rawTerm: 'Arroz',
        category: ItemCategory.limpeza,
      );

      final category = await learnedService.categorize('arroz');
      expect(category, ItemCategory.limpeza);
    },
  );

  test('persiste categoria aprendida no repositório', () async {
    final repository = _FakeLearnedCategoryRepository();
    final learnedService = CategoryService(
      learnedCategoryRepository: repository,
    );

    await learnedService.learnCategory(
      rawTerm: 'Detergente líquido',
      category: ItemCategory.limpeza,
    );

    expect(
      repository.categories['detergente liquido'],
      ItemCategory.limpeza.name,
    );
  });
}
