import 'package:flutter/material.dart';

import '../../../../core/database/enums/item_category.dart';
import '../../../../core/database/enums/measurement_unit.dart';
import '../../domain/shopping_item.dart';
import 'category_chip.dart';

class ShoppingItemTile extends StatelessWidget {
  const ShoppingItemTile({
    required this.item,
    required this.onToggleBought,
    super.key,
  });

  final ShoppingItem item;
  final ValueChanged<bool> onToggleBought;

  @override
  Widget build(BuildContext context) {
    final bought = item.bought;

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: bought,
          onChanged: (value) => onToggleBought(value ?? false),
        ),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                decoration: bought ? TextDecoration.lineThrough : null,
                color: bought
                    ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                    : null,
              ),
        ),
        subtitle: Text('${item.quantity} ${_unitLabel(item.unit)}'),
        trailing: CategoryChip(category: _parseCategory(item.category)),
      ),
    );
  }

  ItemCategory _parseCategory(String name) {
    return ItemCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ItemCategory.outros,
    );
  }

  String _unitLabel(String unit) {
    return MeasurementUnit.values
        .firstWhere(
          (u) => u.name == unit,
          orElse: () => MeasurementUnit.unidade,
        )
        .label;
  }
}
