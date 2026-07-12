import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/app_database.dart';
import 'package:listago/features/items/data/item_repository_impl.dart';
import 'package:listago/features/lists/data/list_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ListRepositoryImpl listRepository;
  late ItemRepositoryImpl itemRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    listRepository = ListRepositoryImpl(database);
    itemRepository = ItemRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('duplicar lista copia itens e não compartilha referências', () async {
    final originalListId = await listRepository.createList(name: 'Mercado');
    await itemRepository.addItem(
      listId: originalListId,
      name: 'Arroz',
      quantity: '1',
      unit: 'kg',
      category: 'mercearia',
    );

    final duplicatedListId = await listRepository.duplicateList(originalListId);
    final duplicatedItems = await itemRepository.listItemsForList(
      duplicatedListId,
    );
    final originalItems = await itemRepository.listItemsForList(originalListId);

    expect(duplicatedItems, hasLength(1));
    expect(duplicatedItems.single.name, originalItems.single.name);
    expect(duplicatedItems.single.id, isNot(originalItems.single.id));
  });
}
