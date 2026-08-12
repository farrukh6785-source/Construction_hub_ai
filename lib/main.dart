import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/services/core_providers.dart';
import 'core/services/session_service.dart';

// This build runs entirely on in-memory mock data (see lib/mock/) —
// no backend, no API keys, no Firebase project required. The only
// thing resolved before runApp() is local device storage (theme +
// onboarding flag), via SessionService/SharedPreferences.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionService = await SessionService.create();

  runApp(
    ProviderScope(
      overrides: [
        sessionServiceProvider.overrideWithValue(sessionService),
      ],
      child: const ConstructionHubApp(),
    ),
  );
}
