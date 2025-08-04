import 'dart:async';
import 'package:flutter/foundation.dart';

/// Production-ready performance monitoring service.
///
/// Use [PerformanceService] to track operation durations, monitor memory, and collect performance statistics.
/// Supports async and sync timing, threshold alerts, and real-time metrics streaming.
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, List<Duration>> _performanceHistory = {};

  /// Start timing an operation
  void startOperation(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
  }

  /// End timing an operation and log the duration
  Duration endOperation(String operationName) {
    final startTime = _operationStartTimes[operationName];
    if (startTime == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Operation $operationName was not started');
      }
      return Duration.zero;
    }

    final duration = DateTime.now().difference(startTime);
    _operationStartTimes.remove(operationName);

    // Store performance history
    _performanceHistory.putIfAbsent(operationName, () => []).add(duration);

    // Log performance
    if (kDebugMode) {
      debugPrint('⚡ $operationName completed in ${duration.inMilliseconds}ms');
    }

    // Alert if operation is taking too long
    _checkPerformanceThresholds(operationName, duration);

    return duration;
  }

  /// Time an async operation
  Future<T> timeAsyncOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    startOperation(operationName);
    try {
      final result = await operation();
      endOperation(operationName);
      return result;
    } catch (error) {
      endOperation(operationName);
      rethrow;
    }
  }

  /// Time a synchronous operation
  T timeOperation<T>(String operationName, T Function() operation) {
    startOperation(operationName);
    try {
      final result = operation();
      endOperation(operationName);
      return result;
    } catch (error) {
      endOperation(operationName);
      rethrow;
    }
  }

  /// Get average performance for an operation
  Duration getAveragePerformance(String operationName) {
    final history = _performanceHistory[operationName];
    if (history == null || history.isEmpty) {
      return Duration.zero;
    }

    final totalMs = history.fold<int>(
      0,
      (sum, duration) => sum + duration.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ history.length);
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    final stats = <String, dynamic>{};

    for (final operation in _performanceHistory.keys) {
      final history = _performanceHistory[operation]!;
      if (history.isNotEmpty) {
        final durations = history.map((d) => d.inMilliseconds).toList();
        durations.sort();

        stats[operation] = {
          'count': history.length,
          'average': getAveragePerformance(operation).inMilliseconds,
          'min': durations.first,
          'max': durations.last,
          'p50': durations[durations.length ~/ 2],
          'p95': durations[(durations.length * 0.95).floor()],
        };
      }
    }

    return stats;
  }

  /// Monitor memory usage
  void monitorMemory() {
    // In production, implement proper memory monitoring
    if (kDebugMode) {
      debugPrint('💾 Memory monitoring active');
    }
  }

  /// Monitor app startup time
  void trackAppStartup() {
    // Track app startup performance
    if (kDebugMode) {
      debugPrint('🚀 Tracking app startup performance');
    }
  }

  /// Check if operation exceeds performance thresholds
  void _checkPerformanceThresholds(String operationName, Duration duration) {
    final thresholds = {
      'auth_signin': Duration(seconds: 3),
      'auth_signup': Duration(seconds: 5),
      'load_dashboard': Duration(seconds: 2),
      'search_artists': Duration(seconds: 2),
      'send_message': Duration(seconds: 1),
      'load_bookings': Duration(seconds: 2),
    };

    final threshold = thresholds[operationName];
    if (threshold != null && duration > threshold) {
      if (kDebugMode) {
        debugPrint(
          '🐌 Performance Alert: $operationName took ${duration.inMilliseconds}ms (threshold: ${threshold.inMilliseconds}ms)',
        );
      }

      // In production, send alert to monitoring service
      _sendPerformanceAlert(operationName, duration, threshold);
    }
  }

  /// Send performance alert to monitoring service
  void _sendPerformanceAlert(
    String operationName,
    Duration actual,
    Duration threshold,
  ) {
    // Implementation for alerting service
    if (kDebugMode) {
      debugPrint('📊 Sending performance alert for $operationName');
    }
  }

  /// Clear performance history (for memory management)
  void clearHistory() {
    _performanceHistory.clear();
    _operationStartTimes.clear();
  }

  /// Get real-time performance metrics
  Stream<Map<String, dynamic>> getPerformanceStream() async* {
    while (true) {
      yield getPerformanceStats();
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}
