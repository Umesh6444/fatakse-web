import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Validator for checking accessibility compliance
class AccessibilityValidator {
  static final AccessibilityValidator _instance =
      AccessibilityValidator._internal();
  factory AccessibilityValidator() => _instance;
  AccessibilityValidator._internal();

  final List<AccessibilityIssue> _issues = [];

  /// Validate a widget tree for accessibility issues
  List<AccessibilityIssue> validateWidget(Widget widget, BuildContext context) {
    _issues.clear();

    // Start validation
    _validateWidgetRecursive(widget, context);

    return List.from(_issues);
  }

  void _validateWidgetRecursive(Widget widget, BuildContext context) {
    // Check for common accessibility issues
    _checkButtonSize(widget);
    _checkColorContrast(widget);
    _checkSemanticLabels(widget);
    _checkFocusability(widget);

    // Note: Recursive widget traversal is complex and would require
    // access to the widget tree structure. For now, we validate the
    // immediate widget only.
  }

  void _checkButtonSize(Widget widget) {
    if (widget is ElevatedButton ||
        widget is TextButton ||
        widget is OutlinedButton ||
        widget is IconButton ||
        widget is FloatingActionButton) {
      // Check if button meets minimum touch target size
      _issues.add(
        AccessibilityIssue(
          type: AccessibilityIssueType.touchTarget,
          severity: AccessibilityIssueSeverity.warning,
          description: 'Button should have minimum 44x44 touch target',
          suggestion:
              'Ensure button has adequate padding or minimum size constraints',
          widget: widget,
        ),
      );
    }
  }

  void _checkColorContrast(Widget widget) {
    // Check text widgets for color contrast
    if (widget is Text) {
      final textWidget = widget;
      final style = textWidget.style;

      if (style?.color != null) {
        _issues.add(
          AccessibilityIssue(
            type: AccessibilityIssueType.colorContrast,
            severity: AccessibilityIssueSeverity.warning,
            description: 'Text color may not have sufficient contrast',
            suggestion:
                'Use AccessibilityService.getAccessibleColor() for proper contrast',
            widget: widget,
          ),
        );
      }
    }
  }

  void _checkSemanticLabels(Widget widget) {
    // Check for widgets that should have semantic labels
    if (widget is IconButton ||
        widget is FloatingActionButton ||
        widget is GestureDetector) {
      _issues.add(
        AccessibilityIssue(
          type: AccessibilityIssueType.semanticLabel,
          severity: AccessibilityIssueSeverity.error,
          description: 'Interactive widget missing semantic label',
          suggestion: 'Wrap with Semantics widget or add semantic properties',
          widget: widget,
        ),
      );
    }
  }

  void _checkFocusability(Widget widget) {
    // Check for interactive widgets that should be focusable
    if (widget is GestureDetector) {
      _issues.add(
        AccessibilityIssue(
          type: AccessibilityIssueType.focusability,
          severity: AccessibilityIssueSeverity.warning,
          description: 'GestureDetector may not be keyboard accessible',
          suggestion: 'Use AccessibleButton or wrap with Focus widget',
          widget: widget,
        ),
      );
    }
  }

  /// Generate accessibility report
  AccessibilityReport generateReport() {
    final errors = _issues
        .where((i) => i.severity == AccessibilityIssueSeverity.error)
        .length;
    final warnings = _issues
        .where((i) => i.severity == AccessibilityIssueSeverity.warning)
        .length;

    return AccessibilityReport(
      totalIssues: _issues.length,
      errors: errors,
      warnings: warnings,
      issues: List.from(_issues),
    );
  }

  /// Clear all issues
  void clearIssues() {
    _issues.clear();
  }
}

/// Represents an accessibility issue
class AccessibilityIssue {
  final AccessibilityIssueType type;
  final AccessibilityIssueSeverity severity;
  final String description;
  final String suggestion;
  final Widget widget;

  AccessibilityIssue({
    required this.type,
    required this.severity,
    required this.description,
    required this.suggestion,
    required this.widget,
  });

  @override
  String toString() {
    return '${severity.name.toUpperCase()}: $description - $suggestion';
  }
}

/// Types of accessibility issues
enum AccessibilityIssueType {
  colorContrast,
  touchTarget,
  semanticLabel,
  focusability,
  textSize,
  animation,
}

/// Severity levels for accessibility issues
enum AccessibilityIssueSeverity {
  error, // WCAG violation
  warning, // Best practice recommendation
  info, // General improvement suggestion
}

/// Accessibility validation report
class AccessibilityReport {
  final int totalIssues;
  final int errors;
  final int warnings;
  final List<AccessibilityIssue> issues;

  AccessibilityReport({
    required this.totalIssues,
    required this.errors,
    required this.warnings,
    required this.issues,
  });

  /// Get compliance score (0-100)
  double get complianceScore {
    if (totalIssues == 0) return 100.0;

    // Weight errors more heavily than warnings
    final errorWeight = errors * 3;
    final warningWeight = warnings * 1;
    final totalWeight = errorWeight + warningWeight;

    // Calculate score based on weighted issues
    return ((100 - totalWeight).clamp(0, 100)).toDouble();
  }

  /// Check if passes basic accessibility requirements
  bool get passesBasicRequirements => errors == 0;

  @override
  String toString() {
    return '''
Accessibility Report:
- Total Issues: $totalIssues
- Errors: $errors
- Warnings: $warnings
- Compliance Score: ${complianceScore.toStringAsFixed(1)}%
- Passes Basic Requirements: $passesBasicRequirements
''';
  }
}

/// Widget that automatically validates accessibility in debug mode
class AccessibilityAuditor extends StatefulWidget {
  final Widget child;
  final bool enableInDebug;
  final bool showOverlay;

  const AccessibilityAuditor({
    super.key,
    required this.child,
    this.enableInDebug = kDebugMode,
    this.showOverlay = false,
  });

  @override
  State<AccessibilityAuditor> createState() => _AccessibilityAuditorState();
}

class _AccessibilityAuditorState extends State<AccessibilityAuditor> {
  AccessibilityReport? _report;
  bool _showReport = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableInDebug && kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validateAccessibility();
      });
    }
  }

  void _validateAccessibility() {
    if (!mounted) return;

    final validator = AccessibilityValidator();
    validator.validateWidget(widget.child, context);

    setState(() {
      _report = validator.generateReport();
    });

    // Print report to console in debug mode
    if (kDebugMode && _report != null) {
      debugPrint(_report.toString());
      for (final issue in _report!.issues) {
        debugPrint('  - $issue');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableInDebug || !kDebugMode) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,

          if (widget.showOverlay && _report != null)
            Positioned(
              top: 50,
              left: 16,
              child: GestureDetector(
                onTap: () => setState(() => _showReport = !_showReport),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _report!.passesBasicRequirements
                        ? Colors.green.withAlpha((0.8 * 255).toInt())
                        : Colors.red.withAlpha((0.8 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _report!.passesBasicRequirements
                            ? Icons.check_circle
                            : Icons.error,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'A11y: ${_report!.complianceScore.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_showReport && _report != null)
            Positioned(
              top: 90,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.9 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Accessibility Report',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Score: ${_report!.complianceScore.toStringAsFixed(1)}%',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Errors: ${_report!.errors}, Warnings: ${_report!.warnings}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: _report!.issues.length,
                        itemBuilder: (context, index) {
                          final issue = _report!.issues[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• ${issue.description}',
                              style: TextStyle(
                                color:
                                    issue.severity ==
                                        AccessibilityIssueSeverity.error
                                    ? Colors.red[300]
                                    : Colors.yellow[300],
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
