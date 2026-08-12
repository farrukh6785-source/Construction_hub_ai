import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(authControllerProvider.notifier).register(
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final errorMessage = error.toString().contains('RangeError') || error.toString().contains('max <= 2^32')
              ? 'Failed to create account. Please try again.'
              : error.toString().replaceAll('Exception: ', '');

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: theme.colorScheme.error,
              ),
            );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.register)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.space24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Create your company account', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppConstants.space8),
                    Text(
                      'You\'ll be able to invite your team after setup.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.space32),
                    AppTextField(
                      label: AppStrings.fullName,
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: Validators.required,
                      autofillHints: const [AutofillHints.name],
                    ),
                    const SizedBox(height: AppConstants.space16),
                    AppTextField(
                      label: AppStrings.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline,
                      validator: Validators.email,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: AppConstants.space16),
                    AppTextField(
                      label: AppStrings.password,
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      validator: Validators.password,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: AppConstants.space16),
                    AppTextField(
                      label: AppStrings.confirmPassword,
                      controller: _confirmController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      textInputAction: TextInputAction.done,
                      validator: Validators.confirmPassword(() => _passwordController.text),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: AppConstants.space24),
                    PrimaryButton(
                      label: AppStrings.signUp,
                      isLoading: authState.isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppConstants.space24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.haveAccount, style: theme.textTheme.bodyMedium),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            AppStrings.login,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}