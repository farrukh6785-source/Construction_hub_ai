/// User-facing copy, centralized so the intl/localization layer can be
/// dropped in later without hunting strings out of widget trees.
class AppStrings {
  AppStrings._();

  // Onboarding
  static const onboardTitle1 = 'Run every project from one place';
  static const onboardBody1 =
      'Track budgets, timelines, labor, and materials for every site '
      'without switching between five different tools.';

  static const onboardTitle2 = 'Built for the whole team';
  static const onboardBody2 =
      'Site engineers, supervisors, accountants, and clients each get '
      'a dashboard built for their job — nothing they don\'t need.';

  static const onboardTitle3 = 'AI that actually helps on-site';
  static const onboardBody3 =
      'Delay predictions, budget forecasts, and daily report summaries, '
      'generated automatically from the data you\'re already logging.';

  static const onboardTitle4 = 'Ready when you are';
  static const onboardBody4 =
      'Set up your company profile and invite your team — you can be '
      'running your first project in under ten minutes.';

  static const getStarted = 'Get Started';
  static const skip = 'Skip';
  static const next = 'Next';

  // Auth
  static const login = 'Log In';
  static const register = 'Create Account';
  static const email = 'Email';
  static const password = 'Password';
  static const confirmPassword = 'Confirm Password';
  static const fullName = 'Full Name';
  static const forgotPassword = 'Forgot password?';
  static const continueWithGoogle = 'Continue with Google';
  static const continueWithPhone = 'Continue with Phone';
  static const noAccount = "Don't have an account? ";
  static const haveAccount = 'Already have an account? ';
  static const signUp = 'Sign Up';
  static const resetPassword = 'Reset Password';
  static const resetPasswordBody =
      'Enter the email associated with your account and we\'ll send a '
      'link to reset your password.';
  static const sendResetLink = 'Send Reset Link';

  // Errors
  static const errRequired = 'This field is required';
  static const errInvalidEmail = 'Enter a valid email address';
  static const errPasswordTooShort = 'Password must be at least 8 characters';
  static const errPasswordMismatch = 'Passwords do not match';
  static const errGeneric = 'Something went wrong. Please try again.';
}
