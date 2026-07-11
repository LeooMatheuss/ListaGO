import 'package:flutter/material.dart';

/// Tipografia base do ListaGO, compatível com Dynamic Type e MediaQuery.textScaler.
///
/// A fonte padrão do sistema é usada para evitar dependências extras e manter a
/// experiência consistente com o ambiente do usuário.
class AppTypography {
  AppTypography._();

  static TextTheme buildTextTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    return base.apply(fontFamily: null, bodyColor: null, displayColor: null);
  }
}
