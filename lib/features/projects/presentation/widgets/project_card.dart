import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_models.dart';

final _currency = NumberFormat.compactCurrency(locale: 'en_US', symbol: 'PKR ');

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, required this.onTap});
  final ProjectModel project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(project.name, style: theme.textTheme.titleMedium)),
              StatusBadge(label: project.status.label, color: project.status.color),
            ],
          ),
          const SizedBox(height: 4),
          Text('${project.client} · ${project.location}', style: theme.textTheme.bodySmall),
          const SizedBox(height: AppConstants.space12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            child: LinearProgressIndicator(
              value: project.progress,
              minHeight: 6,
              backgroundColor: theme.dividerColor,
              color: project.status.color,
            ),
          ),
          const SizedBox(height: AppConstants.space12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetaChip(icon: Icons.groups_outlined, label: '${project.workersOnSite} workers'),
              _MetaChip(icon: Icons.account_balance_wallet_outlined, label: _currency.format(project.spent)),
              _MetaChip(icon: Icons.percent, label: '${(project.progress * 100).toStringAsFixed(0)}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
