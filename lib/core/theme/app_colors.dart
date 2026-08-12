import 'package:flutter/material.dart';

/// Original brand palette — steel blue + safety amber, evoking
/// blueprints and site-safety signage without copying any competitor.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF1C4E80);
  static const Color primaryDark = Color(0xFF123655);
  static const Color primaryLight = Color(0xFF4E7FAE);
  static const Color accent = Color(0xFFF2A93B);
  static const Color accentDark = Color(0xFFCC8620);

  // Status
  static const Color success = Color(0xFF2E9E5B);
  static const Color warning = Color(0xFFE0A72E);
  static const Color danger = Color(0xFFD8453C);
  static const Color info = Color(0xFF3B82C4);

  // Neutrals — light theme
  static const Color lightBackground = Color(0xFFF6F7F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E5EA);
  static const Color lightTextPrimary = Color(0xFF1A1F27);
  static const Color lightTextSecondary = Color(0xFF5B6472);

  // Neutrals — dark theme
  static const Color darkBackground = Color(0xFF10151C);
  static const Color darkSurface = Color(0xFF1A212B);
  static const Color darkBorder = Color(0xFF2B3542);
  static const Color darkTextPrimary = Color(0xFFEDEFF2);
  static const Color darkTextSecondary = Color(0xFF9AA5B1);

  // Chart palette (used by dashboard/analytics later)
  static const List<Color> chartSeries = [
    primary,
    accent,
    success,
    info,
    danger,
    primaryLight,
  ];
}
