import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../mock/mock_data_service.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(mockDataProvider).suppliers.where((s) {
      return _query.isEmpty || s.name.toLowerCase().contains(_query.toLowerCase()) || s.category.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return ModuleListScaffold(
      title: 'Suppliers',
      searchHint: 'Search suppliers',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: suppliers.length,
      itemBuilder: (context, i) {
        final s = suppliers[i];
        final theme = Theme.of(context);
        return AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(Icons.local_shipping_outlined, color: theme.colorScheme.primary, size: 18),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text('${s.category} · ${s.contactPerson}', style: theme.textTheme.bodySmall),
                    Text(s.phone, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF2A93B)),
                      Text(' ${s.rating}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  Text('${s.totalOrders} orders', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
