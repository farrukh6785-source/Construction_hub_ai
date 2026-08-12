import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_provider.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _verificationId;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (Validators.required(_phoneController.text) != null) {
      setState(() => _error = 'Enter your phone number');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      final id = await repo.signInWithPhone(phoneNumber: _phoneController.text.trim());
      if (mounted) setState(() => _verificationId = id);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _confirmCode() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final AuthRepository repo = ref.read(authRepositoryProvider);
      await repo.confirmPhoneCode(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );
      // authStateChanges() stream picks this up; router redirect navigates on.
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCodeStep = _verificationId != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.space24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.phone_android, size: 44, color: theme.colorScheme.primary),
                  const SizedBox(height: AppConstants.space16),
                  Text(
                    onCodeStep ? 'Enter verification code' : 'Enter your phone number',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.space24),
                  if (!onCodeStep) ...[
                    AppTextField(
                      label: 'Phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _sendCode(),
                    ),
                  ] else ...[
                    Text(
                      'Sent to ${_phoneController.text.trim()}',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.space16),
                    AppTextField(
                      label: '6-digit code',
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.sms_outlined,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _confirmCode(),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: AppConstants.space12),
                    Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                  ],
                  const SizedBox(height: AppConstants.space24),
                  PrimaryButton(
                    label: onCodeStep ? 'Verify & Continue' : 'Send Code',
                    isLoading: _isSubmitting,
                    onPressed: onCodeStep ? _confirmCode : _sendCode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
