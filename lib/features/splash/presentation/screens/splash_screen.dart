import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.foundation_rounded, size: 72, color: theme.colorScheme.primary)
                .animate()
                .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1, 1),
              duration: AppConstants.animSlow,
              curve: Curves.easeOutBack,
            )
                .fadeIn(duration: AppConstants.animMedium),
            const SizedBox(height: AppConstants.space20),
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineMedium,
            ).animate().fadeIn(delay: AppConstants.animFast, duration: AppConstants.animMedium),
            const SizedBox(height: AppConstants.space48),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ).animate().fadeIn(delay: AppConstants.animMedium),
          ],
        ),
      ),
    );
  }
}