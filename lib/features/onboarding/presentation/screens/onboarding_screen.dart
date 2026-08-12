import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/core_providers.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/onboarding_page.dart';

const _pages = [
  OnboardingPageData(
    icon: Icons.dashboard_customize_outlined,
    title: AppStrings.onboardTitle1,
    body: AppStrings.onboardBody1,
  ),
  OnboardingPageData(
    icon: Icons.groups_outlined,
    title: AppStrings.onboardTitle2,
    body: AppStrings.onboardBody2,
  ),
  OnboardingPageData(
    icon: Icons.auto_awesome_outlined,
    title: AppStrings.onboardTitle3,
    body: AppStrings.onboardBody3,
  ),
  OnboardingPageData(
    icon: Icons.rocket_launch_outlined,
    title: AppStrings.onboardTitle4,
    body: AppStrings.onboardBody4,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(sessionServiceProvider).setOnboardingComplete();
    // Flipping this provider is what actually moves the router on —
    // no explicit navigation call needed here.
    ref.read(onboardingCompleteProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.space16),
                child: TextButton(
                  onPressed: _complete,
                  child: const Text(AppStrings.skip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => OnboardingPage(data: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.space24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: AppConstants.animFast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppConstants.space24),
                  PrimaryButton(
                    label: isLast ? AppStrings.getStarted : AppStrings.next,
                    onPressed: () {
                      if (isLast) {
                        _complete();
                      } else {
                        _controller.nextPage(
                          duration: AppConstants.animMedium,
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
