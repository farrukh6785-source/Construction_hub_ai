import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../mock/mock_data_service.dart';

final _time = DateFormat('MMM d, h:mm a');

IconData _iconForType(String type) => switch (type) {
      'task' => Icons.checklist_outlined,
      'budget' => Icons.account_balance_wallet_outlined,
      'stock' => Icons.inventory_2_outlined,
      'delay' => Icons.trending_down_rounded,
      'client' => Icons.handshake_outlined,
      _ => Icons.auto_awesome_outlined,
    };

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(mockDataProvider);
    final notifications = data.notifications;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (data.unreadNotificationsCount > 0)
            TextButton(onPressed: () => data.markAllNotificationsRead(), child: const Text('Mark all read')),
        ],
      ),
      body: notifications.isEmpty
          ? const AppEmptyWidget(title: 'No notifications', icon: Icons.notifications_none)
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.space16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppConstants.space12),
              itemBuilder: (context, i) {
                final n = notifications[i];
                return AppCard(
                  onTap: () => data.markNotificationRead(n.id),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: n.read ? 0.06 : 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_iconForType(n.type), size: 16, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: AppConstants.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: n.read ? FontWeight.normal : FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(n.body, style: theme.textTheme.bodySmall),
                            const SizedBox(height: 4),
                            Text(_time.format(n.time), style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (!n.read)
                        Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: Color(0xFF3B82C4), shape: BoxShape.circle)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
