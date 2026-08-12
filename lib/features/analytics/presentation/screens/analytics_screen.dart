import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../mock/mock_data_service.dart';

final _currency = NumberFormat.compactCurrency(locale: 'en_US', symbol: 'PKR ');

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  static const _months = ['Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
  static const _revenue = [180.0, 210.0, 195.0, 240.0, 265.0, 250.0];
  static const _expense = [140.0, 160.0, 150.0, 175.0, 190.0, 185.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final data = ref.watch(mockDataProvider);
    final profit = data.totalBudget - data.totalSpent;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.maxContentWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: context.isMobile ? 2 : 4,
                mainAxisSpacing: AppConstants.space12,
                crossAxisSpacing: AppConstants.space12,
                childAspectRatio: 1.5,
                children: [
                  StatCard(label: 'Total Revenue (approved budget)', value: _currency.format(data.totalBudget), icon: Icons.trending_up_rounded, color: const Color(0xFF2E9E5B)),
                  StatCard(label: 'Total Expense', value: _currency.format(data.totalSpent), icon: Icons.trending_down_rounded, color: const Color(0xFFD8453C)),
                  StatCard(label: 'Projected Profit', value: _currency.format(profit), icon: Icons.savings_outlined, color: const Color(0xFFF2A93B)),
                  StatCard(label: 'Completed Projects', value: '${data.completedProjectsCount}', icon: Icons.task_alt_outlined),
                ],
              ),
              const SizedBox(height: AppConstants.space24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Revenue vs Expense (PKR M)', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        _LegendDot(color: theme.colorScheme.primary, label: 'Revenue'),
                        const SizedBox(width: 12),
                        const _LegendDot(color: Color(0xFFD8453C), label: 'Expense'),
                      ],
                    ),
                    const SizedBox(height: AppConstants.space16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: theme.dividerColor, strokeWidth: 1)),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, meta) => Text(_months[v.toInt()], style: theme.textTheme.bodySmall),
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(_revenue.length, (i) => FlSpot(i.toDouble(), _revenue[i])),
                              isCurved: true,
                              color: theme.colorScheme.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: List.generate(_expense.length, (i) => FlSpot(i.toDouble(), _expense[i])),
                              isCurved: true,
                              color: const Color(0xFFD8453C),
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project Status Breakdown', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppConstants.space16),
                    ..._statusBreakdown(data).entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.space12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: theme.textTheme.bodyMedium),
                              Text('${e.value}', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                            child: LinearProgressIndicator(
                              value: data.projects.isEmpty ? 0 : e.value / data.projects.length,
                              minHeight: 6,
                              backgroundColor: theme.dividerColor,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _statusBreakdown(MockDataService data) {
    final map = <String, int>{};
    for (final p in data.projects) {
      final statusName = p.status.name;
      final label = statusName[0].toUpperCase() + statusName.substring(1);
      map[label] = (map[label] ?? 0) + 1;
    }
    return map;
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}