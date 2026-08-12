import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Thin wrapper around SharedPreferences for the handful of values the
/// app needs before Firebase/Firestore are wired up: theme choice,
/// onboarding completion, and the persisted auth token/user id.
class SessionService {
  SessionService(this._prefs);
  final SharedPreferences _prefs;

  static Future<SessionService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionService(prefs);
  }

  // Theme
  String? get themeMode => _prefs.getString(AppConstants.keyThemeMode);
  Future<void> setThemeMode(String mode) => _prefs.setString(AppConstants.keyThemeMode, mode);

  // Onboarding
  bool get hasCompletedOnboarding => _prefs.getBool(AppConstants.keyOnboardingComplete) ?? false;
  Future<void> setOnboardingComplete() => _prefs.setBool(AppConstants.keyOnboardingComplete, true);

  // Session / auth
  String? get authToken => _prefs.getString(AppConstants.keyAuthToken);
  String? get currentUserId => _prefs.getString(AppConstants.keyCurrentUserId);

  Future<void> saveSession({required String token, required String userId}) async {
    await _prefs.setString(AppConstants.keyAuthToken, token);
    await _prefs.setString(AppConstants.keyCurrentUserId, userId);
  }

  Future<void> clearSession() async {
    await _prefs.remove(AppConstants.keyAuthToken);
    await _prefs.remove(AppConstants.keyCurrentUserId);
  }

  bool get hasActiveSession => authToken != null && authToken!.isNotEmpty;
}
