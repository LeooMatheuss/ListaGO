import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:listago/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'fluxo completo de criar lista, adicionar itens e marcar como comprado',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: ListagoApp()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Mercado');
      await tester.tap(find.text('Criar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mercado'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Arroz');
      await tester.tap(find.text('Adicionar à lista'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Leite');
      await tester.tap(find.text('Adicionar à lista'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(find.text('50%'), findsOneWidget);
    },
  );
}
