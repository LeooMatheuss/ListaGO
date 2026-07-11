import 'package:flutter/material.dart';

/// Design tokens de cor do ListaGO.
///
/// O vermelho é usado como destaque, não como cor dominante, porque no Material
/// ele costuma carregar semântica de erro ou ação destrutiva. Mantê-lo em
/// destaque ajuda a preservar clareza visual sem conflitar com o significado de
/// ações negativas.
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFFD64545);

  static ColorScheme get light => ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      );

  static ColorScheme get dark => ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      );
}
