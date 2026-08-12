/// Central place for magic numbers and keys used across the app.
/// Keeping these here means changing a spacing/radius value once
/// updates it everywhere — no hunting through 100 screens later.
class AppConstants {
  AppConstants._();

  static const String appName = 'ConstructionHub AI';

  // Persisted storage keys
  static const String keyThemeMode = 'settings.theme_mode';
  static const String keyOnboardingComplete = 'onboarding.complete';
  static const String keyAuthToken = 'session.auth_token';
  static const String keyCurrentUserId = 'session.user_id';

  // Animation durations
  static const Duration splashMinDuration = Duration(milliseconds: 1400);
  static const Duration animFast = Duration(milliseconds: 180);
  static const Duration animMedium = Duration(milliseconds: 320);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Spacing scale (use multiples of 4)
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space48 = 48;
  static const double space96 = 96;

  // Radii
  static const double radiusSmall = 8;
  static const double radiusMedium = 14;
  static const double radiusLarge = 20;
  static const double radiusPill = 999;

  // Responsive breakpoints (logical pixels)
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 1024;
  static const double breakpointDesktop = 1440;
}
