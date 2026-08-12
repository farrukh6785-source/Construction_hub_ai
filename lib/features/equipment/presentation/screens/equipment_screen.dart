import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';

final _date = DateFormat('MMM d, yyyy');

class EquipmentScreen extends ConsumerStatefulWidget {
  const EquipmentScreen({super.key});

  @override
  ConsumerState<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends ConsumerState<EquipmentScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(mockDataProvider).equipment.where((e) {
      return _query.isEmpty || e.name.toLowerCase().contains(_query.toLowerCase()) || e.type.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return ModuleListScaffold(
      title: 'Equipment',
      searchHint: 'Search equipment',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final e = items[i];
        final theme = Theme.of(context);
        final statusColor = switch (e.status) {
          'Available' => const Color(0xFF2E9E5B),
          'In Use' => const Color(0xFF3B82C4),
          _ => const Color(0xFFD8453C),
        };
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.precision_manufacturing_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: AppConstants.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.name, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
                        Text(e.type, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  StatusBadge(label: e.status, color: statusColor),
                ],
              ),
              const SizedBox(height: AppConstants.space12),
              Row(
                children: [
                  Icon(Icons.local_gas_station_outlined, size: 14, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 4),
                  Text('${(e.fuelLevel * 100).toStringAsFixed(0)}% fuel', style: theme.textTheme.bodySmall),
                  const SizedBox(width: AppConstants.space16),
                  Icon(Icons.build_outlined, size: 14, color: theme.textTheme.bodySmall?.color),
                  const SizedBox(width: 4),
                  Text('Next service ${_date.format(e.nextService)}', style: theme.textTheme.bodySmall),
                ],
              ),
              if (e.assignedProject != '—') ...[
                const SizedBox(height: 4),
                Text('Assigned: ${e.assignedProject}', style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        );
      },
    );
  }
}
