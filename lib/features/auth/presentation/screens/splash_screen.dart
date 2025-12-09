import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/grid_background.dart';
import '../../data/providers/auth_provider.dart';

/// Modern professional splash screen with sophisticated animations
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _shimmerController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _logoRotation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Pulse animation for glow effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    // Logo fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Logo scale with bounce
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Slide animation for tagline
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Subtle rotation
    _logoRotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Shimmer animation
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.linear,
      ),
    );

    _mainController.forward();
    
    // Initialize app
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    
    // Check authentication status
    final authState = ref.read(authProvider);
    
    if (authState.user != null) {
      // Navigate and remove splash from stack
      context.pushReplacement('/');
    } else {
      // Navigate and remove splash from stack
      context.pushReplacement('/login');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: GridBackground(
        backgroundColor: AppColors.backgroundDark,
        child: Stack(
          children: [
            // Floating particles
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final progress = (_particleController.value + index * 0.1) % 1.0;
                final angle = index * math.pi * 2 / 20;
                final radius = 100.0 + (progress * 150);
                
                return Positioned(
                  left: size.width / 2 + math.cos(angle) * radius - 4,
                  top: size.height / 2 + math.sin(angle) * radius - 4,
                  child: Opacity(
                    opacity: (1 - progress) * 0.6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primary.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          
          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with multiple animation layers
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Animated pulsing glow rings
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 240,
                                      height: 240,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            AppColors.primary.withOpacity(0.0),
                                            AppColors.primary.withOpacity(0.15),
                                            AppColors.primary.withOpacity(0.0),
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              // Outer glow ring
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Logo with shimmer overlay
                              SizedBox(
                                width: 300,
                                height: 300,
                                child: Stack(
                                  children: [
                                    // Logo image
                                    Image.asset(
                                      'assets/icons/Text.png',
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.school_rounded,
                                          size: 120,
                                          color: AppColors.primary,
                                        );
                                      },
                                    ),
                                    // Animated shimmer overlay
                                    AnimatedBuilder(
                                      animation: _shimmerController,
                                      builder: (context, child) {
                                        return Positioned.fill(
                                          child: ShaderMask(
                                            blendMode: BlendMode.srcATop,
                                            shaderCallback: (bounds) {
                                              final value = _shimmerAnimation.value;
                                              return LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.white.withOpacity(0.4),
                                                  Colors.transparent,
                                                ],
                                                stops: [
                                                  (value - 0.3).clamp(0.0, 1.0),
                                                  value.clamp(0.0, 1.0),
                                                  (value + 0.3).clamp(0.0, 1.0),
                                                ],
                                              ).createShader(bounds);
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Minimalistic tagline
                    Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Sri Lanka\'s Digital Learning Hub',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Elegant pulsing dots loader
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              final delay = index * 0.2;
                              final progress = (_pulseController.value + delay) % 1.0;
                              final scale = 0.5 + (0.5 * (1 - (progress - 0.5).abs() * 2));
                              final opacity = 0.3 + (0.7 * (1 - (progress - 0.5).abs() * 2));
                              
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withOpacity(opacity),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(opacity * 0.5),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}

