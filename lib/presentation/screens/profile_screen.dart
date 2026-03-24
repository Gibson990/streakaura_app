import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppConstants.accentTeal.withOpacity(0.2),
                    child: Text(
                      _initials(user?.displayName ?? user?.email ?? 'U'),
                      style: textTheme.displayMedium?.copyWith(
                        color: AppConstants.accentTeal,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    user?.displayName ?? 'StreakAura Member',
                    style: textTheme.displayMedium,
                  ),
                  const Gap(4),
                  Text(
                    user?.email ?? 'No email connected',
                    style: textTheme.bodyMedium,
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(
                        icon: Icons.verified_user,
                        label: user?.emailVerified == true
                            ? 'Email verified'
                            : 'Email not verified',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(24),
            Text('Account', style: textTheme.displayMedium),
            const Gap(12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge),
                title: const Text('User ID'),
                subtitle: Text(user?.uid ?? 'Not available'),
              ),
            ),
            const Gap(12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                subtitle: const Text('Sign out of this device'),
                onTap: () async {
                  await AuthService().signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(' ');
    if (parts.length == 1 && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return 'U';
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const Gap(6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
