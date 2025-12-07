/// API Constants for Ape Archive backend
class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://server.apearchive.lk';
  static const String apiVersion = '/api/v1';
  static const String baseApiUrl = '$baseUrl$apiVersion';

  // Authentication Endpoints
  static const String authGoogleSignIn = '/auth/google';
  static const String authGoogleCallback = '/auth/google/callback';
  static const String authMe = '/auth/me';
  static const String authOnboard = '/auth/onboard';

  // Library Endpoints
  static const String libraryHierarchy = '/library/hierarchy';
  static const String libraryBrowse = '/library/browse';
  static const String libraryTags = '/library/tags';

  // Resource Endpoints
  static const String resources = '/resources';
  static const String resourceById = '/resources'; // + /{id}
  static const String resourceUpload = '/resources/upload';
  static const String resourceStream = '/resources'; // + /{id}/stream

  // Tag Endpoints
  static const String tags = '/tags';
  static const String tagsGrouped = '/tags/grouped';
  static const String tagById = '/tags'; // + /{id}

  // Forum Endpoints
  static const String forum = '/forum';
  static const String forumById = '/forum'; // + /{id}
  static const String forumAnswers = '/forum'; // + /{id}/answers
  static const String forumAcceptAnswer = '/forum'; // + /{id}/answers/{answerId}/accept
  static const String forumVoteAnswer = '/forum/answers'; // + /{id}/vote

  // Teacher Endpoints
  static const String teachers = '/teachers';
  static const String teacherById = '/teachers'; // + /{id}
  static const String teacherAvailability = '/teachers'; // + /{id}/availability

  // Announcement Endpoints
  static const String announcements = '/announcements';
  static const String announcementById = '/announcements'; // + /{id}

  // Deep Link Scheme
  static const String deepLinkScheme = 'apearchive';
  static const String authDeepLink = '$deepLinkScheme://auth';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheMaxAge = Duration(hours: 24);
  static const Duration cacheStaleDuration = Duration(minutes: 15);

  // Headers
  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerAccept = 'Accept';
  static const String headerRange = 'Range';

  // Content Types
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';
}
