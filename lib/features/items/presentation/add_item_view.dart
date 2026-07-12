import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/enums/item_category.dart';
import '../../../core/database/enums/measurement_unit.dart';
import '../../../core/theme/app_spacing.dart';
import 'add_item_notifier.dart';
import 'list_detail_notifier.dart';

class AddItemView extends ConsumerStatefulWidget {
  const AddItemView({super.key});

  @override
  ConsumerState<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends ConsumerState<AddItemView> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  MeasurementUnit _selectedUnit = MeasurementUnit.unidade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addItemNotifierProvider.notifier).updateText('');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final quantity = _quantityController.text.trim().isEmpty
        ? '1'
        : _quantityController.text.trim();
    final category = ref.read(addItemNotifierProvider).suggestedCategory;

    await ref
        .read(listDetailNotifierProvider.notifier)
        .adicionarItem(
          name: name,
          quantity: quantity,
          unit: _selectedUnit.name,
          category: category.name,
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addItemNotifierProvider);
    final addNotifier = ref.read(addItemNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar item')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                hintText: 'Ex.: Arroz, Leite, Detergente…',
                prefixIcon: Icon(Icons.search),
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              onChanged: addNotifier.updateText,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 3,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Unidade'),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<MeasurementUnit>(
                        value: _selectedUnit,
                        isDense: true,
                        items: MeasurementUnit.values
                            .map(
                              (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit.label),
                              ),
                            )
                            .toList(),
                        onChanged: (unit) {
                          if (unit != null) {
                            setState(() => _selectedUnit = unit);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Categoria', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: ItemCategory.values.map((category) {
                final isSelected = category == addState.suggestedCategory;
                return ChoiceChip(
                  avatar: Icon(
                    category.icon,
                    size: 16,
                    color: isSelected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                  label: Text(category.label),
                  selected: isSelected,
                  onSelected: (_) => addNotifier.confirmarCategoria(category),
                );
              }).toList(),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: _nameController,
              builder: (context, _) => FilledButton.icon(
                onPressed: _nameController.text.trim().isEmpty
                    ? null
                    : _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar à lista'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
