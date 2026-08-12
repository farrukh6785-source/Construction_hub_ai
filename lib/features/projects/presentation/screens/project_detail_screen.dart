import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';

final _currency = NumberFormat.currency(locale: 'en_US', symbol: 'PKR ', decimalDigits: 0);
final _date = DateFormat('MMM d, yyyy');

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(mockDataProvider);
    ProjectModel? project;
    for (final p in data.projects) {
      if (p.id == projectId) project = p;
    }

    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project')),
        body: const AppEmptyWidget(title: 'Project not found'),
      );
    }

    final tasks = data.tasks.where((t) => t.projectName == project!.name).toList();
    final documents = data.documents.where((d) => d.project == project!.name).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Tasks'),
              Tab(text: 'Documents'),
              Tab(text: 'Gallery'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OverviewTab(project: project),
            _TasksTab(tasks: tasks),
            _DocumentsTab(documents: documents),
            const _GalleryPlaceholderTab(),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.project});
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(label: project.status.label, color: project.status.color),
              const Spacer(),
              Text('${(project.progress * 100).toStringAsFixed(0)}% complete', style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: AppConstants.space8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            child: LinearProgressIndicator(value: project.progress, minHeight: 8, color: project.status.color, backgroundColor: theme.dividerColor),
          ),
          const SizedBox(height: AppConstants.space20),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(icon: Icons.handshake_outlined, label: 'Client', value: project.client),
                _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: project.location),
                _InfoRow(icon: Icons.person_outline, label: 'Project Manager', value: project.manager),
                _InfoRow(icon: Icons.groups_outlined, label: 'Workers on Site', value: '${project.workersOnSite}'),
                _InfoRow(icon: Icons.calendar_today_outlined, label: 'Start Date', value: _date.format(project.startDate)),
                _InfoRow(icon: Icons.event_available_outlined, label: 'End Date', value: _date.format(project.endDate), showDivider: false),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.space16),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Budget', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(_currency.format(project.budget), style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remaining', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(_currency.format(project.budgetRemaining), style: theme.textTheme.titleMedium?.copyWith(color: const Color(0xFF2E9E5B))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.showDivider = true});
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.space8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: theme.textTheme.bodySmall?.color),
              const SizedBox(width: AppConstants.space12),
              Text(label, style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: theme.dividerColor),
      ],
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab({required this.tasks});
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const AppEmptyWidget(title: 'No tasks on this project yet', icon: Icons.checklist_outlined);
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.space16),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.space12),
      itemBuilder: (context, i) {
        final t = tasks[i];
        return AppCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Assigned to ${t.assignee}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              StatusBadge(label: t.priority.label, color: t.priority.color),
            ],
          ),
        );
      },
    );
  }
}

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab({required this.documents});
  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) return const AppEmptyWidget(title: 'No documents uploaded yet', icon: Icons.folder_outlined);
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.space16),
      itemCount: documents.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.space12),
      itemBuilder: (context, i) {
        final d = documents[i];
        return AppCard(
          child: Row(
            children: [
              const Icon(Icons.description_outlined),
              const SizedBox(width: AppConstants.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${d.type} · ${_date.format(d.date)}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GalleryPlaceholderTab extends StatelessWidget {
  const _GalleryPlaceholderTab();

  @override
  Widget build(BuildContext context) {
    return const AppEmptyWidget(
      title: 'No photos linked to this project yet',
      message: 'Site photos uploaded to the Gallery module tagged with this project will show up here.',
      icon: Icons.photo_library_outlined,
    );
  }
}
