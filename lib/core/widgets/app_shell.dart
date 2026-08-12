import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../router/nav_destinations.dart';
import '../router/route_names.dart';
import '../utils/extensions.dart';
import '../../mock/mock_data_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});
  final Widget child;
  final String location;

  int get _selectedIndex {
    final i = appNavDestinations.indexWhere((d) => location.startsWith(d.path));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = context.isDesktop;
    final current = appNavDestinations[_selectedIndex];
    final unread = ref.watch(mockDataProvider).unreadNotificationsCount;
    final user = ref.watch(authStateProvider).valueOrNull;

    final topBar = AppBar(
      title: Text(current.label),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () => context.push(Routes.search),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
              onPressed: () => context.push(Routes.notifications),
            ),
            if (unread > 0)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Color(0xFFD8453C), shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$unread',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppConstants.space12, left: 4),
          child: GestureDetector(
            onTap: () => context.push(Routes.profile),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              child: Text(
                (user?.fullName.isNotEmpty == true ? user!.fullName[0] : '?').toUpperCase(),
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: context.screenWidth > AppConstants.breakpointDesktop,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => context.go(appNavDestinations[i].path),
              labelType: context.screenWidth > AppConstants.breakpointDesktop
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppConstants.space16),
                child: Icon(Icons.foundation_rounded, size: 28),
              ),
              destinations: appNavDestinations
                  .map((d) => NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Scaffold(appBar: topBar, body: child),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: topBar,
      drawer: _AppDrawer(selectedIndex: _selectedIndex, userName: user?.fullName, role: user?.role.label),
      body: child,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.selectedIndex, this.userName, this.role});
  final int selectedIndex;
  final String? userName;
  final String? role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.space20,
                AppConstants.space20,
                AppConstants.space20,
                AppConstants.space12,
              ),
              child: Row(
                children: [
                  Icon(Icons.foundation_rounded, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: AppConstants.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppConstants.appName, style: theme.textTheme.titleMedium),
                        if (userName != null)
                          Text('$userName · ${role ?? ''}', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.space8),
                itemCount: appNavDestinations.length,
                itemBuilder: (context, i) {
                  final d = appNavDestinations[i];
                  final selected = i == selectedIndex;
                  return ListTile(
                    leading: Icon(selected ? d.selectedIcon : d.icon,
                        color: selected ? theme.colorScheme.primary : null),
                    title: Text(
                      d.label,
                      style: TextStyle(
                        color: selected ? theme.colorScheme.primary : null,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: selected,
                    selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.06),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(d.path);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
