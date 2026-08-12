class Routes {
  Routes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const phoneLogin = '/phone-login';
  static const companySetup = '/company-setup';

  // Shell-wrapped module routes
  static const dashboard = '/dashboard';
  static const projects = '/projects';
  static const tasks = '/tasks';
  static const attendance = '/attendance';
  static const labor = '/labor';
  static const inventory = '/inventory';
  static const equipment = '/equipment';
  static const procurement = '/procurement';
  static const suppliers = '/suppliers';
  static const clients = '/clients';
  static const expenses = '/expenses';
  static const documents = '/documents';
  static const gallery = '/gallery';
  static const ai = '/ai';
  static const maps = '/maps';
  static const analytics = '/analytics';
  static const reports = '/reports';
  static const settings = '/settings';
  static const profile = '/profile';
  static const notifications = '/notifications';
  static const search = '/search';

  // Detail routes (outside the shell's bottom padding concerns, but
  // still pushed on top of it)
  static String projectDetail(String id) => '/projects/$id';
  static String clientDetail(String id) => '/clients/$id';
  static String workerDetail(String id) => '/labor/$id';
}
