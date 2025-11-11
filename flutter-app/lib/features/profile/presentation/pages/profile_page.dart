import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.userName ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authProvider.userEmail ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Menu Items
          _ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {
              context.push('/profile/edit');
            },
          ),
          _ProfileMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Addresses',
            onTap: () {
              context.push('/profile/addresses');
            },
          ),
          _ProfileMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment methods coming soon!')),
              );
            },
          ),
          _ProfileMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
          _ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              context.push('/profile/settings');
            },
          ),
          _ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              context.push('/profile/help');
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              authProvider.logout();
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

