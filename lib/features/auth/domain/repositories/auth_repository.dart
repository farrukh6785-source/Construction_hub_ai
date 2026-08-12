import '../entities/user_entity.dart';

/// Contract the rest of the app depends on. Swapping the in-memory
/// stub (data/repositories/auth_repository_impl.dart) for a Firebase
/// implementation later means writing ONE new class that implements
/// this interface — nothing in presentation/ or other features changes.
abstract class AuthRepository {
  /// Emits the current user (or null when signed out) — the router's
  /// redirect logic listens to this.
  Stream<UserEntity?> authStateChanges();

  UserEntity? get currentUser;

  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  });

  Future<UserEntity> signInWithGoogle();

  /// Starts phone verification; returns a verification id to be passed
  /// to [confirmPhoneCode] once the user enters the SMS code.
  Future<String> signInWithPhone({required String phoneNumber});

  Future<UserEntity> confirmPhoneCode({
    required String verificationId,
    required String smsCode,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<void> deleteAccount();
}
