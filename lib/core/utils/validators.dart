import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.errRequired;
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (!_emailRegex.hasMatch(value!.trim())) return AppStrings.errInvalidEmail;
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 8) return AppStrings.errPasswordTooShort;
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() originalPassword) {
    return (value) {
      final requiredError = required(value);
      if (requiredError != null) return requiredError;
      if (value != originalPassword()) return AppStrings.errPasswordMismatch;
      return null;
    };
  }
}
