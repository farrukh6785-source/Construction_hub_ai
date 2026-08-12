import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../mock/mock_data_service.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final records = ref.watch(mockDataProvider).attendance;
    final presentCount = records.where((r) => r.status == 'Present').length;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.maxContentWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _mockCheckIn(context, 'QR Code'),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('QR Check-In'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.space12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _mockCheckIn(context, 'GPS'),
                      icon: const Icon(Icons.my_location),
                      label: const Text('GPS Check-In'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.space24),
              Row(
                children: [
                  Text('Today\'s Attendance', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Text('$presentCount / ${records.length} present', style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: AppConstants.space12),
              ...records.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.space12),
                    child: AppCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                            child: Text(r.workerName[0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: AppConstants.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.workerName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                Text('In ${r.checkIn} · Out ${r.checkOut} · ${r.method}', style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          StatusBadge(
                            label: r.status,
                            color: r.status == 'Present'
                                ? const Color(0xFF2E9E5B)
                                : r.status == 'Late'
                                    ? const Color(0xFFE0A72E)
                                    : const Color(0xFFD8453C),
                          ),
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

  void _mockCheckIn(BuildContext context, String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checked in via $method at ${TimeOfDay.now().format(context)}')),
    );
  }
}
