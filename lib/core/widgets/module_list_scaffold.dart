import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/extensions.dart';
import 'state_widgets.dart';

/// Shared shape for every "module list" screen: title, optional
/// search box, optional filter chips, a builder for the item list,
/// and an optional FAB. Keeps Projects/Tasks/Inventory/Suppliers/...
/// visually and behaviorally consistent without copy-pasting a whole
/// screen's scaffolding each time.
class ModuleListScaffold extends StatefulWidget {
  const ModuleListScaffold({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.searchHint,
    this.onSearchChanged,
    this.filterChips,
    this.onFabPressed,
    this.fabLabel,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage,
    this.trailing,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final String? searchHint;
  final void Function(String)? onSearchChanged;
  final List<Widget>? filterChips;
  final VoidCallback? onFabPressed;
  final String? fabLabel;
  final String emptyTitle;
  final String? emptyMessage;
  final List<Widget>? trailing;

  @override
  State<ModuleListScaffold> createState() => _ModuleListScaffoldState();
}

class _ModuleListScaffoldState extends State<ModuleListScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.trailing,
      ),
      floatingActionButton: widget.onFabPressed == null
          ? null
          : FloatingActionButton.extended(
              onPressed: widget.onFabPressed,
              icon: const Icon(Icons.add),
              label: Text(widget.fabLabel ?? 'New'),
            ),
      body: Column(
        children: [
          if (widget.onSearchChanged != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.space16,
                AppConstants.space12,
                AppConstants.space16,
                0,
              ),
              child: TextField(
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: widget.searchHint ?? 'Search',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                ),
              ),
            ),
          if (widget.filterChips != null && widget.filterChips!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.space12),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.space16),
                  itemCount: widget.filterChips!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => widget.filterChips![i],
                ),
              ),
            ),
          const SizedBox(height: AppConstants.space8),
          Expanded(
            child: widget.itemCount == 0
                ? AppEmptyWidget(title: widget.emptyTitle, message: widget.emptyMessage)
                : Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: context.maxContentWidth),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.space16,
                          AppConstants.space8,
                          AppConstants.space16,
                          AppConstants.space96,
                        ),
                        itemCount: widget.itemCount,
                        separatorBuilder: (_, __) => const SizedBox(height: AppConstants.space12),
                        itemBuilder: widget.itemBuilder,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
