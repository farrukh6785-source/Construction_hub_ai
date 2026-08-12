import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';

final _currency = NumberFormat.currency(locale: 'en_US', symbol: 'PKR ', decimalDigits: 0);

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _query = '';
  String? _category;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(mockDataProvider).inventory;
    final categories = all.map((i) => i.category).toSet().toList();
    final items = all.where((i) {
      final matchesQuery = _query.isEmpty || i.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == null || i.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();

    return ModuleListScaffold(
      title: 'Inventory',
      searchHint: 'Search materials',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: items.length,
      filterChips: [
        ChoiceChip(label: const Text('All'), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
        for (final c in categories)
          ChoiceChip(label: Text(c), selected: _category == c, onSelected: (_) => setState(() => _category = _category == c ? null : c)),
      ],
      itemBuilder: (context, i) {
        final item = items[i];
        final theme = Theme.of(context);
        final ratio = item.minStock == 0 ? 1.0 : (item.currentStock / (item.minStock * 2)).clamp(0.0, 1.0);
        final color = switch (item.level) {
          StockLevel.critical => const Color(0xFFD8453C),
          StockLevel.low => const Color(0xFFE0A72E),
          StockLevel.ok => const Color(0xFF2E9E5B),
        };
        final label = switch (item.level) {
          StockLevel.critical => 'Critical',
          StockLevel.low => 'Low Stock',
          StockLevel.ok => 'In Stock',
        };

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(item.name, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14))),
                  StatusBadge(label: label, color: color),
                ],
              ),
              const SizedBox(height: 4),
              Text('${item.category} · ${item.warehouse}', style: theme.textTheme.bodySmall),
              const SizedBox(height: AppConstants.space12),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                child: LinearProgressIndicator(value: ratio, minHeight: 6, color: color, backgroundColor: theme.dividerColor),
              ),
              const SizedBox(height: AppConstants.space8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.currentStock.toStringAsFixed(0)} / min ${item.minStock.toStringAsFixed(0)} ${item.unit}', style: theme.textTheme.bodySmall),
                  Text(_currency.format(item.unitPrice), style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
