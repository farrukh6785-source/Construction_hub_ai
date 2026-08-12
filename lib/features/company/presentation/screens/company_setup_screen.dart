import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class CompanySetupScreen extends ConsumerStatefulWidget {
  const CompanySetupScreen({super.key});

  @override
  ConsumerState<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends ConsumerState<CompanySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  String _businessType = 'General Contractor';
  String _currency = 'PKR';
  bool _saving = false;

  static const _businessTypes = ['General Contractor', 'Real Estate Developer', 'Subcontractor', 'Consultancy'];
  static const _currencies = ['PKR', 'USD', 'AED', 'GBP', 'EUR'];

  @override
  void dispose() {
    _companyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 500)); // mock save
    // Attach a companyId so the router's redirect moves past this screen.
    ref.read(mockCompanyIdProvider.notifier).state = 'mock-company-001';
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Your Company')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.space24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.apartment_rounded, size: 44, color: theme.colorScheme.primary),
                  const SizedBox(height: AppConstants.space16),
                  Text('Tell us about your company', style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: AppConstants.space8),
                  Text(
                    'This sets up your workspace — you can invite your team afterward.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.space32),
                  AppTextField(
                    label: 'Company Name',
                    controller: _companyController,
                    prefixIcon: Icons.business_outlined,
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppConstants.space16),
                  AppTextField(
                    label: 'Company Address',
                    controller: _addressController,
                    prefixIcon: Icons.location_on_outlined,
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppConstants.space16),
                  DropdownButtonFormField<String>(
                    value: _businessType,
                    decoration: const InputDecoration(labelText: 'Business Type', prefixIcon: Icon(Icons.category_outlined)),
                    items: _businessTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _businessType = v!),
                  ),
                  const SizedBox(height: AppConstants.space16),
                  DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(labelText: 'Currency', prefixIcon: Icon(Icons.attach_money)),
                    items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _currency = v!),
                  ),
                  const SizedBox(height: AppConstants.space32),
                  PrimaryButton(label: 'Complete Setup', isLoading: _saving, onPressed: _finish),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The auth stub's UserEntity.companyId is immutable once created, so
/// Company Setup completion is tracked here instead — the router's
/// redirect checks `effectiveNeedsCompanySetup` (see auth_provider.dart)
/// which combines both.
final mockCompanyIdProvider = StateProvider<String?>((ref) => null);
