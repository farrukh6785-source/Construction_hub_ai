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

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String _query = '';
  TaskStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(mockDataProvider).tasks.where((t) {
      final matchesQuery = _query.isEmpty || t.title.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == null || t.status == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return ModuleListScaffold(
      title: 'Tasks',
      searchHint: 'Search tasks',
      onSearchChanged: (v) => setState(() => _query = v),
      itemCount: tasks.length,
      emptyTitle: 'No tasks match your filters',
      fabLabel: 'New Task',
      onFabPressed: () => _showCreateTask(context),
      filterChips: [
        ChoiceChip(label: const Text('All'), selected: _filter == null, onSelected: (_) => setState(() => _filter = null)),
        for (final status in TaskStatus.values)
          ChoiceChip(
            label: Text(status.label),
            selected: _filter == status,
            onSelected: (_) => setState(() => _filter = _filter == status ? null : status),
          ),
      ],
      itemBuilder: (context, i) => _TaskCard(task: tasks[i]),
    );
  }

  void _showCreateTask(BuildContext context) {
    final titleController = TextEditingController();
    final assigneeController = TextEditingController();
    TaskPriority priority = TaskPriority.medium;

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
        child: StatefulBuilder(
          builder: (context, setSheetState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New Task', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppConstants.space16),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Task title')),
              const SizedBox(height: AppConstants.space12),
              TextField(controller: assigneeController, decoration: const InputDecoration(labelText: 'Assignee')),
              const SizedBox(height: AppConstants.space12),
              DropdownButtonFormField<TaskPriority>(
                value: priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.label))).toList(),
                onChanged: (v) => setSheetState(() => priority = v!),
              ),
              const SizedBox(height: AppConstants.space20),
              FilledButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;
                  final data = ref.read(mockDataProvider);
                  data.addTask(TaskModel(
                    id: 'T-${100 + data.tasks.length + 1}',
                    title: titleController.text.trim(),
                    projectName: data.projects.first.name,
                    assignee: assigneeController.text.trim().isEmpty ? 'Unassigned' : assigneeController.text.trim(),
                    priority: priority,
                    status: TaskStatus.todo,
                    dueDate: DateTime.now().add(const Duration(days: 7)),
                  ));
                  Navigator.of(sheetContext).pop();
                },
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(task.title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14))),
              StatusBadge(label: task.priority.label, color: task.priority.color),
            ],
          ),
          const SizedBox(height: 4),
          Text('${task.projectName} · ${task.assignee}', style: theme.textTheme.bodySmall),
          const SizedBox(height: AppConstants.space12),
          Row(
            children: [
              Icon(Icons.event_outlined, size: 14, color: theme.textTheme.bodySmall?.color),
              const SizedBox(width: 4),
              Text('Due ${_date.format(task.dueDate)}', style: theme.textTheme.bodySmall),
              const Spacer(),
              DropdownButton<TaskStatus>(
                value: task.status,
                underline: const SizedBox.shrink(),
                isDense: true,
                items: TaskStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: theme.textTheme.bodySmall))).toList(),
                onChanged: (status) {
                  if (status != null) ref.read(mockDataProvider).updateTaskStatus(task.id, status);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
