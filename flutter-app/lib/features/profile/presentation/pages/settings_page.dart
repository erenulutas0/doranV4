import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch to dark theme'),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionHeader(context, 'Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive push notifications on your device'),
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                  secondary: Icon(
                    Icons.notifications_active_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive notifications via email'),
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                  secondary: Icon(
                    Icons.email_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('SMS Notifications'),
                  subtitle: const Text('Receive notifications via SMS'),
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() {
                      _smsNotifications = value;
                    });
                  },
                  secondary: Icon(
                    Icons.sms_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Order Updates'),
                  subtitle: const Text('Get notified about your order status'),
                  value: _orderUpdates,
                  onChanged: (value) {
                    setState(() {
                      _orderUpdates = value;
                    });
                  },
                  secondary: Icon(
                    Icons.shopping_bag_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Promotional Offers'),
                  subtitle: const Text('Receive offers and discounts'),
                  value: _promotionalOffers,
                  onChanged: (value) {
                    setState(() {
                      _promotionalOffers = value;
                    });
                  },
                  secondary: Icon(
                    Icons.local_offer_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader(context, 'Account'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change password coming soon!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: const Text('Delete Account'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.description_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms & Conditions coming soon!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy Policy coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion coming soon!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

