import 'package:flutter/foundation.dart';

/// Logger estruturado do ListaGO.
///
/// Em modo debug: escreve no console via [debugPrint] (respeitando rate-limit
/// do Flutter e sendo no-op em release automaticamente).
/// Em modo release: todas as chamadas são no-op sem código gerado.
abstract final class AppLogger {
  AppLogger._();

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARN] $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('  ↳ $error');
      if (stackTrace != null) debugPrint('  ↳ $stackTrace');
    }
  }
}
