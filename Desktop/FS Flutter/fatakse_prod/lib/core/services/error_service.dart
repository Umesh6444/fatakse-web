import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Production-ready error handling and logging service.
///
/// Use [ErrorService] to log errors, user actions, and performance metrics. Integrates with Crashlytics and Firebase Analytics.

class ErrorService {
  final FirebaseCrashlytics? crashlytics;
  static ErrorService? _instance;
  factory ErrorService({FirebaseCrashlytics? crashlytics}) =>
      _instance ??= ErrorService._internal(crashlytics: crashlytics);
  ErrorService._internal({this.crashlytics});

  /// Log errors with context
  void logError(
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, Object>? context,
    String? userId,
    String? feature,
  }) {
    final errorData = <String, Object>{
      'timestamp': DateTime.now().toIso8601String(),
      'error': error.toString(),
      'stackTrace': stackTrace?.toString() ?? '',
      if (userId != null) 'userId': userId,
      if (feature != null) 'feature': feature,
      'platform': _getPlatform(),
      if (context != null) 'context': context,
    };

    if (kDebugMode) {
      debugPrint('🚨 Error Logged: ${errorData['error']}');
      debugPrint('Feature: ${errorData['feature']}');
      debugPrint('Context: ${errorData['context']}');
    }

    // In production, send to crash analytics service like Crashlytics
    _sendToCrashlytics(errorData);
  }

  /// Log user actions for analytics
  void logUserAction(
    String action,
    String userId, {
    Map<String, Object>? properties,
  }) {
    final actionData = <String, Object>{
      'timestamp': DateTime.now().toIso8601String(),
      'action': action,
      'userId': userId,
      'platform': _getPlatform(),
    };
    // Only add properties if all values are String or num
    if (properties != null) {
      final filtered = <String, Object>{};
      properties.forEach((key, value) {
        if (value is String || value is num) {
          filtered[key] = value;
        } else {
          filtered[key] = value.toString();
        }
      });
      actionData.addAll(filtered);
    }

    if (kDebugMode) {
      debugPrint('📊 User Action: ${actionData['action']}');
      debugPrint('User: ${actionData['userId']}');
    }

    // In production, send to analytics service
    _sendToAnalytics(actionData);
  }

  /// Log performance metrics
  void logPerformance(
    String operation,
    Duration duration, {
    Map<String, Object>? metadata,
  }) {
    final performanceData = <String, Object>{
      'timestamp': DateTime.now().toIso8601String(),
      'operation': operation,
      'duration': duration.inMilliseconds,
      if (metadata != null) 'metadata': metadata,
      'platform': _getPlatform(),
    };

    if (kDebugMode) {
      debugPrint('⚡ Performance: $operation took ${duration.inMilliseconds}ms');
    }

    // In production, send to performance monitoring
    _sendToPerformanceMonitoring(performanceData);
  }

  /// Handle network errors
  String getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'Please check your internet connection and try again.';
    } else if (error is HttpException) {
      return 'Server error occurred. Please try again later.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  /// Handle authentication errors
  String getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  /// Get platform information
  String _getPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Send error data to crash analytics (Crashlytics)
  void _sendToCrashlytics(Map<String, Object> errorData) {
    // Only send to Crashlytics on non-web platforms
    if (!kIsWeb && crashlytics != null) {
      crashlytics!.recordError(
        errorData['error'],
        null,
        reason: errorData['feature']?.toString(),
        information: [errorData],
      );
    }
  }

  /// Send user action data to analytics
  void _sendToAnalytics(Map<String, Object> actionData) {
    // Send event to Firebase Analytics
    FirebaseAnalytics.instance.logEvent(
      name: actionData['action']?.toString() ?? 'action',
      parameters: actionData,
    );
  }

  /// Send performance data to monitoring service
  void _sendToPerformanceMonitoring(Map<String, Object> performanceData) {
    // Implementation for Firebase Performance or similar
    // FirebasePerformance.instance.newTrace(...)
  }

  /// Create custom exception for business logic errors
  Exception createBusinessException(String message, {String? code}) {
    return BusinessException(message, code: code);
  }
}

/// Custom exception for business logic errors
class BusinessException implements Exception {
  final String message;
  final String? code;

  const BusinessException(this.message, {this.code});

  @override
  String toString() =>
      'BusinessException: $message${code != null ? ' (Code: $code)' : ''}';
}
