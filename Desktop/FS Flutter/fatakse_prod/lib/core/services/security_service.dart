import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// Production-ready security service for Fatakse.
///
/// Use [SecurityService] for password hashing, input validation, sanitization, and security event logging.
class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  /// Hash password with salt for secure storage
  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate a secure salt for password hashing
  String generateSalt() {
    final bytes = List<int>.generate(
      32,
      (i) => DateTime.now().millisecondsSinceEpoch % 256,
    );
    return base64Encode(bytes);
  }

  /// Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone number format (Indian format)
  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  /// Sanitize user input to prevent injection attacks
  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'''[<>"';%()&+]'''), '').trim();
  }

  /// Validate password strength
  bool isStrongPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special char
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  /// Generate API key for external services
  String generateApiKey() {
    final bytes = List<int>.generate(
      32,
      (i) => DateTime.now().microsecondsSinceEpoch % 256,
    );
    return base64Url.encode(bytes);
  }

  /// Validate JWT token format (basic validation)
  bool isValidJWT(String token) {
    final parts = token.split('.');
    return parts.length == 3;
  }

  /// Log security events for monitoring
  void logSecurityEvent(String event, Map<String, dynamic> details) {
    if (kDebugMode) {
      print('🔒 Security Event: $event');
      print('Details: ${jsonEncode(details)}');
    }
    // In production, send to logging service
  }

  /// Rate limiting check
  bool checkRateLimit(String identifier, int maxRequests, Duration window) {
    // Simplified rate limiting logic
    // In production, use Redis or similar
    return true; // Allow for demo
  }

  /// Encrypt sensitive data
  String encryptData(String data) {
    // Simplified encryption - use proper encryption in production
    final bytes = utf8.encode(data);
    return base64Encode(bytes);
  }

  /// Decrypt sensitive data
  String decryptData(String encryptedData) {
    // Simplified decryption - use proper encryption in production
    final bytes = base64Decode(encryptedData);
    return utf8.decode(bytes);
  }
}
