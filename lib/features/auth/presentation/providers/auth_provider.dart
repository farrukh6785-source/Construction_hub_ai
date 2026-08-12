import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/core_providers.dart';
import '../../../company/presentation/screens/company_setup_screen.dart' show mockCompanyIdProvider;

/// Swap this ONE provider to point at a Firebase-backed implementation
/// later — every screen and the router only ever depend on the
/// AuthRepository interface, never on this stub directly.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(sessionServiceProvider));
});

/// The router's redirect logic watches this to decide between
/// splash/onboarding/auth/dashboard.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Drives the login/register/forgot-password forms. AsyncValue's
/// loading/error states map directly onto PrimaryButton's isLoading
/// and onto inline error banners — no separate bool flags needed.
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signInWithEmail(email: email, password: password));
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.registerWithEmail(email: email, password: password, fullName: fullName),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signInWithGoogle());
  }

  Future<void> sendPasswordReset({required String email}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.sendPasswordResetEmail(email: email));
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.signOut());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

/// Combines the user entity's companyId (always null from the stub's
/// registration flow) with the Company Setup screen's local
/// completion flag, so the router knows when to stop redirecting
/// there. See features/company/presentation/screens/company_setup_screen.dart.
final needsCompanySetupProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return false;
  if (!user.needsCompanySetup) return false;
  final mockCompanyId = ref.watch(mockCompanyIdProvider);
  return mockCompanyId == null;
});
