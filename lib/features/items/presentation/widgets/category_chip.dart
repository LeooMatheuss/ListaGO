import 'package:flutter/material.dart';

import '../../../../core/database/enums/item_category.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.category, this.onTap, super.key});

  final ItemCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      onPressed: onTap,
      avatar: Icon(
        category.icon,
        size: 16,
        color: colorScheme.onSecondaryContainer,
      ),
      label: Text(
        category.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
            ),
      ),
      backgroundColor: colorScheme.secondaryContainer,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
