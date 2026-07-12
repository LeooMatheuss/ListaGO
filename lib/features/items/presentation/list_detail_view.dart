import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/enums/item_category.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../shared/presentation/widgets/empty_state_view.dart';
import '../domain/shopping_item.dart';
import 'add_item_view.dart';
import 'list_detail_notifier.dart';
import 'widgets/shopping_item_tile.dart';

class ListDetailView extends ConsumerStatefulWidget {
  const ListDetailView({
    required this.listId,
    required this.listName,
    super.key,
  });

  final int listId;
  final String listName;

  @override
  ConsumerState<ListDetailView> createState() => _ListDetailViewState();
}

class _ListDetailViewState extends ConsumerState<ListDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(listDetailNotifierProvider.notifier)
          .configureList(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(listDetailNotifierProvider.notifier);
    final asyncItems = ref.watch(listDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.listName)),
      body: asyncItems.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyStateView(
              title: 'Nenhum item ainda',
              message: 'Adicione seu primeiro produto à lista.',
              icon: Icons.add_shopping_cart_outlined,
            );
          }

          final grouped = _groupByCategory(items);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: _ProgressBar(percent: notifier.progressPercent),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.xxl,
                  ),
                  children: [
                    for (final entry in grouped.entries) ...[
                      _CategoryHeader(category: entry.key),
                      for (final item in entry.value)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ShoppingItemTile(
                            item: item,
                            onToggleBought: (value) async {
                              await notifier.marcarComprado(
                                item.id,
                                bought: value,
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const EmptyStateView(
          title: 'Não foi possível carregar os itens',
          message: 'Ocorreu um erro inesperado. Tente novamente.',
          icon: Icons.error_outline,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const AddItemView())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Map<ItemCategory, List<ShoppingItem>> _groupByCategory(
    List<ShoppingItem> items,
  ) {
    final result = <ItemCategory, List<ShoppingItem>>{};
    for (final category in ItemCategory.values) {
      final categoryItems = items
          .where((item) => item.category == category.name)
          .toList();
      if (categoryItems.isNotEmpty) {
        result[category] = categoryItems;
      }
    }
    return result;
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = '${(percent * 100).toStringAsFixed(0)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso da compra',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});

  final ItemCategory category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(category.icon, size: 16, color: colorScheme.secondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            category.label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
