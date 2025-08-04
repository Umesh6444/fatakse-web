/// Environment configuration for Fatakse
class Environment {
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Current environment (development, staging, production)
  static String get current => _environment;

  /// Check if running in development
  static bool get isDevelopment => _environment == 'development';

  /// Check if running in staging
  static bool get isStaging => _environment == 'staging';

  /// Check if running in production
  static bool get isProduction => _environment == 'production';

  /// API Base URLs
  static String get apiBaseUrl {
    switch (_environment) {
      case 'production':
        return 'https://api.fatakse.com';
      case 'staging':
        return 'https://staging-api.fatakse.com';
      case 'development':
        return 'https://dev-api.fatakse.com';
      default:
        return 'https://dev-api.fatakse.com';
    }
  }

  /// Firebase Configuration
  static String get firebaseProjectId {
    switch (_environment) {
      case 'production':
        return 'fatakse-prod';
      case 'staging':
        return 'fatakse-staging';
      default:
        return 'fatakse-dev';
    }
  }

  /// Razorpay Configuration
  static String get razorpayKeyId {
    switch (_environment) {
      case 'production':
        return const String.fromEnvironment('RAZORPAY_PROD_KEY');
      case 'staging':
        return const String.fromEnvironment('RAZORPAY_STAGING_KEY');
      default:
        return 'rzp_test_demo_key';
    }
  }

  /// Analytics Configuration
  static bool get enableAnalytics => isProduction || isStaging;

  /// Crash Reporting Configuration
  static bool get enableCrashReporting => isProduction || isStaging;

  /// Performance Monitoring
  static bool get enablePerformanceMonitoring => isProduction || isStaging;

  /// Debug Settings
  static bool get enableDebugLogs => isDevelopment;
  static bool get enableNetworkLogs => isDevelopment || isStaging;

  /// Feature Flags
  static bool get enablePayments => true;
  static bool get enableMessaging => true;
  static bool get enableBookings => true;
  static bool get enableReviews => isProduction || isStaging;
  static bool get enableNotifications => isProduction || isStaging;

  /// Cache Configuration
  static Duration get cacheExpiry {
    switch (_environment) {
      case 'production':
        return const Duration(hours: 1);
      case 'staging':
        return const Duration(minutes: 30);
      default:
        return const Duration(minutes: 5);
    }
  }

  /// Rate Limiting
  static int get maxRequestsPerMinute {
    switch (_environment) {
      case 'production':
        return 100;
      case 'staging':
        return 200;
      default:
        return 1000; // No limit for development
    }
  }

  /// App Configuration
  static String get appName {
    switch (_environment) {
      case 'staging':
        return 'StageLink (Staging)';
      case 'development':
        return 'StageLink (Dev)';
      default:
        return 'StageLink';
    }
  }

  /// Deep Link Configuration
  static String get deepLinkBaseUrl {
    switch (_environment) {
      case 'production':
        return 'https://stagelink.com';
      case 'staging':
        return 'https://staging.stagelink.com';
      default:
        return 'https://dev.stagelink.com';
    }
  }

  /// CDN Configuration
  static String get cdnBaseUrl {
    switch (_environment) {
      case 'production':
        return 'https://cdn.stagelink.com';
      case 'staging':
        return 'https://staging-cdn.stagelink.com';
      default:
        return 'https://dev-cdn.stagelink.com';
    }
  }

  /// Get all environment variables as map
  static Map<String, dynamic> get config => {
    'environment': current,
    'apiBaseUrl': apiBaseUrl,
    'firebaseProjectId': firebaseProjectId,
    'enableAnalytics': enableAnalytics,
    'enableCrashReporting': enableCrashReporting,
    'enablePerformanceMonitoring': enablePerformanceMonitoring,
    'cacheExpiry': cacheExpiry.inMinutes,
    'maxRequestsPerMinute': maxRequestsPerMinute,
    'appName': appName,
  };
}
