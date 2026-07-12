import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

enum ItemCategory {
  hortifruti,
  acougue,
  laticinios,
  mercearia,
  limpeza,
  higiene,
  padaria,
  congelados,
  bebidas,
  outros,
}

extension ItemCategoryDisplay on ItemCategory {
  String get label {
    switch (this) {
      case ItemCategory.hortifruti:
        return 'Hortifruti';
      case ItemCategory.acougue:
        return 'Açougue';
      case ItemCategory.laticinios:
        return 'Laticínios';
      case ItemCategory.mercearia:
        return 'Mercearia';
      case ItemCategory.limpeza:
        return 'Limpeza';
      case ItemCategory.higiene:
        return 'Higiene';
      case ItemCategory.padaria:
        return 'Padaria';
      case ItemCategory.congelados:
        return 'Congelados';
      case ItemCategory.bebidas:
        return 'Bebidas';
      case ItemCategory.outros:
        return 'Outros';
    }
  }

  IconData get icon {
    switch (this) {
      case ItemCategory.hortifruti:
        return Icons.eco;
      case ItemCategory.acougue:
        return Icons.kebab_dining;
      case ItemCategory.laticinios:
        return Icons.icecream;
      case ItemCategory.mercearia:
        return Icons.inventory_2;
      case ItemCategory.limpeza:
        return Icons.cleaning_services;
      case ItemCategory.higiene:
        return Icons.sanitizer;
      case ItemCategory.padaria:
        return Icons.breakfast_dining;
      case ItemCategory.congelados:
        return Icons.ac_unit;
      case ItemCategory.bebidas:
        return Icons.local_drink;
      case ItemCategory.outros:
        return Icons.category;
    }
  }
}

class ItemCategoryConverter extends TypeConverter<ItemCategory, String> {
  const ItemCategoryConverter();

  @override
  ItemCategory fromSql(String fromDb) {
    return ItemCategory.values.firstWhere(
      (value) => value.name == fromDb,
      orElse: () => ItemCategory.outros,
    );
  }

  @override
  String toSql(ItemCategory value) {
    return value.name;
  }
}
