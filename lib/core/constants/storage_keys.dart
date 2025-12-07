/// Storage keys for local persistence
class StorageKeys {
  StorageKeys._();

  // Secure Storage Keys (flutter_secure_storage)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';

  // Shared Preferences Keys
  static const String isFirstLaunch = 'is_first_launch';
  static const String locale = 'locale';
  static const String themeMode = 'theme_mode';
  static const String lastSyncTime = 'last_sync_time';
  static const String userRole = 'user_role';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userPicture = 'user_picture';

  // Cache Keys
  static const String cachedHierarchy = 'cached_hierarchy';
  static const String cachedAnnouncements = 'cached_announcements';
  static const String recentSearches = 'recent_searches';
  static const String downloadedResources = 'downloaded_resources';
}
