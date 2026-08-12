import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../services/core_providers.dart';
import '../widgets/app_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/splash/presentation/providers/splash_provider.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/company/presentation/screens/company_setup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/labor/presentation/screens/labor_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/equipment/presentation/screens/equipment_screen.dart';
import '../../features/procurement/presentation/screens/procurement_screen.dart';
import '../../features/suppliers/presentation/screens/suppliers_screen.dart';
import '../../features/clients/presentation/screens/clients_screen.dart';
import '../../features/clients/presentation/screens/client_detail_screen.dart';
import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/documents/presentation/screens/documents_screen.dart';
import '../../features/gallery/presentation/screens/gallery_screen.dart';
import '../../features/ai/presentation/screens/ai_screen.dart';
import '../../features/maps/presentation/screens/maps_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

const _authRoutes = {Routes.login, Routes.register, Routes.forgotPassword, Routes.phoneLogin};

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this.ref) {
    ref.listen(splashReadyProvider, (_, __) => notifyListeners());
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(onboardingCompleteProvider, (_, __) => notifyListeners());
    ref.listen(needsCompanySetupProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}

final _routerRefreshProvider = Provider<_RouterRefreshNotifier>((ref) {
  return _RouterRefreshNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(_routerRefreshProvider);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refreshNotifier,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final r = refreshNotifier.ref;
      final location = state.matchedLocation;

      final splashAsync = r.read(splashReadyProvider);
      final authState = r.read(authStateProvider);
      final onboardingComplete = r.read(onboardingCompleteProvider);

      // 1. Keep user on splash ONLY while splashAsync delay is running
      if (splashAsync.isLoading) {
        return location == Routes.splash ? null : Routes.splash;
      }

      final isOnSplash = location == Routes.splash;

      // 2. Onboarding Guard
      if (!onboardingComplete) {
        return location == Routes.onboarding ? null : Routes.onboarding;
      }

      // 3. Auth Guard
      final user = authState.valueOrNull;
      if (user == null) {
        return _authRoutes.contains(location) ? null : Routes.login;
      }

      // 4. Company Setup Guard
      if (r.read(needsCompanySetupProvider)) {
        return location == Routes.companySetup ? null : Routes.companySetup;
      }

      // 5. Route authenticated user away from entry screens to dashboard
      final isOnEntryScreen = isOnSplash ||
          location == Routes.onboarding ||
          location == Routes.companySetup ||
          _authRoutes.contains(location);

      if (isOnEntryScreen) {
        return Routes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: Routes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(path: Routes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: Routes.phoneLogin, builder: (_, __) => const PhoneLoginScreen()),
      GoRoute(path: Routes.companySetup, builder: (_, __) => const CompanySetupScreen()),

      GoRoute(path: '/projects/:id', builder: (context, state) => ProjectDetailScreen(projectId: state.pathParameters['id']!)),
      GoRoute(path: '/clients/:id', builder: (context, state) => ClientDetailScreen(clientId: state.pathParameters['id']!)),
      GoRoute(path: Routes.notifications, builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: Routes.profile, builder: (_, __) => const ProfileScreen()),
      GoRoute(path: Routes.search, builder: (_, __) => const SearchScreen()),

      ShellRoute(
        builder: (context, state, child) => AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: Routes.dashboard, builder: (_, __) => const DashboardScreen()),
          GoRoute(path: Routes.projects, builder: (_, __) => const ProjectsScreen()),
          GoRoute(path: Routes.tasks, builder: (_, __) => const TasksScreen()),
          GoRoute(path: Routes.attendance, builder: (_, __) => const AttendanceScreen()),
          GoRoute(path: Routes.labor, builder: (_, __) => const LaborScreen()),
          GoRoute(path: Routes.inventory, builder: (_, __) => const InventoryScreen()),
          GoRoute(path: Routes.equipment, builder: (_, __) => const EquipmentScreen()),
          GoRoute(path: Routes.procurement, builder: (_, __) => const ProcurementScreen()),
          GoRoute(path: Routes.suppliers, builder: (_, __) => const SuppliersScreen()),
          GoRoute(path: Routes.clients, builder: (_, __) => const ClientsScreen()),
          GoRoute(path: Routes.expenses, builder: (_, __) => const ExpensesScreen()),
          GoRoute(path: Routes.documents, builder: (_, __) => const DocumentsScreen()),
          GoRoute(path: Routes.gallery, builder: (_, __) => const GalleryScreen()),
          GoRoute(path: Routes.ai, builder: (_, __) => const AiScreen()),
          GoRoute(path: Routes.maps, builder: (_, __) => const MapsScreen()),
          GoRoute(path: Routes.analytics, builder: (_, __) => const AnalyticsScreen()),
          GoRoute(path: Routes.reports, builder: (_, __) => const ReportsScreen()),
          GoRoute(path: Routes.settings, builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
});