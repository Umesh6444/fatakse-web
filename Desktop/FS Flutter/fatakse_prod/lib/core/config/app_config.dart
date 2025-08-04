import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/error_service.dart';
import '../services/performance_service.dart';
import '../services/cache_service.dart';
import '../config/environment.dart';

/// Production application configuration and initialization
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  bool _isInitialized = false;

  /// Initialize the application for production
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up error handling
      _setupErrorHandling();

      // Initialize services
      await _initializeServices();

      // Configure app settings
      _configureApp();

      // Set up performance monitoring
      _setupPerformanceMonitoring();

      _isInitialized = true;

      if (kDebugMode) {
        print('🚀 StageLink App initialized successfully');
        print('Environment: ${Environment.current}');
      }
    } catch (error, stackTrace) {
      ErrorService().logError(error, stackTrace, feature: 'app_initialization');
      rethrow;
    }
  }

  /// Set up global error handling
  void _setupErrorHandling() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      ErrorService().logError(
        details.exception,
        details.stack,
        feature: 'flutter_framework',
      );

      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      ErrorService().logError(error, stack, feature: 'platform');
      return true;
    };
  }

  /// Initialize core services
  Future<void> _initializeServices() async {
    final performance = PerformanceService();
    performance.startOperation('service_initialization');

    try {
      // Initialize cache service
      await CacheService().initialize();

      // Preload critical data
      await CacheService().preloadCriticalData();

      // Initialize other services as needed

      performance.endOperation('service_initialization');
    } catch (error) {
      performance.endOperation('service_initialization');
      rethrow;
    }
  }

  /// Configure app-wide settings
  void _configureApp() {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Configure system UI
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Disable debug banner in production
    if (Environment.isProduction) {
      // This would be handled in MaterialApp
    }
  }

  /// Set up performance monitoring
  void _setupPerformanceMonitoring() {
    final performance = PerformanceService();

    // Track app startup
    performance.trackAppStartup();

    // Monitor memory usage
    performance.monitorMemory();

    if (Environment.enablePerformanceMonitoring) {
      // Set up additional performance monitoring for production
      _setupProductionPerformanceMonitoring();
    }
  }

  /// Set up production-specific performance monitoring
  void _setupProductionPerformanceMonitoring() {
    // Firebase Performance Monitoring would be set up here
    // Custom performance tracking implementation
  }

  /// Get app information
  Map<String, dynamic> getAppInfo() {
    return {
      'isInitialized': _isInitialized,
      'environment': Environment.config,
      'buildMode': kDebugMode ? 'debug' : 'release',
      'platform': defaultTargetPlatform.name,
    };
  }

  /// Health check for the application
  Future<Map<String, dynamic>> healthCheck() async {
    final startTime = DateTime.now();

    try {
      // Check critical services
      final cacheHealth = await _checkCacheHealth();
      final performanceHealth = _checkPerformanceHealth();

      final duration = DateTime.now().difference(startTime);

      return {
        'status': 'healthy',
        'timestamp': startTime.toIso8601String(),
        'duration': duration.inMilliseconds,
        'services': {'cache': cacheHealth, 'performance': performanceHealth},
        'environment': Environment.current,
      };
    } catch (error) {
      return {
        'status': 'unhealthy',
        'error': error.toString(),
        'timestamp': startTime.toIso8601String(),
      };
    }
  }

  /// Check cache service health
  Future<Map<String, dynamic>> _checkCacheHealth() async {
    try {
      final stats = CacheService().getCacheStats();
      return {'status': 'healthy', 'stats': stats};
    } catch (error) {
      return {'status': 'unhealthy', 'error': error.toString()};
    }
  }

  /// Check performance service health
  Map<String, dynamic> _checkPerformanceHealth() {
    try {
      final stats = PerformanceService().getPerformanceStats();
      return {'status': 'healthy', 'stats': stats};
    } catch (error) {
      return {'status': 'unhealthy', 'error': error.toString()};
    }
  }

  /// Clean up resources
  void dispose() {
    CacheService().clearMemoryCache();
    PerformanceService().clearHistory();
  }
}
