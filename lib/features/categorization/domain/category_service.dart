import '../../../core/database/enums/item_category.dart';
import '../../../core/utils/text_normalizer.dart';
import '../data/category_seed_data.dart';
import 'learned_category_repository.dart';

class CategoryService {
  CategoryService({required this.learnedCategoryRepository});

  final LearnedCategoryRepository learnedCategoryRepository;

  Future<ItemCategory> categorize(String rawTerm) async {
    final normalizedTerm = TextNormalizer.normalize(rawTerm);

    if (normalizedTerm.isEmpty) {
      return ItemCategory.outros;
    }

    final learnedCategory = await learnedCategoryRepository.findByTerm(
      normalizedTerm,
    );
    if (learnedCategory != null) {
      return _parseCategory(learnedCategory.category);
    }

    final exactMatch = _matchExact(normalizedTerm);
    if (exactMatch != null) {
      return exactMatch;
    }

    final longestContainedMatch = _matchLongestContained(normalizedTerm);
    if (longestContainedMatch != null) {
      return longestContainedMatch;
    }

    final singleWordMatch = _matchSingleWord(normalizedTerm);
    if (singleWordMatch != null) {
      return singleWordMatch;
    }

    return ItemCategory.outros;
  }

  Future<void> learnCategory({
    required String rawTerm,
    required ItemCategory category,
  }) async {
    final normalizedTerm = TextNormalizer.normalize(rawTerm);
    await learnedCategoryRepository.upsertCategory(
      term: normalizedTerm,
      category: category.name,
    );
  }

  ItemCategory? _matchExact(String normalizedTerm) {
    for (final entry in categorySeedData.entries) {
      final terms = entry.value.map(TextNormalizer.normalize).toList();
      if (terms.contains(normalizedTerm)) {
        return entry.key;
      }
    }
    return null;
  }

  ItemCategory? _matchLongestContained(String normalizedTerm) {
    final candidates = <String>[];

    for (final entry in categorySeedData.entries) {
      for (final seedTerm in entry.value) {
        final normalizedSeed = TextNormalizer.normalize(seedTerm);
        if (normalizedSeed.isEmpty) {
          continue;
        }

        if (normalizedSeed.length >= 3 &&
            normalizedSeed.split(' ').length <= 3 &&
            _containsAsPhrase(normalizedTerm, normalizedSeed)) {
          candidates.add(normalizedSeed);
        }
      }
    }

    if (candidates.isEmpty) {
      return null;
    }

    candidates.sort((a, b) => b.length.compareTo(a.length));
    final bestCandidate = candidates.first;

    for (final entry in categorySeedData.entries) {
      final terms = entry.value.map(TextNormalizer.normalize).toList();
      if (terms.contains(bestCandidate)) {
        return entry.key;
      }
    }

    return null;
  }

  ItemCategory? _matchSingleWord(String normalizedTerm) {
    final words = normalizedTerm.split(' ').where((word) => word.isNotEmpty).toList();
    for (final word in words) {
      final match = _matchExact(word);
      if (match != null) {
        return match;
      }
    }
    return null;
  }

  bool _containsAsPhrase(String haystack, String needle) {
    final haystackWords = haystack.split(' ').where((word) => word.isNotEmpty).toList();
    final needleWords = needle.split(' ').where((word) => word.isNotEmpty).toList();

    if (needleWords.isEmpty || needleWords.length > haystackWords.length) {
      return false;
    }

    for (var start = 0; start <= haystackWords.length - needleWords.length; start++) {
      var found = true;
      for (var index = 0; index < needleWords.length; index++) {
        if (haystackWords[start + index] != needleWords[index]) {
          found = false;
          break;
        }
      }
      if (found) {
        return true;
      }
    }

    return false;
  }

  ItemCategory _parseCategory(String value) {
    return ItemCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ItemCategory.outros,
    );
  }
}
