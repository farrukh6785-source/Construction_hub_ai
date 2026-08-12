import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/module_list_scaffold.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';
import '../widgets/project_card.dart';
import 'project_form_screen.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String _query = '';
  ProjectStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(mockDataProvider).projects.where((p) {
      final matchesQuery = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.client.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == null || p.status == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return ModuleListScaffold(
      title: 'Projects',
      searchHint: 'Search projects or clients',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: projects.length,
      emptyTitle: 'No projects match your filters',
      fabLabel: 'New Project',
      onFabPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProjectFormScreen()),
      ),
      filterChips: [
        ChoiceChip(label: const Text('All'), selected: _filter == null, onSelected: (_) => setState(() => _filter = null)),
        for (final status in ProjectStatus.values)
          ChoiceChip(
            label: Text(status.label),
            selected: _filter == status,
            onSelected: (_) => setState(() => _filter = _filter == status ? null : status),
          ),
      ],
      itemBuilder: (context, i) => ProjectCard(
        project: projects[i],
        onTap: () => context.push(Routes.projectDetail(projects[i].id)),
      ),
    );
  }
}
