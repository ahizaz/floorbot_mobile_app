import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

class AppTextsTheme {
  // Get text style with system font (temporary fix for blank text issue)
  static TextStyle _textStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0.0,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontFamily: null, // Use system default font
    );
  }

  // Display text styles - largest text
  static TextStyle displayLarge = _textStyle(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium = _textStyle(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle displaySmall = _textStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
  );

  // Headline text styles
  static TextStyle headlineLarge = _textStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineMedium = _textStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = _textStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  // Title text styles
  static TextStyle titleLarge = _textStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleMedium = _textStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static TextStyle titleSmall = _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body text styles - most common text
  static TextStyle bodyLarge = _textStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = _textStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label text styles - buttons, tabs, etc.
  static TextStyle labelLarge = _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = _textStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = _textStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Custom text styles for specific use cases
  static TextStyle button = _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle caption = _textStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static TextStyle overline = _textStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );

  // Helper method to create TextTheme for MaterialApp
  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
