import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../mock/mock_data_service.dart';
import '../../../../mock/mock_models.dart';

class ProjectFormScreen extends ConsumerStatefulWidget {
  const ProjectFormScreen({super.key});

  @override
  ConsumerState<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends ConsumerState<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clientController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _managerController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _clientController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 400));

    final data = ref.read(mockDataProvider);
    final id = 'P-${(100 + data.projects.length + 1)}';
    data.addProject(ProjectModel(
      id: id,
      name: _nameController.text.trim(),
      client: _clientController.text.trim(),
      location: _locationController.text.trim(),
      status: ProjectStatus.planning,
      progress: 0,
      budget: double.tryParse(_budgetController.text.trim()) ?? 0,
      spent: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 180)),
      manager: _managerController.text.trim(),
      workersOnSite: 0,
    ));

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project "${_nameController.text.trim()}" created')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Project')),
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
                  AppTextField(label: 'Project Name', controller: _nameController, prefixIcon: Icons.apartment_outlined, validator: Validators.required),
                  const SizedBox(height: AppConstants.space16),
                  AppTextField(label: 'Client', controller: _clientController, prefixIcon: Icons.handshake_outlined, validator: Validators.required),
                  const SizedBox(height: AppConstants.space16),
                  AppTextField(label: 'Location', controller: _locationController, prefixIcon: Icons.location_on_outlined, validator: Validators.required),
                  const SizedBox(height: AppConstants.space16),
                  AppTextField(label: 'Budget (PKR)', controller: _budgetController, prefixIcon: Icons.attach_money, keyboardType: TextInputType.number, validator: Validators.required),
                  const SizedBox(height: AppConstants.space16),
                  AppTextField(label: 'Project Manager', controller: _managerController, prefixIcon: Icons.person_outline, validator: Validators.required, textInputAction: TextInputAction.done),
                  const SizedBox(height: AppConstants.space32),
                  PrimaryButton(label: 'Create Project', isLoading: _saving, onPressed: _save),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
