import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'error_service.dart';
import '../config/environment.dart';

/// Log levels for the application
enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3),
  critical(4);

  const LogLevel(this.value);
  final int value;

  String get name => toString().split('.').last.toUpperCase();
}

/// Production-ready logging service for application-wide logging, diagnostics, and analytics integration.
///
/// Use [LoggerService] to log debug, info, warning, error, and critical messages. Logs can be flushed to file or sent to remote services.
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  final List<LogEntry> _logBuffer = [];
  Timer? _flushTimer;
  File? _logFile;
  bool _isInitialized = false;

  /// Initialize the logger
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up log file for non-web platforms
      if (!kIsWeb) {
        await _setupLogFile();
      }

      // Start periodic flush timer
      _startFlushTimer();

      _isInitialized = true;
      info('Logger service initialized', feature: 'logger');
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to initialize logger: $error');
      }
    }
  }

  /// Set up log file
  Future<void> _setupLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().split('T').first;
      _logFile = File('${logDir.path}/stagelink_$timestamp.log');
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to setup log file: $error');
      }
    }
  }

  /// Start periodic flush timer
  void _startFlushTimer() {
    _flushTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _flushLogs(),
    );
  }

  /// Log debug message
  void debug(
    String message, {
    String? feature,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.debug, message, feature, metadata, error, stackTrace);
  }

  /// Log info message
  void info(String message, {String? feature, Map<String, dynamic>? metadata}) {
    _log(LogLevel.info, message, feature, metadata, null, null);
  }

  /// Log warning message
  void warning(
    String message, {
    String? feature,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.warning, message, feature, metadata, error, stackTrace);
  }

  /// Log error message
  void error(
    String message, {
    String? feature,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, feature, metadata, error, stackTrace);
  }

  /// Log critical message
  void critical(
    String message, {
    String? feature,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.critical, message, feature, metadata, error, stackTrace);

    // Immediately flush critical logs
    _flushLogs();
  }

  /// Internal logging method
  void _log(
    LogLevel level,
    String message,
    String? feature,
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // Skip debug logs in production
    if (Environment.isProduction && level == LogLevel.debug) {
      return;
    }

    final entry = LogEntry(
      level: level,
      message: message,
      feature: feature,
      metadata: metadata,
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    _logBuffer.add(entry);

    // Console output in debug mode
    if (kDebugMode || Environment.isDevelopment) {
      _printToConsole(entry);
    }

    // Send to external services
    _sendToExternalServices(entry);

    // Manage buffer size
    if (_logBuffer.length > 1000) {
      _flushLogs();
    }
  }

  /// Print log entry to console
  void _printToConsole(LogEntry entry) {
    final timestamp = entry.timestamp.toIso8601String();
    final feature = entry.feature != null ? '[${entry.feature}] ' : '';
    final level = '[${entry.level.name}]';

    debugPrint('$timestamp $level $feature${entry.message}');

    if (entry.error != null) {
      debugPrint('Error: ${entry.error}');
    }

    if (entry.stackTrace != null) {
      debugPrint('Stack trace: ${entry.stackTrace}');
    }

    if (entry.metadata != null && entry.metadata!.isNotEmpty) {
      debugPrint('Metadata: ${entry.metadata}');
    }
  }

  /// Send log to external services
  void _sendToExternalServices(LogEntry entry) {
    // Send to ErrorService for error tracking
    if (entry.level.value >= LogLevel.error.value && entry.error != null) {
      ErrorService().logError(
        entry.error!,
        entry.stackTrace,
        feature: entry.feature ?? 'unknown',
      );
    }

    // Track performance for critical operations
    if (entry.feature != null) {
      // Performance tracking would be implemented here
      // PerformanceService().logOperation(entry.feature!, Duration(milliseconds: 1));
    }

    // Send to analytics service (if implemented)
    _sendToAnalytics(entry);
  }

  /// Send log to analytics service
  void _sendToAnalytics(LogEntry entry) {
    // Implementation for analytics service
    // This would integrate with Firebase Analytics, Mixpanel, etc.
  }

  /// Flush logs to persistent storage
  Future<void> _flushLogs() async {
    if (_logBuffer.isEmpty) return;

    final logsToFlush = List<LogEntry>.from(_logBuffer);
    _logBuffer.clear();

    try {
      // Write to file
      if (_logFile != null) {
        await _writeLogsToFile(logsToFlush);
      }

      // Send to remote logging service
      if (Environment.isProduction) {
        await _sendLogsToRemoteService(logsToFlush);
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to flush logs: $error');
      }
    }
  }

  /// Write logs to file
  Future<void> _writeLogsToFile(List<LogEntry> logs) async {
    try {
      final sink = _logFile!.openWrite(mode: FileMode.append);

      for (final log in logs) {
        sink.writeln(log.toJson());
      }

      await sink.close();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to write logs to file: $error');
      }
    }
  }

  /// Send logs to remote service
  Future<void> _sendLogsToRemoteService(List<LogEntry> logs) async {
    // Implementation for remote logging service
    // This would send logs to services like LogRocket, Sentry, etc.
  }

  /// Get recent logs
  List<LogEntry> getRecentLogs({
    int limit = 100,
    LogLevel? minLevel,
    String? feature,
  }) {
    var filteredLogs = _logBuffer.where((log) {
      if (minLevel != null && log.level.value < minLevel.value) {
        return false;
      }
      if (feature != null && log.feature != feature) {
        return false;
      }
      return true;
    }).toList();

    // Sort by timestamp (newest first)
    filteredLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return filteredLogs.take(limit).toList();
  }

  /// Get logs by date range
  List<LogEntry> getLogsByDateRange(
    DateTime start,
    DateTime end, {
    LogLevel? minLevel,
    String? feature,
  }) {
    return _logBuffer.where((log) {
      if (log.timestamp.isBefore(start) || log.timestamp.isAfter(end)) {
        return false;
      }
      if (minLevel != null && log.level.value < minLevel.value) {
        return false;
      }
      if (feature != null && log.feature != feature) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Get log statistics
  Map<String, dynamic> getLogStats() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));

    final recentLogs = _logBuffer
        .where((log) => log.timestamp.isAfter(last24Hours))
        .toList();

    final levelCounts = <String, int>{};
    final featureCounts = <String, int>{};

    for (final log in recentLogs) {
      levelCounts[log.level.name] = (levelCounts[log.level.name] ?? 0) + 1;
      if (log.feature != null) {
        featureCounts[log.feature!] = (featureCounts[log.feature!] ?? 0) + 1;
      }
    }

    return {
      'totalLogs': _logBuffer.length,
      'recentLogs': recentLogs.length,
      'levelCounts': levelCounts,
      'featureCounts': featureCounts,
      'bufferSize': _logBuffer.length,
      'lastFlush': _flushTimer?.isActive == true ? 'Active' : 'Inactive',
    };
  }

  /// Clear logs
  void clearLogs() {
    _logBuffer.clear();
    info('Logs cleared', feature: 'logger');
  }

  /// Dispose the logger
  void dispose() {
    _flushTimer?.cancel();
    _flushLogs();
  }
}

/// Log entry data structure
class LogEntry {
  final LogLevel level;
  final String message;
  final String? feature;
  final Map<String, dynamic>? metadata;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.message,
    this.feature,
    this.metadata,
    this.error,
    this.stackTrace,
    required this.timestamp,
  });

  /// Convert to JSON for storage
  String toJson() {
    final data = <String, dynamic>{
      'level': level.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };

    if (feature != null) data['feature'] = feature!;
    if (metadata != null) data['metadata'] = metadata!;
    if (error != null) data['error'] = error.toString();
    if (stackTrace != null) data['stackTrace'] = stackTrace.toString();

    return data.toString();
  }
}
