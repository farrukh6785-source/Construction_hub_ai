import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';

final _currency = NumberFormat.currency(locale: 'en_US', symbol: 'PKR ', decimalDigits: 0);

class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.clientId});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(mockDataProvider);
    final client = data.clients.firstWhereOrNull((c) => c.id == clientId);
    final theme = Theme.of(context);

    if (client == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Client')),
        body: const AppEmptyWidget(title: 'Client not found'),
      );
    }

    final projects = data.projects.where((p) => p.client == client.name).toList();

    return Scaffold(
      appBar: AppBar(title: Text(client.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.company, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppConstants.space8),
                  Row(
                    children: [
                      const Icon(Icons.mail_outline, size: 16),
                      const SizedBox(width: 8),
                      Text(client.email, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 16),
                      const SizedBox(width: 8),
                      Text(client.phone, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space16),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Billed', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(_currency.format(client.totalBilled), style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.space12),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Outstanding', style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          _currency.format(client.outstanding),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: client.outstanding > 0 ? const Color(0xFFD8453C) : const Color(0xFF2E9E5B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space24),
            Text('Projects', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.space8),
            ...projects.map((p) {
              final statusName = p.status.name;
              final label = statusName[0].toUpperCase() + statusName.substring(1);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.space12),
                child: AppCard(
                  child: Row(
                    children: [
                      Expanded(child: Text(p.name, style: theme.textTheme.bodyMedium)),
                      StatusBadge(
                        label: label,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}