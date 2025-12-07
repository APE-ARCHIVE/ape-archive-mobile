import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageServiceProvider),
  );
});

class AuthRepository {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthRepository({
    required Dio dio,
    required SecureStorageService secureStorage,
  })  : _dio = dio,
        _secureStorage = secureStorage;

  /// Initialize Google Sign-In and redirect to backend OAuth
  Future<String> initiateGoogleSignIn() async {
    try {
      // Get Google sign-in URL from backend
      final signInUrl = '${ApiConstants.baseApiUrl}${ApiConstants.authGoogleSignIn}';
      return signInUrl;
    } on DioException catch (e) {
      throw AuthException(
        message: e.response?.data['message'] ?? 'Failed to initiate sign-in',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred: $e');
    }
  }

  /// Handle OAuth callback with access token from deep link
  Future<UserModel> handleAuthCallback(String accessToken) async {
    try {
      // Store token
      await _secureStorage.write(StorageKeys.accessToken, accessToken);

      // Fetch user profile
      final user = await getCurrentUser();
      
      // Cache user data
      await _cacheUserData(user);
      
      return user;
    } catch (e) {
      throw AuthException(message: 'Failed to complete authentication: $e');
    }
  }

  /// Get current authenticated user
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseApiUrl}${ApiConstants.authMe}',
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
        throw AuthException(message: 'Session expired', statusCode: 401);
      }
      throw AuthException(
        message: e.response?.data['message'] ?? 'Failed to get user',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Backend doesn't have logout endpoint, just clear local storage
    } catch (_) {
      // Ignore logout errors
    } finally {
      // Clear local storage
      await _secureStorage.delete(StorageKeys.accessToken);
      await _secureStorage.delete(StorageKeys.userId);
      await _secureStorage.delete(StorageKeys.userName);
      await _secureStorage.delete(StorageKeys.userEmail);
      await _secureStorage.delete(StorageKeys.userRole);
      
      // Sign out from Google
      await _googleSignIn.signOut();
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  /// Get cached user data
  Future<UserModel?> getCachedUser() async {
    final userId = await _secureStorage.read(StorageKeys.userId);
    if (userId == null) return null;

    final name = await _secureStorage.read(StorageKeys.userName);
    final email = await _secureStorage.read(StorageKeys.userEmail);
    final roleStr = await _secureStorage.read(StorageKeys.userRole);
    
    if (name == null || email == null || roleStr == null) return null;

    return UserModel(
      id: userId,
      name: name,
      email: email,
      role: UserRole.values.firstWhere(
        (r) => r.toString().split('.').last == roleStr,
        orElse: () => UserRole.guest,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Cache user data locally
  Future<void> _cacheUserData(UserModel user) async {
    await _secureStorage.write(StorageKeys.userId, user.id);
    await _secureStorage.write(StorageKeys.userName, user.name);
    await _secureStorage.write(StorageKeys.userEmail, user.email);
    await _secureStorage.write(
      StorageKeys.userRole,
      user.role.toString().split('.').last,
    );
    if (user.picture != null) {
      await _secureStorage.write(StorageKeys.userPicture, user.picture!);
    }
  }
}
