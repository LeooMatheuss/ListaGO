import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../items/presentation/list_detail_view.dart';
import '../../shared/presentation/widgets/empty_state_view.dart';
import 'lists_home_notifier.dart';
import 'widgets/list_card.dart';

class ListsHomeView extends ConsumerWidget {
  const ListsHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLists = ref.watch(listsHomeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas listas')),
      body: asyncLists.when(
        data: (lists) {
          if (lists.isEmpty) {
            return const EmptyStateView(
              title: 'Nenhuma lista ainda',
              message: 'Toque no botão + para criar sua primeira lista de compras.',
              icon: Icons.shopping_basket_outlined,
            );
          }

          final favorites = lists.where((l) => l.favorite).toList();
          final others = lists.where((l) => !l.favorite).toList();
          final sorted = [...favorites, ...others];

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final list = sorted[index];
              return ListCard(
                list: list,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ListDetailView(
                      listId: list.id,
                      listName: list.name,
                    ),
                  ),
                ),
                onToggleFavorite: () => ref
                    .read(listsHomeNotifierProvider.notifier)
                    .alternarFavorito(list.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyStateView(
          title: 'Não foi possível carregar',
          message: error.toString(),
          icon: Icons.error_outline,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateListDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateListDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova lista'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome da lista',
            hintText: 'Ex.: Mercado da semana',
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (_) => Navigator.of(dialogContext).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Criar'),
          ),
        ],
      ),
    );

    final name = controller.text.trim();

    if (confirmed == true && name.isNotEmpty) {
      await ref.read(listsHomeNotifierProvider.notifier).criarLista(name: name);
    }
  }
}
