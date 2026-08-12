import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              child: Text(
                (user?.fullName.isNotEmpty == true ? user!.fullName[0] : '?').toUpperCase(),
                style: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: AppConstants.space12),
            Text(user?.fullName ?? 'Unknown', style: theme.textTheme.headlineMedium),
            Text(user?.role.label ?? '', style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppConstants.space24),
            AppCard(
              child: Column(
                children: [
                  _ProfileRow(icon: Icons.mail_outline, label: 'Email', value: user?.email ?? '—'),
                  _ProfileRow(icon: Icons.badge_outlined, label: 'Role', value: user?.role.label ?? '—'),
                  _ProfileRow(icon: Icons.verified_outlined, label: 'Email Verified', value: (user?.emailVerified ?? false) ? 'Yes' : 'No', showDivider: false),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space24),
            Align(alignment: Alignment.centerLeft, child: Text('Achievements', style: theme.textTheme.titleMedium)),
            const SizedBox(height: AppConstants.space8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _AchievementChip(icon: Icons.emoji_events_outlined, label: '3 Projects Delivered'),
                _AchievementChip(icon: Icons.timer_outlined, label: '640 Days Active'),
                _AchievementChip(icon: Icons.thumb_up_outlined, label: 'Zero Safety Incidents'),
              ],
            ),
            const SizedBox(height: AppConstants.space32),
            OutlinedButton.icon(
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.icon, required this.label, required this.value, this.showDivider = true});
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.space8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: theme.textTheme.bodySmall?.color),
              const SizedBox(width: AppConstants.space12),
              Text(label, style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: theme.dividerColor),
      ],
    );
  }
}

class _AchievementChip extends StatelessWidget {
  const _AchievementChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 16, color: theme.colorScheme.primary),
      label: Text(label),
    );
  }
}
