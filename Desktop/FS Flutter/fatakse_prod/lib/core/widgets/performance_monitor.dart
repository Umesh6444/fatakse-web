import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../services/performance_optimization_service.dart';

/// Widget for monitoring app performance in debug mode
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool showOverlay;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.showOverlay = kDebugMode,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  Timer? _timer;
  Map<String, dynamic> _performanceData = {};
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay && kDebugMode) {
      _startMonitoring();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _performanceData = PerformanceService().getMemoryInfo();
      });
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showOverlay || !kDebugMode) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,

          // Toggle button
          Positioned(
            top: 100,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: _toggleVisibility,
              backgroundColor: Colors.blue.withAlpha((0.8 * 255).toInt()),
              child: Icon(
                _isVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),

          // Performance overlay
          if (_isVisible)
            Positioned(
              top: 150,
              right: 16,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.8 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Performance Monitor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPerformanceInfo(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInfo() {
    if (_performanceData.isEmpty) {
      return const Text(
        'Loading...',
        style: TextStyle(color: Colors.white, fontSize: 10),
      );
    }

    final imageCache =
        _performanceData['imageCache'] as Map<String, dynamic>? ?? {};
    final widgetCache =
        _performanceData['widgetCache'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image Cache: ${imageCache['size']}/${imageCache['maxSize']}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        Text(
          'Widget Cache: ${widgetCache['size']}/${widgetCache['maxSize']}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        Text(
          'System Cache: ${imageCache['systemCacheSize']} items',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            PerformanceService().clearCaches();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Caches cleared')));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha((0.7 * 255).toInt()),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Clear Caches',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mixin for automatic performance optimization
mixin PerformanceOptimized<T extends StatefulWidget> on State<T> {
  final PerformanceService _performanceService = PerformanceService();

  /// Create an optimized image widget
  Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? cacheKey,
  }) {
    return _performanceService.createOptimizedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheKey: cacheKey,
    );
  }

  /// Create an optimized list view
  Widget buildOptimizedList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    EdgeInsets? padding,
  }) {
    return _performanceService.createOptimizedListView(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      controller: controller,
      padding: padding,
    );
  }

  /// Cache an expensive widget build
  Widget buildCachedWidget(String key, Widget Function() builder) {
    return _performanceService.getCachedWidget(key, builder);
  }

  /// Debounce a function call
  void debounceCall(
    String key,
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _performanceService.debounce(key, callback, delay);
  }

  @override
  void dispose() {
    // Performance service cleanup is handled globally
    super.dispose();
  }
}

/// Widget that automatically batches rebuilds for better performance
class OptimizedBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final Duration batchDuration;

  const OptimizedBuilder({
    super.key,
    required this.builder,
    this.batchDuration = const Duration(milliseconds: 16),
  });

  @override
  State<OptimizedBuilder> createState() => _OptimizedBuilderState();
}

class _OptimizedBuilderState extends State<OptimizedBuilder> {
  Timer? _rebuildTimer;
  bool _needsRebuild = false;

  void _scheduleRebuild() {
    if (_rebuildTimer?.isActive ?? false) {
      _needsRebuild = true;
      return;
    }

    _rebuildTimer = Timer(widget.batchDuration, () {
      if (_needsRebuild && mounted) {
        setState(() {});
        _needsRebuild = false;
      }
    });
  }

  @override
  void didUpdateWidget(OptimizedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleRebuild();
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: widget.builder(context));
  }
}
