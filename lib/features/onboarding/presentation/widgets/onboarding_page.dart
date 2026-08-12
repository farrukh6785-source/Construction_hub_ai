import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';

class OnboardingPageData {
  const OnboardingPageData({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.data});
  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.space32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 64, color: theme.colorScheme.primary),
          ).animate().fadeIn(duration: AppConstants.animMedium).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
              ),
          const SizedBox(height: AppConstants.space32),
          Text(
            data.title,
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: AppConstants.animFast).slideY(begin: 0.15, end: 0),
          const SizedBox(height: AppConstants.space16),
          Text(
            data.body,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: AppConstants.animMedium),
        ],
      ),
    );
  }
}
