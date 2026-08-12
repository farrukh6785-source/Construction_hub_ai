import 'package:flutter/material.dart';
import '../router/route_names.dart';

class NavDestinationItem {
  const NavDestinationItem({required this.icon, required this.selectedIcon, required this.label, required this.path});
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;
}

const List<NavDestinationItem> appNavDestinations = [
  NavDestinationItem(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard, label: 'Dashboard', path: Routes.dashboard),
  NavDestinationItem(icon: Icons.apartment_outlined, selectedIcon: Icons.apartment, label: 'Projects', path: Routes.projects),
  NavDestinationItem(icon: Icons.checklist_outlined, selectedIcon: Icons.checklist, label: 'Tasks', path: Routes.tasks),
  NavDestinationItem(icon: Icons.fingerprint, selectedIcon: Icons.fingerprint, label: 'Attendance', path: Routes.attendance),
  NavDestinationItem(icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: 'Labor', path: Routes.labor),
  NavDestinationItem(icon: Icons.inventory_2_outlined, selectedIcon: Icons.inventory_2, label: 'Inventory', path: Routes.inventory),
  NavDestinationItem(icon: Icons.precision_manufacturing_outlined, selectedIcon: Icons.precision_manufacturing, label: 'Equipment', path: Routes.equipment),
  NavDestinationItem(icon: Icons.shopping_cart_outlined, selectedIcon: Icons.shopping_cart, label: 'Procurement', path: Routes.procurement),
  NavDestinationItem(icon: Icons.local_shipping_outlined, selectedIcon: Icons.local_shipping, label: 'Suppliers', path: Routes.suppliers),
  NavDestinationItem(icon: Icons.handshake_outlined, selectedIcon: Icons.handshake, label: 'Clients', path: Routes.clients),
  NavDestinationItem(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: 'Expenses', path: Routes.expenses),
  NavDestinationItem(icon: Icons.folder_outlined, selectedIcon: Icons.folder, label: 'Documents', path: Routes.documents),
  NavDestinationItem(icon: Icons.photo_library_outlined, selectedIcon: Icons.photo_library, label: 'Site Gallery', path: Routes.gallery),
  NavDestinationItem(icon: Icons.auto_awesome_outlined, selectedIcon: Icons.auto_awesome, label: 'AI Assistant', path: Routes.ai),
  NavDestinationItem(icon: Icons.map_outlined, selectedIcon: Icons.map, label: 'Maps', path: Routes.maps),
  NavDestinationItem(icon: Icons.bar_chart_outlined, selectedIcon: Icons.bar_chart, label: 'Analytics', path: Routes.analytics),
  NavDestinationItem(icon: Icons.summarize_outlined, selectedIcon: Icons.summarize, label: 'Reports', path: Routes.reports),
  NavDestinationItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings', path: Routes.settings),
];
