import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/app_database.dart';
import 'package:listago/features/categorization/data/product_memory_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ProductMemoryRepositoryImpl repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ProductMemoryRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'registra uso de produto sem duplicar histórico para o mesmo nome',
    () async {
      await repository.registerUsage(
        normalizedName: 'maca',
        category: 'hortifruti',
      );
      await repository.registerUsage(
        normalizedName: 'maca',
        category: 'hortifruti',
      );

      final history = await repository.historyFor('maca');

      expect(history, hasLength(1));
      expect(history.single.associatedCategory, 'hortifruti');
    },
  );
}
