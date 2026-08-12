import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../mock/mock_data_service.dart';

/// A real Maps module would embed google_maps_flutter here, but that
/// needs a Maps API key configured per-platform — out of scope for a
/// mock-data build. This lists the same location data a map pin would
/// show, so the module is still fully functional without that setup.
class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
  String? _type;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(mockDataProvider).locations;
    final locations = _type == null ? all : all.where((l) => l.type == _type).toList();

    return ModuleListScaffold(
      title: 'Maps',
      itemCount: locations.length,
      trailing: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Embedded map view needs a Google Maps API key — this list uses the same location data')),
          ),
        ),
      ],
      filterChips: [
        ChoiceChip(label: const Text('All'), selected: _type == null, onSelected: (_) => setState(() => _type = null)),
        for (final t in ['Project', 'Supplier', 'Equipment'])
          ChoiceChip(label: Text(t), selected: _type == t, onSelected: (_) => setState(() => _type = _type == t ? null : t)),
      ],
      itemBuilder: (context, i) {
        final l = locations[i];
        final theme = Theme.of(context);
        final icon = switch (l.type) {
          'Project' => Icons.apartment_outlined,
          'Supplier' => Icons.local_shipping_outlined,
          _ => Icons.precision_manufacturing_outlined,
        };
        return AppCard(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: theme.colorScheme.primary, size: 18),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Text(l.address, style: theme.textTheme.bodySmall),
                    Text('${l.lat.toStringAsFixed(4)}, ${l.lng.toStringAsFixed(4)}', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.textTheme.bodySmall?.color),
            ],
          ),
        );
      },
    );
  }
}
