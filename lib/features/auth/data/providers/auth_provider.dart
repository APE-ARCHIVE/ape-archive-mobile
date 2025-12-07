import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Auth state
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState()) {
    checkAuthStatus();
  }

  /// Check if user is authenticated on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isAuth = await _authRepository.isAuthenticated();
      if (isAuth) {
        // Try to get cached user first
        final cachedUser = await _authRepository.getCachedUser();
        if (cachedUser != null) {
          state = state.copyWith(
            user: cachedUser,
            isAuthenticated: true,
            isLoading: false,
          );
        }
        
        // Fetch fresh user data in background
        try {
          final user = await _authRepository.getCurrentUser();
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
        } catch (_) {
          // If fetch fails, keep cached user
          state = state.copyWith(isLoading: false);
        }
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  /// Initiate Google Sign-In
  Future<String> initiateGoogleSignIn() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final signInUrl = await _authRepository.initiateGoogleSignIn();
      state = state.copyWith(isLoading: false);
      return signInUrl;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Handle OAuth callback
  Future<void> handleAuthCallback(String accessToken) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authRepository.handleAuthCallback(accessToken);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authRepository.logout();
      state = AuthState(isAuthenticated: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Continue as guest
  void continueAsGuest() {
    state = state.copyWith(
      user: UserModel(
        id: 'guest',
        email: 'guest@apearchive.lk',
        name: 'Guest',
        role: UserRole.guest,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      isAuthenticated: true,
    );
  }
}

/// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
