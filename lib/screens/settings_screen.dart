import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            const SizedBox(height: AppSizes.paddingL),
            _buildPreferencesSection(),
            const SizedBox(height: AppSizes.paddingL),
            _buildAboutSection(),
            const SizedBox(height: AppSizes.paddingL),
            _buildAccountSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anonymous User',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Level 3 • 7 day streak', style: AppTextStyles.body2),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement profile editing
                },
                icon: const Icon(Icons.edit),
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferences', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildPreferenceItem(
                'Daily Reminders',
                'Get notified about daily challenges',
                Icons.notifications,
                true,
              ),
              const Divider(height: 1),
              _buildPreferenceItem(
                'Sound Effects',
                'Play sounds during conversations',
                Icons.volume_up,
                false,
              ),
              const Divider(height: 1),
              _buildPreferenceItem(
                'Dark Mode',
                'Use dark theme',
                Icons.dark_mode,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.body2),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          // TODO: Implement preference saving
        },
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildAboutItem('Privacy Policy', Icons.privacy_tip, () {
                // TODO: Navigate to privacy policy
              }),
              const Divider(height: 1),
              _buildAboutItem('Terms of Service', Icons.description, () {
                // TODO: Navigate to terms of service
              }),
              const Divider(height: 1),
              _buildAboutItem('Help & Support', Icons.help, () {
                // TODO: Navigate to help
              }),
              const Divider(height: 1),
              _buildAboutItem('Rate App', Icons.star, () {
                // TODO: Open app store rating
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.body1),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textLight,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildAccountItem(
                'Export Data',
                'Download your conversation history',
                Icons.download,
                () {
                  // TODO: Implement data export
                },
              ),
              const Divider(height: 1),
              _buildAccountItem(
                'Delete Account',
                'Permanently delete your account and data',
                Icons.delete_forever,
                () => _showDeleteAccountDialog(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingL),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _signOut(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: Text(subtitle, style: AppTextStyles.body2),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textLight,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut();
    Navigator.pop(context);
  }
}
