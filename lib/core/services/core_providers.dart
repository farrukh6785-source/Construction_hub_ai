import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/network_info.dart';
import 'session_service.dart';

/// Overridden in main() once SessionService.create() resolves, so the
/// rest of the app can `ref.watch(sessionServiceProvider)` synchronously.
/// Throwing here is intentional — it means main.dart forgot the override.
final sessionServiceProvider = Provider<SessionService>((ref) {
  throw UnimplementedError('sessionServiceProvider must be overridden in main()');
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final isOnlineProvider = StreamProvider<bool>((ref) {
  return ref.watch(networkInfoProvider).onConnectivityChanged;
});

/// Seeded from SharedPreferences, then flipped in-memory the moment
/// onboarding completes so the router's redirect logic (which watches
/// this) reacts immediately — no need to wait on a stream for a value
/// that's really just a one-time local flag.
final onboardingCompleteProvider = StateProvider<bool>((ref) {
  return ref.watch(sessionServiceProvider).hasCompletedOnboarding;
});

/// Theme mode as app state, seeded from persisted preference and
/// exposed as a notifier so Settings (built later) can flip it live.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final saved = ref.read(sessionServiceProvider).themeMode;
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref.read(sessionServiceProvider).setThemeMode(mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
