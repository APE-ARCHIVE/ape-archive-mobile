import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../features/auth/data/providers/auth_provider.dart';
import 'app_navigation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const AppNavigation(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
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
