import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/app_database.dart';
import 'package:listago/features/categorization/data/learned_category_repository_impl.dart';

void main() {
  late AppDatabase database;
  late LearnedCategoryRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LearnedCategoryRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('cria novo termo e atualiza frequência de existente', () async {
    await repository.upsertCategory(term: 'tomate', category: 'hortifruti');
    await repository.upsertCategory(term: 'tomate', category: 'hortifruti');

    final learned = await repository.findByTerm('tomate');

    expect(learned, isNotNull);
    expect(learned!.category, 'hortifruti');
    expect(learned.frequencyUsage, 2);
  });
}
