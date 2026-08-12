import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../mock/mock_data_service.dart';

class _SearchResult {
  _SearchResult({required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_SearchResult> _search(BuildContext context) {
    final data = ref.read(mockDataProvider);
    final q = _query.toLowerCase();
    if (q.isEmpty) return [];
    final results = <_SearchResult>[];

    for (final p in data.projects) {
      if (p.name.toLowerCase().contains(q) || p.client.toLowerCase().contains(q)) {
        results.add(_SearchResult(title: p.name, subtitle: 'Project · ${p.client}', icon: Icons.apartment_outlined, onTap: () => context.push(Routes.projectDetail(p.id))));
      }
    }
    for (final w in data.workers) {
      if (w.name.toLowerCase().contains(q) || w.role.toLowerCase().contains(q)) {
        results.add(_SearchResult(title: w.name, subtitle: 'Worker · ${w.role}', icon: Icons.person_outline, onTap: () => context.push(Routes.labor)));
      }
    }
    for (final c in data.clients) {
      if (c.name.toLowerCase().contains(q)) {
        results.add(_SearchResult(title: c.name, subtitle: 'Client · ${c.company}', icon: Icons.handshake_outlined, onTap: () => context.push(Routes.clientDetail(c.id))));
      }
    }
    for (final s in data.suppliers) {
      if (s.name.toLowerCase().contains(q)) {
        results.add(_SearchResult(title: s.name, subtitle: 'Supplier · ${s.category}', icon: Icons.local_shipping_outlined, onTap: () => context.push(Routes.suppliers)));
      }
    }
    for (final item in data.inventory) {
      if (item.name.toLowerCase().contains(q)) {
        results.add(_SearchResult(title: item.name, subtitle: 'Material · ${item.category}', icon: Icons.inventory_2_outlined, onTap: () => context.push(Routes.inventory)));
      }
    }
    for (final d in data.documents) {
      if (d.name.toLowerCase().contains(q)) {
        results.add(_SearchResult(title: d.name, subtitle: 'Document · ${d.type}', icon: Icons.description_outlined, onTap: () => context.push(Routes.documents)));
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final results = _search(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Search projects, workers, clients…', border: InputBorder.none),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: _query.isEmpty
          ? const AppEmptyWidget(title: 'Search across your whole workspace', message: 'Projects, workers, clients, suppliers, materials, and documents.', icon: Icons.search)
          : results.isEmpty
              ? const AppEmptyWidget(title: 'No results found')
              : ListView.separated(
                  padding: const EdgeInsets.all(AppConstants.space16),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppConstants.space12),
                  itemBuilder: (context, i) {
                    final r = results[i];
                    return AppCard(
                      onTap: r.onTap,
                      child: Row(
                        children: [
                          Icon(r.icon, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: AppConstants.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                Text(r.subtitle, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
