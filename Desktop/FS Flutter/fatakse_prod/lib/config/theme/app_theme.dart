import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MaterialColor(0xFF6C5CE7, {
      50: Color(0xFFF3F1FF),
      100: Color(0xFFE4DFFF),
      200: Color(0xFFCCC4FF),
      300: Color(0xFFB4A8FF),
      400: Color(0xFF9C8CFF),
      500: Color(0xFF6C5CE7),
      600: Color(0xFF5B4BC4),
      700: Color(0xFF4A3AA1),
      800: Color(0xFF39297E),
      900: Color(0xFF28185B),
    }),
    primaryColor: primaryColor,
    primaryColorDark: primaryDarkColor,
    primaryColorLight: primaryLightColor,
    scaffoldBackgroundColor: Color(0xFF060523),
    cardColor: Color(0xFF181828),
    dividerColor: dividerColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF181828),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: textPrimaryDark,
      ),
      bodySmall: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: textSecondaryDark,
      ),
      labelLarge: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      labelMedium: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
      labelSmall: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: textLightDark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF181828),
      elevation: 2,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.all(8.w),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF23233A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      hintStyle: TextStyle(color: textLightDark, fontSize: 14.sp),
      labelStyle: TextStyle(color: textSecondaryDark, fontSize: 14.sp),
    ),
    iconTheme: IconThemeData(color: textPrimaryDark, size: 24.w),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF181828),
      selectedItemColor: primaryColor,
      unselectedItemColor: textLightDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF23233A),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryLightColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(fontSize: 12.sp, color: textPrimaryDark),
      secondaryLabelStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF23233A),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      contentTextStyle: TextStyle(fontSize: 14.sp, color: textSecondaryDark),
    ),
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: Color(0xFF181828),
          error: errorColor,
        ),
  );
  // Brand Colors (Fatakse theme - teal primary)
  static const Color primaryColor = Color(0xFF00CFC8); // Teal as primary
  static const Color primaryDarkColor = Color(0xFF00B8B0);
  static const Color primaryLightColor = Color(0xFF33E3DD);

  // Accent red (for errors and critical actions)
  static const Color secondaryColor = Color(
    0xFFE63946,
  ); // Muted red for accents
  static const Color secondaryDarkColor = Color(0xFFD62D20);
  static const Color secondaryLightColor = Color(0xFFFF6B6B);

  // Logo-inspired colors
  static const Color logoBlack = Color(0xFF1A1A1A); // Deep black from logo
  static const Color logoGrey = Color(0xFF2A2A2A); // Medium grey from logo
  static const Color logoSilver = Color(0xFF8A8A8A); // Light grey from logo

  // Creative Palette
  static const Color accentColor = Color(0xFF7B5CFF); // Royal purple
  static const Color accentDarkColor = Color(0xFF6B4DE6);
  static const Color accentLightColor = Color(0xFF9B7AFF);

  // Background colors - Dark theme
  static const Color backgroundColor = Color(
    0xFF060523,
  ); // Dark purple background
  static const Color surfaceColor = Color(0xFF1E1E2D); // Dark surface
  static const Color cardColor = Color(0xFF2A2A3E); // Dark cards

  // Text colors - Dark theme
  static const Color textPrimary = Color(
    0xFFFFFFFF,
  ); // White text for dark backgrounds
  static const Color textSecondary = Color(
    0xFFE0E0E0,
  ); // Light gray for dark backgrounds
  static const Color textLight = Color(
    0xFFB0B0B0,
  ); // Medium gray for dark backgrounds
  static const Color textDisabled = Color(0xFF666666);

  // For dark backgrounds, use these colors
  static const Color textPrimaryDark = Color(
    0xFFFFFFFF,
  ); // White text for dark backgrounds
  static const Color textSecondaryDark = Color(
    0xFFE0E0E0,
  ); // Light gray for dark backgrounds
  static const Color textLightDark = Color(
    0xFFB0B0B0,
  ); // Medium gray for dark backgrounds

  // Status colors - enhanced palette
  static const Color successColor = Color(0xFF39FF14); // Neon green
  static const Color warningColor = Color(0xFFFFE066); // Cyber yellow
  static const Color errorColor = Color(0xFFE63946); // Accent red
  static const Color infoColor = Color(0xFF007BFF); // Electric blue

  // Border and UI colors - Dark theme
  static const Color borderColor = Color(0xFF404040);
  static const Color dividerColor = Color(0xFF404040);
  static const Color outline = Color(0xFF404040);

  // Surface Colors
  static const Color surface = surfaceColor;
  static const Color surfaceVariant = cardColor;

  // Shadow Colors
  static const Color shadowColor = Color(0x40000000);
  static const Color lightShadowColor = Color(0x20000000);

  // Artist Role Colors - Optimized for WCAG AA compliance
  static const Color artistColor = Color(0xFF6C5CE7);
  static const Color clientColor = Color(
    0xFF008B75,
  ); // Even darker teal for AA compliance
  static const Color vendorColor = Color(
    0xFFD32F2F,
  ); // Darker red for AA compliance
  static const Color plannerColor = Color(
    0xFF00695C,
  ); // Darker cyan for AA compliance
  static const Color productionColor = Color(
    0xFFE65100,
  ); // Much darker orange for AA compliance

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    primarySwatch: MaterialColor(0xFF6C5CE7, {
      50: Color(0xFFF3F1FF),
      100: Color(0xFFE4DFFF),
      200: Color(0xFFCCC4FF),
      300: Color(0xFFB4A8FF),
      400: Color(0xFF9C8CFF),
      500: Color(0xFF6C5CE7),
      600: Color(0xFF5B4BC4),
      700: Color(0xFF4A3AA1),
      800: Color(0xFF39297E),
      900: Color(0xFF28185B),
    }),
    primaryColor: primaryColor,
    primaryColorDark: primaryDarkColor,
    primaryColorLight: primaryLightColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Text Theme - Better contrast
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: textLight,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor, width: 1.5),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.all(8.w),
    ),

    // Input Decoration Theme - Dark theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2A2A3E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      hintStyle: TextStyle(color: textLight, fontSize: 14.sp),
      labelStyle: TextStyle(color: textSecondary, fontSize: 14.sp),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: textPrimary, size: 24.w),

    // Bottom Navigation Bar Theme - Dark theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E2D),
      selectedItemColor: primaryColor,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFFF1F3F4),
      selectedColor: primaryColor,
      secondarySelectedColor: primaryLightColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),

    // Dialog Theme - Dark theme
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF2A2A3E),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      contentTextStyle: TextStyle(fontSize: 14.sp, color: textSecondary),
    ),

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          error: errorColor,
        ),
  );

  // Get role color with accessibility variants
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'artist':
        return artistColor;
      case 'household_client':
      case 'corporate_client':
        return clientColor;
      case 'vendor':
        return vendorColor;
      case 'event_planner':
        return plannerColor;
      case 'production_house':
        return productionColor;
      default:
        return primaryColor;
    }
  }

  // Get role color with guaranteed contrast for text overlay
  static Color getRoleColorDark(String role) {
    switch (role.toLowerCase()) {
      case 'artist':
        return const Color(0xFF5B4BC4); // Darker artist color
      case 'household_client':
      case 'corporate_client':
        return const Color(0xFF006B5B); // Even darker client color
      case 'vendor':
        return const Color(0xFFB71C1C); // Darker vendor color
      case 'event_planner':
        return const Color(0xFF00695C); // Darker planner color
      case 'production_house':
        return const Color(0xFFBF360C); // Much darker production color
      default:
        return primaryDarkColor;
    }
  }

  // Accessibility helpers
  static bool isHighContrastMode(BuildContext context) {
    // Uses MediaQuery highContrast and platform brightness for robust detection
    final mq = MediaQuery.maybeOf(context);
    if (mq != null && mq.highContrast) return true;
    final brightness = mq?.platformBrightness ?? Brightness.light;
    // Optionally, add more heuristics for accessibility
    return brightness == Brightness.dark;
  }

  static Color getAccessibleTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? logoBlack : textPrimary;
  }

  static Color getAccessibleAccentColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? primaryColor : primaryLightColor;
  }

  // Semantic colors for accessibility
  static const Color focusColor = Color(0xFF2196F3);
  static const Color selectedColor = Color(0xFF4CAF50);
  static const Color disabledColor = Color(0xFF9E9E9E);

  // Animation durations for accessibility
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Common shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: shadowColor,
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: lightShadowColor,
      offset: const Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> focusShadow = [
    BoxShadow(
      color: focusColor.withValues(alpha: 0.3),
      offset: const Offset(0, 0),
      blurRadius: 8,
      spreadRadius: 2,
    ),
  ];
}
