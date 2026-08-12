/// Auth-specific failures, deliberately backend-agnostic — when the
/// Firebase implementation is wired in, it should catch FirebaseAuthException
/// and re-throw one of these, so nothing above the data layer ever
/// imports firebase_auth directly.
class AuthException implements Exception {
  const AuthException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Incorrect email or password.', code: 'invalid-credentials');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('An account already exists with this email.', code: 'email-in-use');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('No account found with this email.', code: 'user-not-found');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Please choose a stronger password.', code: 'weak-password');
}

class NetworkAuthException extends AuthException {
  const NetworkAuthException() : super('No internet connection. Please try again.', code: 'network-error');
}
