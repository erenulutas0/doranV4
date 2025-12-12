import 'package:flutter/foundation.dart';

/// Lightweight RUM-style logger that only prints to console (no backend dependency).
/// Use this to trace API latency/error quickly without external tooling.
class RumLogger {
  /// Log an API call result with duration and optional error.
  static void logApi({
    required String name,
    required int durationMs,
    int? statusCode,
    String? error,
  }) {
    if (!kDebugMode) return;
    final statusPart = statusCode != null ? 'status=$statusCode ' : '';
    final errorPart = error != null ? 'error=$error ' : '';
    debugPrint('🕒 RUM [$name] ${durationMs}ms ${statusPart}${errorPart}'.trim());
  }
}

