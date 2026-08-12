import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/weekly_progress_chart.dart';

final _currency = NumberFormat.compactCurrency(locale: 'en_US', symbol: 'PKR ');

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final data = ref.watch(mockDataProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final runningProjects = data.projects.where((p) => p.status == ProjectStatus.running || p.status == ProjectStatus.delayed).toList();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.maxContentWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back, ${user?.fullName.split(' ').first ?? 'there'} 👋', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Here\'s what\'s happening across your projects today.', style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppConstants.space20),

              // KPI grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: context.isMobile ? 2 : 4,
                mainAxisSpacing: AppConstants.space12,
                crossAxisSpacing: AppConstants.space12,
                childAspectRatio: 1.5,
                children: [
                  StatCard(label: 'Running Projects', value: '${data.runningProjectsCount}', icon: Icons.construction, trend: '+2', trendUp: true),
                  StatCard(label: 'Delayed Projects', value: '${data.delayedProjectsCount}', icon: Icons.warning_amber_rounded, color: const Color(0xFFD8453C), trend: '1', trendUp: false),
                  StatCard(label: 'Budget Used', value: _currency.format(data.totalSpent), icon: Icons.account_balance_wallet_outlined, color: const Color(0xFFF2A93B)),
                  StatCard(label: 'Low Stock Alerts', value: '${data.lowStockCount}', icon: Icons.inventory_2_outlined, color: const Color(0xFFD8453C)),
                ],
              ),
              const SizedBox(height: AppConstants.space24),

              // Weekly progress chart
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly Progress', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppConstants.space16),
                    const WeeklyProgressChart(),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),

              // AI insights
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI Insights', style: theme.textTheme.titleMedium),
                  TextButton(onPressed: () => context.push(Routes.ai), child: const Text('Ask AI →')),
                ],
              ),
              const SizedBox(height: AppConstants.space8),
              ...data.aiInsights.take(2).map((insight) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.space12),
                    child: AppCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(insight.icon, color: _severityColor(insight.severity)),
                          const SizedBox(width: AppConstants.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(insight.title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(insight.description, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: AppConstants.space12),

              // Running projects
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Running Projects', style: theme.textTheme.titleMedium),
                  TextButton(onPressed: () => context.push(Routes.projects), child: const Text('View all →')),
                ],
              ),
              const SizedBox(height: AppConstants.space8),
              ...runningProjects.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.space12),
                    child: AppCard(
                      onTap: () => context.push(Routes.projectDetail(p.id)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(p.name, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14))),
                              StatusBadge(label: p.status.label, color: p.status.color),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${p.location} · ${p.workersOnSite} workers on site', style: theme.textTheme.bodySmall),
                          const SizedBox(height: AppConstants.space12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                            child: LinearProgressIndicator(
                              value: p.progress,
                              minHeight: 6,
                              backgroundColor: theme.dividerColor,
                              color: p.status.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${(p.progress * 100).toStringAsFixed(0)}% complete', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _severityColor(String severity) => switch (severity) {
        'critical' => const Color(0xFFD8453C),
        'warning' => const Color(0xFFE0A72E),
        _ => const Color(0xFF3B82C4),
      };
}
