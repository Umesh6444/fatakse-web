import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Production-ready caching service
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheExpiry = {};

  /// Initialize the cache service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Store data in memory cache with expiry
  void setMemoryCache(String key, dynamic value, {Duration? expiry}) {
    _memoryCache[key] = value;
    if (expiry != null) {
      _cacheExpiry[key] = DateTime.now().add(expiry);
    }
  }

  /// Get data from memory cache
  T? getMemoryCache<T>(String key) {
    // Check if cache has expired
    final expiry = _cacheExpiry[key];
    if (expiry != null && DateTime.now().isAfter(expiry)) {
      _memoryCache.remove(key);
      _cacheExpiry.remove(key);
      return null;
    }

    return _memoryCache[key] as T?;
  }

  /// Store data in persistent cache (SharedPreferences)
  Future<void> setPersistentCache(
    String key,
    dynamic value, {
    Duration? expiry,
  }) async {
    await _prefs?.setString(key, jsonEncode(value));

    if (expiry != null) {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await _prefs?.setInt('${key}_expiry', expiryTime);
    }
  }

  /// Get data from persistent cache
  Future<T?> getPersistentCache<T>(String key) async {
    // Check if cache has expired
    final expiryTime = _prefs?.getInt('${key}_expiry');
    if (expiryTime != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch(expiryTime);
      if (DateTime.now().isAfter(expiry)) {
        await removePersistentCache(key);
        return null;
      }
    }

    final cachedData = _prefs?.getString(key);
    if (cachedData == null) return null;

    try {
      return jsonDecode(cachedData) as T;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Error decoding cached data for key $key: $error');
      }
      return null;
    }
  }

  /// Remove data from persistent cache
  Future<void> removePersistentCache(String key) async {
    await _prefs?.remove(key);
    await _prefs?.remove('${key}_expiry');
  }

  /// Clear all memory cache
  void clearMemoryCache() {
    _memoryCache.clear();
    _cacheExpiry.clear();
  }

  /// Clear all persistent cache
  Future<void> clearPersistentCache() async {
    await _prefs?.clear();
  }

  /// Cache user profile data
  Future<void> cacheUserProfile(Map<String, dynamic> profile) async {
    debugPrint(
      '💾 Cache: Saving user profile: ${profile['id']} with role: ${profile['role']}',
    );

    try {
      // Use multiple cache strategies for web reliability
      await setPersistentCache(
        'user_profile_${profile['id']}',
        profile,
        expiry: const Duration(days: 30),
      );

      await setPersistentCache(
        'current_user_profile',
        profile,
        expiry: const Duration(days: 30),
      );

      // Additional fallback: cache the role separately for quicker access
      await setPersistentCache(
        'user_role_${profile['id']}',
        profile['role'],
        expiry: const Duration(days: 30),
      );

      // Store in memory cache as immediate fallback
      setMemoryCache(
        'user_profile_${profile['id']}',
        profile,
        expiry: const Duration(hours: 24),
      );
      setMemoryCache(
        'current_user_profile',
        profile,
        expiry: const Duration(hours: 24),
      );

      debugPrint(
        '✅ Cache: Profile saved successfully with multiple strategies',
      );
    } catch (e) {
      debugPrint('❌ Cache: Error saving profile: $e');
    }
  }

  /// Get cached user profile
  Future<Map<String, dynamic>?> getCachedUserProfile(String userId) async {
    debugPrint('🔍 Cache: Looking for user profile: $userId');

    // Strategy 1: Check memory cache first (fastest)
    var profile = getMemoryCache<Map<String, dynamic>>('user_profile_$userId');
    if (profile != null) {
      debugPrint('✅ Cache: Found in memory cache: ${profile['role']}');
      return profile;
    }

    // Strategy 2: Check persistent cache with specific user ID
    profile = await getPersistentCache<Map<String, dynamic>>(
      'user_profile_$userId',
    );

    if (profile != null) {
      debugPrint('✅ Cache: Found specific user profile: ${profile['role']}');
      // Also update memory cache for next time
      setMemoryCache(
        'user_profile_$userId',
        profile,
        expiry: const Duration(hours: 24),
      );
      return profile;
    } else {
      debugPrint('❌ Cache: No specific user profile found');
    }

    // Strategy 3: Check generic current user cache
    profile = await getPersistentCache<Map<String, dynamic>>(
      'current_user_profile',
    );
    if (profile != null) {
      debugPrint(
        '🔍 Cache: Found generic profile: ${profile['role']} for user: ${profile['id']}',
      );
      // Verify it's the right user
      if (profile['id'] != userId) {
        debugPrint('⚠️ Cache: Profile belongs to different user, ignoring');
        profile = null;
      } else {
        debugPrint('✅ Cache: Generic profile matches current user');
        // Cache it with specific user ID for next time
        setMemoryCache(
          'user_profile_$userId',
          profile,
          expiry: const Duration(hours: 24),
        );
        return profile;
      }
    } else {
      debugPrint('❌ Cache: No generic profile found either');
    }

    // Strategy 4: Check if we have just the role cached
    final cachedRole = await getPersistentCache<String>('user_role_$userId');
    if (cachedRole != null && cachedRole != 'unknown') {
      debugPrint(
        '✅ Cache: Found cached role: $cachedRole, creating basic profile',
      );
      // Create a basic profile with the cached role
      profile = {
        'id': userId,
        'role': cachedRole,
        'firstName': 'User',
        'lastName': '',
        'email': '',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'isVerified': false,
        'isActive': true,
      };
      // Cache this reconstructed profile
      setMemoryCache(
        'user_profile_$userId',
        profile,
        expiry: const Duration(hours: 24),
      );
      return profile;
    }

    if (profile != null) {
      debugPrint('✅ Cache: Returning profile with role: ${profile['role']}');
    } else {
      debugPrint('❌ Cache: No cached profile found for user: $userId');
    }

    return profile;
  }

  /// Get cached user role specifically
  Future<String?> getCachedUserRole(String userId) async {
    final profile = await getCachedUserProfile(userId);
    return profile?['role'] as String?;
  }

  /// Cache search results
  void cacheSearchResults(
    String query,
    String userRole,
    List<Map<String, dynamic>> results,
  ) {
    final key = 'search_${userRole}_${query.hashCode}';
    setMemoryCache(key, results, expiry: const Duration(minutes: 15));
  }

  /// Get cached search results
  List<Map<String, dynamic>>? getCachedSearchResults(
    String query,
    String userRole,
  ) {
    final key = 'search_${userRole}_${query.hashCode}';
    return getMemoryCache<List<Map<String, dynamic>>>(key);
  }

  /// Cache app settings
  Future<void> cacheAppSettings(Map<String, dynamic> settings) async {
    await setPersistentCache('app_settings', settings);
  }

  /// Get cached app settings
  Future<Map<String, dynamic>?> getCachedAppSettings() async {
    return await getPersistentCache<Map<String, dynamic>>('app_settings');
  }

  /// Cache network response
  void cacheNetworkResponse(
    String endpoint,
    Map<String, dynamic> response, {
    Duration? expiry,
  }) {
    setMemoryCache(
      'network_$endpoint',
      response,
      expiry: expiry ?? const Duration(minutes: 5),
    );
  }

  /// Get cached network response
  Map<String, dynamic>? getCachedNetworkResponse(String endpoint) {
    return getMemoryCache<Map<String, dynamic>>('network_$endpoint');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'memory_cache_size': _memoryCache.length,
      'memory_cache_keys': _memoryCache.keys.toList(),
      'persistent_cache_initialized': _prefs != null,
      'cache_expiry_count': _cacheExpiry.length,
    };
  }

  /// Preload critical data
  Future<void> preloadCriticalData() async {
    // Preload frequently accessed data
    if (kDebugMode) {
      debugPrint('🔄 Preloading critical cache data');
    }

    // Example: Preload app settings, user preferences, etc.
    await getCachedAppSettings();
  }
}
