import 'dart:async';
import 'dart:math';
import '../../domain/auth_exception.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/session_service.dart';

/// -----------------------------------------------------------------
/// STUB IMPLEMENTATION — replace with a FirebaseAuthRepositoryImpl
/// once a Firebase project is connected. Keeps an in-memory "user
/// database" so registration/login flows are fully exercisable
/// (validation, error states, navigation) without any backend.
///
/// TODO(firebase): implement using firebase_auth + cloud_firestore:
///   - signInWithEmail        -> FirebaseAuth.signInWithEmailAndPassword
///   - registerWithEmail      -> FirebaseAuth.createUserWithEmailAndPassword
///                                + write user doc to Firestore `users/{uid}`
///   - signInWithGoogle       -> google_sign_in + FirebaseAuth.signInWithCredential
///   - signInWithPhone        -> FirebaseAuth.verifyPhoneNumber
///   - sendPasswordResetEmail -> FirebaseAuth.sendPasswordResetEmail
///   - authStateChanges       -> FirebaseAuth.authStateChanges().asyncMap(...)
///     mapped through the `users` Firestore collection to build UserEntity
/// -----------------------------------------------------------------
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._sessionService) {
    _restoreSession();
  }

  final SessionService _sessionService;

  /// email -> (password, user)
  final Map<String, (String, UserEntity)> _fakeUserDb = {};
  final _authStateController = StreamController<UserEntity?>.broadcast();
  UserEntity? _currentUser;

  void _restoreSession() {
    // In the stub there's nothing durable to restore into _fakeUserDb
    // across app restarts, so a persisted session token with no
    // matching in-memory user is treated as expired.
    if (_sessionService.hasActiveSession) {
      _sessionService.clearSession();
    }
  }

  Future<void> _simulateLatency() => Future.delayed(const Duration(milliseconds: 700));

  // FIXED: Using 1 << 30 to prevent 32-bit bitwise overflow in Web JavaScript
  String _generateId() => '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1 << 30)}';

  @override
  Stream<UserEntity?> authStateChanges() => _authStateController.stream;

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Future<UserEntity> signInWithEmail({required String email, required String password}) async {
    await _simulateLatency();
    final normalized = email.trim().toLowerCase();
    final entry = _fakeUserDb[normalized];
    if (entry == null) throw const UserNotFoundException();
    if (entry.$1 != password) throw const InvalidCredentialsException();

    await _sessionService.saveSession(token: _generateId(), userId: entry.$2.id);
    _currentUser = entry.$2;
    _authStateController.add(_currentUser);
    return entry.$2;
  }

  @override
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _simulateLatency();
    final normalized = email.trim().toLowerCase();
    if (_fakeUserDb.containsKey(normalized)) throw const EmailAlreadyInUseException();
    if (password.length < 8) throw const WeakPasswordException();

    final user = UserEntity(
      id: _generateId(),
      email: normalized,
      fullName: fullName.trim(),
      role: UserRole.companyOwner, // first registrant on a new account sets up the company
    );
    _fakeUserDb[normalized] = (password, user);

    await _sessionService.saveSession(token: _generateId(), userId: user.id);
    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    await _simulateLatency();
    // TODO(firebase): real Google sign-in returns the actual account.
    final user = UserEntity(
      id: _generateId(),
      email: 'google.user@example.com',
      fullName: 'Google User',
      role: UserRole.companyOwner,
    );
    await _sessionService.saveSession(token: _generateId(), userId: user.id);
    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  @override
  Future<String> signInWithPhone({required String phoneNumber}) async {
    await _simulateLatency();
    // TODO(firebase): FirebaseAuth.verifyPhoneNumber, return real verificationId.
    return 'stub-verification-id';
  }

  @override
  Future<UserEntity> confirmPhoneCode({required String verificationId, required String smsCode}) async {
    await _simulateLatency();
    if (smsCode.length != 6) throw const AuthException('Enter the 6-digit code sent to your phone.');
    final user = UserEntity(
      id: _generateId(),
      email: '',
      fullName: 'Phone User',
      role: UserRole.siteEngineer,
    );
    await _sessionService.saveSession(token: _generateId(), userId: user.id);
    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _simulateLatency();
    final normalized = email.trim().toLowerCase();
    if (!_fakeUserDb.containsKey(normalized)) throw const UserNotFoundException();
    // TODO(firebase): FirebaseAuth.sendPasswordResetEmail(email: normalized)
  }

  @override
  Future<void> sendEmailVerification() async {
    await _simulateLatency();
    // TODO(firebase): FirebaseAuth.currentUser?.sendEmailVerification()
  }

  @override
  Future<void> signOut() async {
    await _sessionService.clearSession();
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    if (_currentUser != null) {
      _fakeUserDb.remove(_currentUser!.email);
    }
    await _sessionService.clearSession();
    _currentUser = null;
    _authStateController.add(null);
  }
}