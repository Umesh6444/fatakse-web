import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// Service for handling advanced accessibility features.
///
/// Use [AccessibilityService] to manage high contrast, reduce motion, screen reader, and text scaling settings.
/// Provides helpers for accessible widgets, color contrast, and haptic feedback.
class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  bool _isHighContrastEnabled = false;
  bool _isReduceMotionEnabled = false;
  bool _isScreenReaderEnabled = false;
  double _textScaleFactor = 1.0;

  // Getters
  bool get isHighContrastEnabled => _isHighContrastEnabled;
  bool get isReduceMotionEnabled => _isReduceMotionEnabled;
  bool get isScreenReaderEnabled => _isScreenReaderEnabled;
  double get textScaleFactor => _textScaleFactor;

  /// Initialize accessibility service
  Future<void> initialize() async {
    await _checkAccessibilitySettings();
    _setupAccessibilityListeners();
  }

  /// Check current accessibility settings
  Future<void> _checkAccessibilitySettings() async {
    try {
      // Check if high contrast is enabled
      final context =
          WidgetsBinding.instance.platformDispatcher.views.isNotEmpty
          ? WidgetsBinding.instance.platformDispatcher.views.first
          : null;
      if (context != null) {
        final mediaQuery = MediaQueryData.fromView(context);
        _isHighContrastEnabled = mediaQuery.highContrast;
        _isReduceMotionEnabled = mediaQuery.disableAnimations;
        _isScreenReaderEnabled = mediaQuery.accessibleNavigation;
        _textScaleFactor = mediaQuery.textScaler.scale(1.0);
      }
    } catch (e) {
      debugPrint('Error checking accessibility settings: $e');
    }
  }

  /// Setup listeners for accessibility changes
  void _setupAccessibilityListeners() {
    WidgetsBinding.instance.platformDispatcher.onAccessibilityFeaturesChanged =
        () {
          _checkAccessibilitySettings();
        };
  }

  /// Get animation duration based on reduce motion setting
  Duration getAnimationDuration(Duration defaultDuration) {
    if (_isReduceMotionEnabled) {
      return Duration.zero;
    }
    return defaultDuration;
  }

  /// Announce message to screen reader
  void announceToScreenReader(String message) {
    if (_isScreenReaderEnabled) {
      SemanticsService.announce(message, TextDirection.ltr);
    }
  }

  /// Create semantic label for better screen reader support
  String createSemanticLabel({
    required String mainText,
    String? role,
    String? state,
    String? hint,
  }) {
    final parts = <String>[mainText];

    if (role != null) parts.add(role);
    if (state != null) parts.add(state);
    if (hint != null) parts.add(hint);

    return parts.join(', ');
  }

  /// Provide haptic feedback if enabled
  void provideHapticFeedback() {
    HapticFeedback.selectionClick();
  }

  /// Get contrast ratio between two colors
  double getContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if color combination meets WCAG guidelines
  bool meetsWCAGGuidelines(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = getContrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Get accessible color variant
  Color getAccessibleColor(Color originalColor, Color backgroundColor) {
    if (meetsWCAGGuidelines(originalColor, backgroundColor)) {
      return originalColor;
    }

    // Adjust color to meet accessibility requirements
    final hsl = HSLColor.fromColor(originalColor);

    // Try making it darker first
    for (
      double lightness = hsl.lightness - 0.1;
      lightness >= 0.0;
      lightness -= 0.1
    ) {
      final adjustedColor = hsl.withLightness(lightness).toColor();
      if (meetsWCAGGuidelines(adjustedColor, backgroundColor)) {
        return adjustedColor;
      }
    }

    // If darker doesn't work, try lighter
    for (
      double lightness = hsl.lightness + 0.1;
      lightness <= 1.0;
      lightness += 0.1
    ) {
      final adjustedColor = hsl.withLightness(lightness).toColor();
      if (meetsWCAGGuidelines(adjustedColor, backgroundColor)) {
        return adjustedColor;
      }
    }

    // Fallback to high contrast colors
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  /// Create focus-friendly border
  BorderSide createFocusBorder({Color? color}) {
    return BorderSide(color: color ?? Colors.blue, width: 2.0);
  }

  /// Get accessible text size
  double getAccessibleTextSize(double baseSize) {
    return baseSize * _textScaleFactor;
  }

  /// Check if gesture is accessible (not too small)
  bool isGestureSizeAccessible(Size size) {
    const minTouchTarget = 44.0; // iOS guidelines
    return size.width >= minTouchTarget && size.height >= minTouchTarget;
  }

  /// Create accessible gesture detector
  Widget createAccessibleGestureDetector({
    required Widget child,
    required VoidCallback onTap,
    String? semanticLabel,
    String? semanticHint,
    bool excludeSemantics = false,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      excludeSemantics: excludeSemantics,
      child: GestureDetector(
        onTap: () {
          provideHapticFeedback();
          onTap();
        },
        child: Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          child: child,
        ),
      ),
    );
  }

  /// Create accessible button
  Widget createAccessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    String? semanticLabel,
    String? semanticHint,
    bool isEnabled = true,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: isEnabled,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        child: InkWell(
          onTap: isEnabled
              ? () {
                  provideHapticFeedback();
                  onPressed();
                }
              : null,
          child: Container(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Create accessible text field
  Widget createAccessibleTextField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    String? errorText,
    String? semanticLabel,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
  }) {
    final label = isRequired && labelText != null
        ? '$labelText (required)'
        : labelText;

    return Semantics(
      label: semanticLabel ?? label,
      textField: true,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
      ),
    );
  }

  /// Dispose resources
  void dispose() {
    // Clean up any listeners or resources
  }
}
