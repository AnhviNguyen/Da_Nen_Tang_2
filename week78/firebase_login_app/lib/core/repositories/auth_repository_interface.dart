import '../../core/models/user_model.dart';

/// Interface for authentication operations
/// Follows Interface Segregation Principle (ISP)
abstract class AuthRepositoryInterface {
  /// Get current authentication state stream
  Stream<UserModel?> get authStateChanges;

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Create account with email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Get current user
  UserModel? get currentUser;
}

