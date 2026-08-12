import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';

final _currency = NumberFormat.compactCurrency(locale: 'en_US', symbol: 'PKR ');
final _date = DateFormat('MMM d');

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expenses = ref.watch(mockDataProvider).expenses;
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    final byCategory = <ExpenseCategory, double>{};
    for (final e in expenses) {
      byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.maxContentWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  children: [
                    Text('Total Expenses', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(_currency.format(total), style: theme.textTheme.displayMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space16),
              AppCard(
                child: SizedBox(
                  height: 220,
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: byCategory.entries
                                .map((entry) => PieChartSectionData(
                                      value: entry.value,
                                      color: entry.key.color,
                                      title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
                                      titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                      radius: 60,
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: byCategory.entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Container(width: 10, height: 10, decoration: BoxDecoration(color: entry.key.color, shape: BoxShape.circle)),
                                        const SizedBox(width: 6),
                                        Expanded(child: Text(entry.key.label, style: theme.textTheme.bodySmall)),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              Text('Recent Expenses', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.space8),
              ...expenses.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.space12),
                    child: AppCard(
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: e.category.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                            child: Icon(Icons.receipt_outlined, size: 16, color: e.category.color),
                          ),
                          const SizedBox(width: AppConstants.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                Text('${e.project} · ${_date.format(e.date)}', style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Text(_currency.format(e.amount), style: theme.textTheme.bodyMedium),
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
}
