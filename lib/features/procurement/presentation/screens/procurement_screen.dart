import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';

final _date = DateFormat('MMM d');

class ProcurementScreen extends ConsumerStatefulWidget {
  const ProcurementScreen({super.key});

  @override
  ConsumerState<ProcurementScreen> createState() => _ProcurementScreenState();
}

class _ProcurementScreenState extends ConsumerState<ProcurementScreen> {
  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(mockDataProvider).purchaseRequests;

    return ModuleListScaffold(
      title: 'Procurement',
      itemCount: requests.length,
      fabLabel: 'New Request',
      onFabPressed: () => _showCreateRequest(context),
      itemBuilder: (context, i) {
        final r = requests[i];
        final theme = Theme.of(context);
        final color = switch (r.status) {
          'Approved' => const Color(0xFF2E9E5B),
          'Ordered' => const Color(0xFF3B82C4),
          'Rejected' => const Color(0xFFD8453C),
          _ => const Color(0xFFE0A72E),
        };
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(r.itemName, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14))),
                  StatusBadge(label: r.status, color: color),
                ],
              ),
              const SizedBox(height: 4),
              Text('${r.project} · Requested by ${r.requestedBy}', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(_date.format(r.date), style: theme.textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }

  void _showCreateRequest(BuildContext context) {
    final itemController = TextEditingController();
    final qtyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          left: AppConstants.space20,
          right: AppConstants.space20,
          top: AppConstants.space20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppConstants.space20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New Purchase Request', style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: AppConstants.space16),
            TextField(controller: itemController, decoration: const InputDecoration(labelText: 'Item / description')),
            const SizedBox(height: AppConstants.space12),
            TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')),
            const SizedBox(height: AppConstants.space20),
            FilledButton(
              onPressed: () {
                if (itemController.text.trim().isEmpty) return;
                final data = ref.read(mockDataProvider);
                data.addPurchaseRequest(PurchaseRequest(
                  id: 'PR-${500 + data.purchaseRequests.length + 1}',
                  itemName: itemController.text.trim(),
                  quantity: int.tryParse(qtyController.text.trim()) ?? 0,
                  requestedBy: 'You',
                  project: data.projects.first.name,
                  status: 'Pending',
                  date: DateTime.now(),
                ));
                Navigator.of(sheetContext).pop();
              },
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
