import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextsTheme {
  // Display text styles - largest text
  static TextStyle displayLarge = GoogleFonts.oswald(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium = GoogleFonts.oswald(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle displaySmall = GoogleFonts.oswald(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
  );

  // Headline text styles
  static TextStyle headlineLarge = GoogleFonts.oswald(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineMedium = GoogleFonts.oswald(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineSmall = GoogleFonts.oswald(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  // Title text styles
  static TextStyle titleLarge = GoogleFonts.oswald(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleMedium = GoogleFonts.oswald(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall = GoogleFonts.oswald(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body text styles - most common text
  static TextStyle bodyLarge = GoogleFonts.oswald(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = GoogleFonts.oswald(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = GoogleFonts.oswald(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label text styles - buttons, tabs, etc.
  static TextStyle labelLarge = GoogleFonts.oswald(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.oswald(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.oswald(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Custom text styles for specific use cases
  static TextStyle button = GoogleFonts.oswald(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle caption = GoogleFonts.oswald(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  static TextStyle overline = GoogleFonts.oswald(
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
