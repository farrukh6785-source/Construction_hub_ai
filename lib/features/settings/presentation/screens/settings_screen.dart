import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/core_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlerts = true;
  String _language = 'English';
  String _currency = 'PKR';

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionLabel('Appearance'),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (mode) {
                if (mode != null) ref.read(themeModeProvider.notifier).setMode(mode);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              underline: const SizedBox.shrink(),
              items: const ['English', 'Urdu', 'Arabic'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (v) => setState(() => _language = v!),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency'),
            trailing: DropdownButton<String>(
              value: _currency,
              underline: const SizedBox.shrink(),
              items: const ['PKR', 'USD', 'AED', 'GBP'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _currency = v!),
            ),
          ),
          const Divider(),
          const _SectionLabel('Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Push Notifications'),
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.mail_outline),
            title: const Text('Email Alerts'),
            value: _emailAlerts,
            onChanged: (v) => setState(() => _emailAlerts = v),
          ),
          const Divider(),
          const _SectionLabel('Privacy & Security'),
          ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Change Password'), trailing: const Icon(Icons.chevron_right), onTap: () => _snack(context, 'Change Password')),
          ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Privacy Policy'), trailing: const Icon(Icons.chevron_right), onTap: () => _snack(context, 'Privacy Policy')),
          ListTile(leading: const Icon(Icons.backup_outlined), title: const Text('Backup & Sync'), trailing: const Icon(Icons.chevron_right), onTap: () => _snack(context, 'Backup & Sync')),
          const Divider(),
          const _SectionLabel('About'),
          ListTile(leading: const Icon(Icons.info_outline), title: const Text('About ConstructionHub AI'), subtitle: const Text('v0.1.0 · mock-data build'), onTap: () => _snack(context, 'About')),
          ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & Support'), trailing: const Icon(Icons.chevron_right), onTap: () => _snack(context, 'Help & Support')),
          const Divider(),
          const _SectionLabel('Account'),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF5B6472)),
            title: const Text('Sign Out'),
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Color(0xFFD8453C)),
            title: const Text('Delete Account', style: TextStyle(color: Color(0xFFD8453C))),
            onTap: () => _confirmDelete(context),
          ),
          const SizedBox(height: AppConstants.space32),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label — not wired up in this mock build')));
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text('This permanently deletes your account and all associated data. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD8453C)),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(authRepositoryProvider).deleteAccount();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppConstants.space16, AppConstants.space16, AppConstants.space16, AppConstants.space4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    );
  }
}
