import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/core_providers.dart';

final splashReadyProvider = FutureProvider<bool>((ref) async {
  // On Flutter Web or standard platforms, safely check connectivity with a fallback timeout
  bool hasInternet = true;

  try {
    final networkInfo = ref.read(networkInfoProvider);
    // Timeout network check after 1.5 seconds if networkInfo hangs
    hasInternet = await networkInfo.isConnected.timeout(
      const Duration(milliseconds: 1500),
      onTimeout: () => true,
    );
  } catch (e) {
    debugPrint('Network check error on splash: $e');
    hasInternet = true; // Fallback so app does not hang
  }

  // Ensure minimum splash animation time completes
  await Future.delayed(AppConstants.splashMinDuration);

  return hasInternet;
});