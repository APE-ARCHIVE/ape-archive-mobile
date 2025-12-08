import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/library/presentation/screens/library_browse_screen.dart';
import '../../features/library/presentation/screens/resource_detail_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/forum/presentation/screens/forum_list_screen.dart';
import '../../features/forum/presentation/screens/question_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/resources/presentation/screens/pdf_viewer_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import 'app_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade in when entering
            if (secondaryAnimation.status == AnimationStatus.dismissed) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }
            // Fade out when leaving
            return FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: secondaryAnimation,
                  curve: Curves.easeOut,
                ),
              ),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppNavigation(),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Handle splash screen exit
            if (secondaryAnimation.status != AnimationStatus.dismissed) {
              return FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
                child: child,
              );
            }
            
            // Welcoming fade + scale up transition
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Handle splash screen exit
            if (secondaryAnimation.status != AnimationStatus.dismissed) {
              return FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
                child: child,
              );
            }
            
            // iOS-style slide transition for login entrance
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryBrowseScreen(),
      ),
      GoRoute(
        path: '/resource/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ResourceDetailScreen(resourceId: id);
        },
      ),
      GoRoute(
        path: '/pdf',
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? 'PDF';
          final url = state.uri.queryParameters['url'] ?? '';
          return PdfViewerScreen(title: title, streamingUrl: url);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/forum',
        builder: (context, state) => const ForumListScreen(),
      ),
      GoRoute(
        path: '/question/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuestionDetailScreen(questionId: id);
        },
      ),
      GoRoute(
        path: '/upload',
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
