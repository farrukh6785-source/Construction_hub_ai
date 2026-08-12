import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Two-font system: Inter for UI text (dense, neutral, reads well in
/// tables/dashboards), Lexend for headings (slightly warmer, more
/// distinctive — avoids the generic "default Material" look).
class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme(Color primaryText, Color secondaryText) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      displayLarge: GoogleFonts.lexend(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: primaryText,
        height: 1.15,
      ),
      displayMedium: GoogleFonts.lexend(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryText,
        height: 1.18,
      ),
      headlineLarge: GoogleFonts.lexend(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: primaryText,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.lexend(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryText,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryText,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryText,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
    );
  }
}
