import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_theme.dart';
import '../../config/app_text_styles.dart';
import '../../core/services/accessibility_service.dart';
import '../../core/services/performance_optimization_service.dart' as perf;

/// Enhanced button widget with accessibility and performance optimizations
class AccessibleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? semanticLabel;
  final String? semanticHint;
  final ButtonStyle? style;
  final bool isEnabled;
  final bool isPrimary;
  final bool isDestructive;
  final bool showFocusIndicator;
  final EdgeInsets? padding;
  final Size? minimumSize;

  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    this.semanticHint,
    this.style,
    this.isEnabled = true,
    this.isPrimary = false,
    this.isDestructive = false,
    this.showFocusIndicator = true,
    this.padding,
    this.minimumSize,
  });

  @override
  State<AccessibleButton> createState() => _AccessibleButtonState();
}

class _AccessibleButtonState extends State<AccessibleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  bool _isHovered = false;

  final AccessibilityService _accessibilityService = AccessibilityService();
  final perf.PerformanceService _performanceService = perf.PerformanceService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _accessibilityService.getAnimationDuration(
        AppTheme.fastAnimation,
      ),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_accessibilityService.isReduceMotionEnabled) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_accessibilityService.isReduceMotionEnabled) {
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!_accessibilityService.isReduceMotionEnabled) {
      _animationController.reverse();
    }
  }

  void _handleTap() {
    _accessibilityService.provideHapticFeedback();

    if (widget.onPressed != null && widget.isEnabled) {
      widget.onPressed!();
    }

    // Announce action to screen reader
    if (widget.semanticLabel != null) {
      _accessibilityService.announceToScreenReader(
        '${widget.semanticLabel} activated',
      );
    }
  }

  Color _getButtonColor() {
    if (!widget.isEnabled) {
      return AppTheme.disabledColor;
    }

    if (widget.isDestructive) {
      return AppTheme.errorColor;
    }

    if (widget.isPrimary) {
      return AppTheme.primaryColor;
    }

    return AppTheme.surfaceColor;
  }

  Color _getTextColor() {
    final backgroundColor = _getButtonColor();
    return _accessibilityService.getAccessibleColor(
      widget.isPrimary ? Colors.white : AppTheme.textPrimary,
      backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _getButtonColor();
    final textColor = _getTextColor();

    return _performanceService.getCachedWidget(
      'accessible_button_${widget.semanticLabel}_${widget.isPrimary}',
      () => Semantics(
        label: widget.semanticLabel,
        hint: widget.semanticHint,
        button: true,
        enabled: widget.isEnabled,
        onTap: widget.isEnabled ? _handleTap : null,
        child: Focus(
          onFocusChange: (hasFocus) {
            if (mounted) {
              setState(() {
                _isFocused = hasFocus;
              });
            }
          },
          child: MouseRegion(
            onEnter: (_) {
              if (mounted) {
                setState(() => _isHovered = true);
              }
            },
            onExit: (_) {
              if (mounted) {
                setState(() => _isHovered = false);
              }
            },
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: GestureDetector(
                    onTapDown: _handleTapDown,
                    onTapUp: _handleTapUp,
                    onTapCancel: _handleTapCancel,
                    onTap: widget.isEnabled ? _handleTap : null,
                    child: AnimatedContainer(
                      duration: _accessibilityService.getAnimationDuration(
                        AppTheme.fastAnimation,
                      ),
                      constraints: BoxConstraints(
                        minWidth: widget.minimumSize?.width ?? 44.w,
                        minHeight: widget.minimumSize?.height ?? 44.h,
                      ),
                      padding:
                          widget.padding ??
                          EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: _isFocused && widget.showFocusIndicator
                            ? Border.all(color: AppTheme.focusColor, width: 2.0)
                            : Border.all(
                                color: AppTheme.borderColor,
                                width: 1.0,
                              ),
                        boxShadow: _isFocused || _isHovered
                            ? AppTheme.focusShadow
                            : AppTheme.lightShadow,
                      ),
                      child: DefaultTextStyle(
                        style: AppTextStyles.title.copyWith(
                          color: textColor,
                          fontSize: _accessibilityService.getAccessibleTextSize(
                            14.sp,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                        child: widget.child,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Enhanced text field with accessibility and performance optimizations
class AccessibleTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? semanticLabel;
  final bool isRequired;
  final bool obscureText;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;

  const AccessibleTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.semanticLabel,
    this.isRequired = false,
    this.obscureText = false,
    this.keyboardType,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
  });

  @override
  State<AccessibleTextField> createState() => _AccessibleTextFieldState();
}

class _AccessibleTextFieldState extends State<AccessibleTextField> {
  final AccessibilityService _accessibilityService = AccessibilityService();
  bool _isFocused = false;

  String get _effectiveLabel {
    if (widget.isRequired && widget.labelText != null) {
      return '${widget.labelText} (required)';
    }
    return widget.labelText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Semantics(
        label: widget.semanticLabel ?? _effectiveLabel,
        textField: true,
        child: AnimatedContainer(
          duration: _accessibilityService.getAnimationDuration(
            AppTheme.fastAnimation,
          ),
          decoration: BoxDecoration(
            boxShadow: _isFocused ? AppTheme.focusShadow : null,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: widget.controller,
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            style: AppTextStyles.body.copyWith(
              fontSize: _accessibilityService.getAccessibleTextSize(14.sp),
              color: widget.enabled
                  ? AppTheme.textPrimary
                  : AppTheme.textDisabled,
            ),
            decoration: InputDecoration(
              labelText: _effectiveLabel,
              hintText: widget.hintText,
              errorText: widget.errorText,
              filled: true,
              fillColor: widget.enabled
                  ? AppTheme.surfaceColor
                  : AppTheme.disabledColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppTheme.borderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppTheme.borderColor, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppTheme.focusColor, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppTheme.errorColor, width: 2.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              hintStyle: AppTextStyles.caption.copyWith(
                color: AppTheme.textLight,
                fontSize: _accessibilityService.getAccessibleTextSize(14.sp),
              ),
              labelStyle: AppTextStyles.body.copyWith(
                color: AppTheme.textSecondary,
                fontSize: _accessibilityService.getAccessibleTextSize(14.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Optimized image widget with accessibility support
class AccessibleImage extends StatelessWidget {
  final String imageUrl;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? cacheKey;

  const AccessibleImage({
    super.key,
    required this.imageUrl,
    this.semanticLabel,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final performanceService = perf.PerformanceService();

    return Semantics(
      image: true,
      label: semanticLabel ?? 'Image',
      child: performanceService.createOptimizedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
        cacheKey: cacheKey,
      ),
    );
  }
}
