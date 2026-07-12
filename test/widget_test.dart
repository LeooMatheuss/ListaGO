import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/database/app_database.dart';
import 'package:listago/main.dart';

void main() {
  testWidgets('App starts with initial home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) {
            final db = AppDatabase(NativeDatabase.memory());
            ref.onDispose(db.close);
            return db;
          }),
        ],
        child: const ListagoApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Minhas listas'), findsOneWidget);
  });
}
