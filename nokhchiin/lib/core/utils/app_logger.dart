import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static void warn(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[WARN] $message${error != null ? ' | $error' : ''}');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
    // TODO: точка подключения Sentry/Crashlytics в будущем
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message${error != null ? ' | $error' : ''}');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
