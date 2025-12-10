import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'features/auth/data/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Explicitly disable all debug visual aids
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugRepaintRainbowEnabled = false;

  // Configure System UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    const ProviderScope(
      child: ApeArchiveApp(),
    ),
  );
}

class ApeArchiveApp extends ConsumerStatefulWidget {
  const ApeArchiveApp({super.key});

  @override
  ConsumerState<ApeArchiveApp> createState() => _ApeArchiveAppState();
}

class _ApeArchiveAppState extends ConsumerState<ApeArchiveApp> {
  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
  }

  void _initializeDeepLinks() {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    
    deepLinkService.initialize(
      onLinkReceived: (Uri uri) {
        _handleDeepLink(uri);
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Handling deep link: $uri');
    
    // Check if it's an auth callback
    if (uri.scheme == 'apearchive' && uri.host == 'auth') {
      final accessToken = uri.queryParameters['access_token'];
      
      if (accessToken != null && accessToken.isNotEmpty) {
        debugPrint('Access token received from deep link');
        // Handle the auth callback
        ref.read(authProvider.notifier).handleAuthCallback(accessToken);
      } else {
        debugPrint('No access token in deep link');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return Container(
      color: const Color(0xFF121212), // Block any system UI colors
      child: MaterialApp.router(
        title: 'Ape Archive',
        color: const Color(0xFF121212), // Set primary color for system UI
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: false,
        checkerboardRasterCacheImages: false,
        checkerboardOffscreenLayers: false,
        showSemanticsDebugger: false,
        debugShowMaterialGrid: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Default to dark theme
        routerConfig: router,
      ),
    );
  }
  
  @override
  void dispose() {
    ref.read(deepLinkServiceProvider).dispose();
    super.dispose();
  }
}
