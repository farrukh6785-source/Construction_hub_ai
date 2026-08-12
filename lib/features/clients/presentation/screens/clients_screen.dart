import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../mock/mock_data_service.dart';

final _currency = NumberFormat.compactCurrency(locale: 'en_US', symbol: 'PKR ');

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(mockDataProvider).clients.where((c) {
      return _query.isEmpty || c.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return ModuleListScaffold(
      title: 'Clients',
      searchHint: 'Search clients',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: clients.length,
      itemBuilder: (context, i) {
        final c = clients[i];
        final theme = Theme.of(context);
        return AppCard(
          onTap: () => context.push(Routes.clientDetail(c.id)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Text(c.name[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text('${c.activeProjects} active project${c.activeProjects == 1 ? '' : 's'}', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_currency.format(c.totalBilled), style: theme.textTheme.bodyMedium),
                  Text(
                    c.outstanding > 0 ? '${_currency.format(c.outstanding)} due' : 'Paid up',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: c.outstanding > 0 ? const Color(0xFFD8453C) : const Color(0xFF2E9E5B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
