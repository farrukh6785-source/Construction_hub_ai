import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';

final _currency = NumberFormat.currency(locale: 'en_US', symbol: 'PKR ', decimalDigits: 0);

class LaborScreen extends ConsumerStatefulWidget {
  const LaborScreen({super.key});

  @override
  ConsumerState<LaborScreen> createState() => _LaborScreenState();
}

class _LaborScreenState extends ConsumerState<LaborScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final workers = ref.watch(mockDataProvider).workers.where((w) {
      return _query.isEmpty || w.name.toLowerCase().contains(_query.toLowerCase()) || w.role.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return ModuleListScaffold(
      title: 'Labor',
      searchHint: 'Search workers or roles',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: workers.length,
      itemBuilder: (context, i) {
        final w = workers[i];
        final theme = Theme.of(context);
        final statusColor = w.status == 'Present'
            ? const Color(0xFF2E9E5B)
            : w.status == 'On Leave'
                ? const Color(0xFFE0A72E)
                : const Color(0xFFD8453C);
        return AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Text(w.name[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(w.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text('${w.role} · ${_currency.format(w.dailyWage)}/day', style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text('${(w.attendanceRate * 100).toStringAsFixed(0)}% attendance', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              StatusBadge(label: w.status, color: statusColor),
            ],
          ),
        );
      },
    );
  }
}
