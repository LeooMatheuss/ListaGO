import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/lists/presentation/lists_home_view.dart';

void main() {
  runApp(const ProviderScope(child: ListagoApp()));
}

class ListagoApp extends StatelessWidget {
  const ListagoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListaGO',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const ListsHomeView(),
    );
  }
}
