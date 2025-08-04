import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service for performance optimizations
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  // Image cache management
  final Map<String, ImageProvider> _imageCache = <String, ImageProvider>{};
  final Queue<String> _imageCacheOrder = Queue<String>();
  static const int _maxImageCacheSize = 50;

  // Widget cache for expensive builds
  final Map<String, Widget> _widgetCache = <String, Widget>{};
  static const int _maxWidgetCacheSize = 30;

  // Debounce timers
  final Map<String, Timer> _debounceTimers = <String, Timer>{};

  /// Initialize performance service
  void initialize() {
    // Set up memory management
    _setupMemoryManagement();

    // Optimize image cache
    _optimizeImageCache();
  }

  /// Setup memory management
  void _setupMemoryManagement() {
    // Clear caches when memory pressure is detected
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == AppLifecycleState.paused.toString() ||
          message == AppLifecycleState.detached.toString()) {
        clearCaches();
      }
      return null;
    });
  }

  /// Optimize image cache settings
  void _optimizeImageCache() {
    // Set image cache size based on device capabilities
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        50 * 1024 * 1024; // 50MB
  }

  /// Get cached image or create new one
  ImageProvider getCachedImage(String url, {String? cacheKey}) {
    final key = cacheKey ?? url;

    if (_imageCache.containsKey(key)) {
      // Move to end of queue (most recently used)
      _imageCacheOrder.remove(key);
      _imageCacheOrder.addLast(key);
      return _imageCache[key]!;
    }

    // Create new image provider
    final imageProvider = NetworkImage(url);

    // Add to cache
    _addToImageCache(key, imageProvider);

    return imageProvider;
  }

  /// Add image to cache with size management
  void _addToImageCache(String key, ImageProvider imageProvider) {
    // Remove oldest if cache is full
    if (_imageCache.length >= _maxImageCacheSize) {
      final oldestKey = _imageCacheOrder.removeFirst();
      _imageCache.remove(oldestKey);
    }

    _imageCache[key] = imageProvider;
    _imageCacheOrder.addLast(key);
  }

  /// Cache expensive widgets
  Widget getCachedWidget(String key, Widget Function() builder) {
    if (_widgetCache.containsKey(key)) {
      return _widgetCache[key]!;
    }

    final widget = builder();

    // Add to cache if not full
    if (_widgetCache.length < _maxWidgetCacheSize) {
      _widgetCache[key] = widget;
    }

    return widget;
  }

  /// Debounce function calls
  void debounce(String key, VoidCallback callback, Duration delay) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  /// Throttle function calls
  bool _throttleStates = false;
  void throttle(String key, VoidCallback callback, Duration interval) {
    if (_throttleStates) return;

    _throttleStates = true;
    callback();

    Timer(interval, () {
      _throttleStates = false;
    });
  }

  /// Lazy load widget with placeholder
  Widget lazyLoadWidget({
    required Widget Function() builder,
    Widget? placeholder,
    bool condition = true,
  }) {
    if (!condition) {
      return placeholder ?? const SizedBox.shrink();
    }

    return FutureBuilder<Widget>(
      future: Future.microtask(builder),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return placeholder ?? const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Create optimized list view
  Widget createOptimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsets? padding,
    double? cacheExtent,
  }) {
    return ListView.builder(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      shrinkWrap: shrinkWrap,
      padding: padding,
      cacheExtent: cacheExtent ?? 250.0, // Optimize for performance
      addAutomaticKeepAlives: false, // Don't keep widgets alive unnecessarily
      addRepaintBoundaries: true, // Improve scroll performance
    );
  }

  /// Create optimized grid view
  Widget createOptimizedGridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required SliverGridDelegate gridDelegate,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsets? padding,
  }) {
    return GridView.builder(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      gridDelegate: gridDelegate,
      shrinkWrap: shrinkWrap,
      padding: padding,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
    );
  }

  /// Create memory efficient image widget
  Widget createOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    String? cacheKey,
  }) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: getCachedImage(imageUrl, cacheKey: cacheKey),
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      imageErrorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget
          : null,
    );
  }

  /// Transparent 1x1 pixel image for placeholders
  static final Uint8List kTransparentImage = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]);

  /// Create optimized card widget
  Widget createOptimizedCard({
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    bool cacheWidget = false,
    String? cacheKey,
  }) {
    final cardWidget = Card(
      margin: margin,
      color: color,
      elevation: elevation,
      shape: shape,
      child: padding != null ? Padding(padding: padding, child: child) : child,
    );

    if (cacheWidget && cacheKey != null) {
      return getCachedWidget(cacheKey, () => cardWidget);
    }

    return cardWidget;
  }

  /// Create batched updates widget
  Widget createBatchedUpdates({
    required Widget child,
    Duration batchDuration = const Duration(milliseconds: 16),
  }) {
    return RepaintBoundary(child: child);
  }

  /// Preload critical images
  Future<void> preloadImages(
    List<String> imageUrls,
    BuildContext context,
  ) async {
    final futures = imageUrls.map((url) {
      final imageProvider = getCachedImage(url);
      return precacheImage(imageProvider, context);
    });

    await Future.wait(futures);
  }

  /// Get memory usage info
  Map<String, dynamic> getMemoryInfo() {
    return {
      'imageCache': {
        'size': _imageCache.length,
        'maxSize': _maxImageCacheSize,
        'systemCacheSize': PaintingBinding.instance.imageCache.currentSize,
        'systemCacheBytes':
            PaintingBinding.instance.imageCache.currentSizeBytes,
      },
      'widgetCache': {
        'size': _widgetCache.length,
        'maxSize': _maxWidgetCacheSize,
      },
      'debounceTimers': _debounceTimers.length,
    };
  }

  /// Clear all caches
  void clearCaches() {
    _imageCache.clear();
    _imageCacheOrder.clear();
    _widgetCache.clear();
    for (var timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();

    // Clear system image cache
    PaintingBinding.instance.imageCache.clear();
  }

  /// Dispose resources
  void dispose() {
    clearCaches();
  }
}
