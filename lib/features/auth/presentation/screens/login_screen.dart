import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/grid_background.dart';
import '../../data/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Navigate to home when authenticated
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && previous?.isAuthenticated != true) {
        // Use pushReplacement to trigger the page transition animation
        context.pushReplacement('/');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: GridBackground(
        backgroundColor: AppColors.backgroundDark,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with refined presentation
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow layer
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.3),
                                Colors.transparent,
                                
                              ],
                              stops: const [0.0, 1.0],
                            ),
                          ),
                        ),
                        // Inner radial glow
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.8],
                            ),
                          ),
                        ),
                        // Logo image with proper background handling
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/icons/Text.png',
                            width: 280,
                            height: 280,
                            fit: BoxFit.contain,
                            // Remove any background color from the image
                            color: null,
                            colorBlendMode: BlendMode.dst,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 0),
                    
                    // Title
                    Text(
                      'Welcome to අපේ Archive',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    Text(
                      'Sri Lanka\'s largest collection of educational resources',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Sign in with Google button
                    if (authState.isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final signInUrl = await ref
                                  .read(authProvider.notifier)
                                  .initiateGoogleSignIn();
                              
                              final uri = Uri.parse(signInUrl);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sign-in failed: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          icon: Image.network(
                            'https://www.google.com/favicon.ico',
                            width: 24,
                            height: 24,
                            errorBuilder: (_, __, ___) => const Icon(Icons.login),
                          ),
                          label: const Text('Sign in with Google'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Continue as guest
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                ref.read(authProvider.notifier).continueAsGuest();
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Continue as Guest'),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Features
                    // Wrap(
                    //   spacing: 24,
                    //   runSpacing: 16,
                    //   alignment: WrapAlignment.center,
                    //   children: [
                    //     _FeatureChip(
                    //       icon: Icons.menu_book,
                    //       label: '10,000+ Resources',
                    //     ),
                    //     _FeatureChip(
                    //       icon: Icons.people,
                    //       label: 'Community Driven',
                    //     ),
                    //     _FeatureChip(
                    //       icon: Icons.download,
                    //       label: 'Free Downloads',
                    //     ),
                    //   ],
                    // ),
                    
                    if (authState.error != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        authState.error!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}

/// Custom painter for squared grid pattern (kept for backward compatibility)
class GridPatternPainter extends CustomPainter {
  final Color gridColor;
  final double gridSize;

  GridPatternPainter({
    required this.gridColor,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor.withOpacity(0.08)
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Avoid drawing border lines on the very edge to prevent frame outlines.
    final double verticalLimit = size.width - gridSize;
    final double horizontalLimit = size.height - gridSize;

    // Draw vertical lines inside the frame.
    for (double x = gridSize; x < verticalLimit; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines inside the frame.
    for (double y = gridSize; y < horizontalLimit; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
