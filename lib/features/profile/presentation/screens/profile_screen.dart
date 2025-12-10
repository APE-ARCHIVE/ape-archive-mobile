import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/data/providers/auth_provider.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/grid_background.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: user == null ? _buildGuestView(context) : _buildProfileView(context, ref, user),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return SafeArea(
      child: GridBackground(
        backgroundColor: AppColors.backgroundDark,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 80,
                    color: AppColors.primary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome, Guest!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to unlock all features and\npersonalize your learning experience',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.login_rounded),
                      const SizedBox(width: 12),
                      Text(
                        'Sign In',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, WidgetRef ref, user) {
    return SafeArea(
      child: GridBackground(
        backgroundColor: AppColors.backgroundDark,
        child: CustomScrollView(
          slivers: [
            // Profile Header
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar with border
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: user.picture != null
                              ? NetworkImage(user.picture!)
                              : null,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: user.picture == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Email
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getRoleColor(user.role),
                            _getRoleColor(user.role).withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getRoleColor(user.role).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRoleIcon(user.role),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user.role.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _buildSectionTitle(context, 'Account'),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.upload_file_rounded,
                    title: 'My Uploads',
                    subtitle: 'Manage your contributions',
                    gradient: [const Color(0xFF667eea), const Color(0xFF764ba2)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.bookmark_rounded,
                    title: 'Saved Resources',
                    subtitle: 'Your bookmarked materials',
                    gradient: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuCard(
                    context,
                    icon: Icons.history_rounded,
                    title: 'View History',
                    subtitle: 'Recently viewed items',
                    gradient: [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming soon!')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Sign Out Button
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleSignOut(context, ref),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.error.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: AppColors.error,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.4),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error),
            const SizedBox(width: 12),
            const Text('Sign Out'),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      // First logout to clear state
      await ref.read(authProvider.notifier).logout();
      
      // Then navigate with replacement to completely remove previous screens
      if (context.mounted) {
        context.pushReplacement('/login');
      }
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
      case UserRole.teacher:
        return Icons.school_rounded;
      case UserRole.student:
        return Icons.person_rounded;
      case UserRole.guest:
        return Icons.person_outline_rounded;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.admin;
      case UserRole.teacher:
        return AppColors.teacher;
      case UserRole.student:
        return AppColors.student;
      case UserRole.guest:
        return AppColors.guest;
    }
  }
}
