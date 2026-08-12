import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../mock/mock_data_service.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(mockDataProvider).reportTypes;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.maxContentWidth),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppConstants.space16),
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppConstants.space12),
            itemBuilder: (context, i) {
              final t = types[i];
              return AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
                      child: Icon(t.icon, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(width: AppConstants.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text(t.description, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (format) => _mockGenerate(context, t.title, format),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'PDF', child: Text('Export as PDF')),
                        PopupMenuItem(value: 'Excel', child: Text('Export as Excel')),
                        PopupMenuItem(value: 'CSV', child: Text('Export as CSV')),
                      ],
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _mockGenerate(BuildContext context, String reportName, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$reportName generated as $format — export uses the pdf/excel packages once wired up')),
    );
  }
}
