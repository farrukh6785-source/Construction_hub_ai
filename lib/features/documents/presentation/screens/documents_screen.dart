import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../mock/mock_data_service.dart';

final _date = DateFormat('MMM d, yyyy');

IconData _iconForType(String type) => switch (type) {
      'Contract' => Icons.description_outlined,
      'Drawing' => Icons.architecture_outlined,
      'Invoice' => Icons.receipt_long_outlined,
      'Permit' => Icons.verified_outlined,
      _ => Icons.insert_drive_file_outlined,
    };

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  String _query = '';
  String? _type;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(mockDataProvider).documents;
    final types = all.map((d) => d.type).toSet().toList();
    final documents = all.where((d) {
      final matchesQuery = _query.isEmpty || d.name.toLowerCase().contains(_query.toLowerCase());
      final matchesType = _type == null || d.type == _type;
      return matchesQuery && matchesType;
    }).toList();

    return ModuleListScaffold(
      title: 'Documents',
      searchHint: 'Search documents',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: documents.length,
      filterChips: [
        ChoiceChip(label: const Text('All'), selected: _type == null, onSelected: (_) => setState(() => _type = null)),
        for (final t in types)
          ChoiceChip(label: Text(t), selected: _type == t, onSelected: (_) => setState(() => _type = _type == t ? null : t)),
      ],
      itemBuilder: (context, i) {
        final d = documents[i];
        final theme = Theme.of(context);
        return AppCard(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppConstants.radiusSmall)),
                child: Icon(_iconForType(d.type), color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${d.project} · ${d.uploadedBy}', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${_date.format(d.date)} · ${(d.sizeKb / 1024).toStringAsFixed(1)} MB', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloading ${d.name}')));
              }),
            ],
          ),
        );
      },
    );
  }
}
