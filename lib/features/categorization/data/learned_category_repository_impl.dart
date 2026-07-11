import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums/item_category.dart';
import '../domain/learned_category.dart' as domain_category;
import '../domain/learned_category_repository.dart';

class LearnedCategoryRepositoryImpl implements LearnedCategoryRepository {
  LearnedCategoryRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<void> upsertCategory({
    required String term,
    required String category,
  }) async {
    final existing = await (database.select(
      database.learnedCategories,
    )..where((tbl) => tbl.term.equals(term))).getSingleOrNull();

    if (existing == null) {
      await database
          .into(database.learnedCategories)
          .insert(
            LearnedCategoriesCompanion.insert(
              term: term,
              category: _parseCategory(category),
              frequencyUsage: const Value(1),
            ),
          );
      return;
    }

    await (database.update(
      database.learnedCategories,
    )..where((tbl) => tbl.id.equals(existing.id))).write(
      LearnedCategoriesCompanion(
        category: Value(_parseCategory(category)),
        frequencyUsage: Value(existing.frequencyUsage + 1),
      ),
    );
  }

  @override
  Future<domain_category.LearnedCategory?> findByTerm(String term) async {
    final row = await (database.select(
      database.learnedCategories,
    )..where((tbl) => tbl.term.equals(term))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return domain_category.LearnedCategory(
      id: row.id,
      term: row.term,
      category: row.category.name,
      frequencyUsage: row.frequencyUsage,
    );
  }

  ItemCategory _parseCategory(String value) {
    return ItemCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ItemCategory.outros,
    );
  }
}
