import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/enums/item_category.dart';
import '../../categorization/domain/category_service.dart';
import '../../categorization/providers/learned_category_repository_provider.dart';

class AddItemNotifier extends Notifier<AddItemState> {
  late final CategoryService _categoryService;

  @override
  AddItemState build() {
    final learnedRepository = ref.read(learnedCategoryRepositoryProvider);
    _categoryService = CategoryService(
      learnedCategoryRepository: learnedRepository,
    );
    return const AddItemState();
  }

  void updateText(String value) {
    state = state.copyWith(text: value);
    _refreshSuggestion();
  }

  Future<void> _refreshSuggestion() async {
    final category = await _categoryService.categorize(state.text);
    state = state.copyWith(suggestedCategory: category);
  }

  Future<void> confirmarCategoria(ItemCategory category) async {
    if (state.text.trim().isEmpty) {
      return;
    }

    await _categoryService.learnCategory(
      rawTerm: state.text,
      category: category,
    );

    state = state.copyWith(
      suggestedCategory: category,
      confirmedCategory: category,
    );
  }
}

class AddItemState {
  const AddItemState({
    this.text = '',
    this.suggestedCategory = ItemCategory.outros,
    this.confirmedCategory = ItemCategory.outros,
  });

  final String text;
  final ItemCategory suggestedCategory;
  final ItemCategory confirmedCategory;

  AddItemState copyWith({
    String? text,
    ItemCategory? suggestedCategory,
    ItemCategory? confirmedCategory,
  }) {
    return AddItemState(
      text: text ?? this.text,
      suggestedCategory: suggestedCategory ?? this.suggestedCategory,
      confirmedCategory: confirmedCategory ?? this.confirmedCategory,
    );
  }
}

final addItemNotifierProvider = NotifierProvider<AddItemNotifier, AddItemState>(
  AddItemNotifier.new,
);
