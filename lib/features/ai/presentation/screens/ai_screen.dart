import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../mock/mock_data_service.dart';

class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const _suggestions = [
    'Which project is most at risk of delay?',
    'How is our budget tracking overall?',
    'What materials should we reorder soon?',
  ];

  void _send([String? text]) {
    final message = (text ?? _controller.text).trim();
    if (message.isEmpty) return;
    ref.read(mockDataProvider).sendChatMessage(message);
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: AppConstants.animMedium, curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = ref.watch(mockDataProvider);
    final messages = data.chatMessages;

    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _EmptyState(onSuggestionTap: _send)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.space16),
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final m = messages[i];
                      return Align(
                        alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: AppConstants.space12),
                          constraints: const BoxConstraints(maxWidth: 420),
                          padding: const EdgeInsets.all(AppConstants.space12),
                          decoration: BoxDecoration(
                            color: m.isUser ? theme.colorScheme.primary : theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            border: m.isUser ? null : Border.all(color: theme.dividerColor),
                          ),
                          child: Text(
                            m.text,
                            style: theme.textTheme.bodyMedium?.copyWith(color: m.isUser ? Colors.white : null),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.space12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Ask about your projects, budget, or materials…'),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: AppConstants.space8),
                  IconButton.filled(icon: const Icon(Icons.send_rounded), onPressed: () => _send()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState({required this.onSuggestionTap});
  final void Function(String) onSuggestionTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final insights = ref.watch(mockDataProvider).aiInsights;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, size: 40, color: theme.colorScheme.primary),
          const SizedBox(height: AppConstants.space12),
          Text('Ask ConstructionHub AI anything', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppConstants.space8),
          Text('Grounded in your live project, budget, and inventory data — mocked here, real via Gemini once connected.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppConstants.space16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _AiScreenState._suggestions
                .map((s) => ActionChip(label: Text(s), onPressed: () => onSuggestionTap(s)))
                .toList(),
          ),
          const SizedBox(height: AppConstants.space24),
          Text('Current Insights', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppConstants.space8),
          ...insights.map((insight) => Padding(
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
        ],
      ),
    );
  }

  Color _severityColor(String s) => switch (s) {
        'critical' => const Color(0xFFD8453C),
        'warning' => const Color(0xFFE0A72E),
        _ => const Color(0xFF3B82C4),
      };
}
