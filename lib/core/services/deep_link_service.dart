import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService();
});

/// Service to handle deep links for OAuth callbacks
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep link handling
  Future<void> initialize({
    required Function(Uri) onLinkReceived,
  }) async {
    try {
      // Handle deep link when app is already running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          debugPrint('Deep link received: $uri');
          onLinkReceived(uri);
        },
        onError: (err) {
          debugPrint('Deep link error: $err');
        },
      );

      // Handle initial deep link when app is launched from a deep link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        onLinkReceived(initialUri);
      }
    } catch (e) {
      debugPrint('Error initializing deep links: $e');
    }
  }

  /// Dispose the service
  void dispose() {
    _linkSubscription?.cancel();
  }
}
