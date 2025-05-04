import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/data/models/user_model.dart';

/// AuthRemoteDataSource interface for authentication operations
abstract class AuthRemoteDataSource {
  /// Get the current authenticated user
  Future<UserModel> getCurrentUser();
  
  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });
  
  /// Create a new user with email and password
  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });
  
  /// Sign out the current user
  Future<void> signOut();
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail({
    required String email,
  });
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}

/// Firebase implementation of authentication data source
class FirebaseAuthDataSource implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth auth;

  FirebaseAuthDataSource({required this.auth});
  
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final firebaseUser = auth.currentUser;
      
      if (firebaseUser == null) {
        throw AuthException(message: 'User not authenticated');
      }
      
      return UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber,
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: firebaseUser.metadata.creationTime,
      );
    } catch (e) {
      throw AuthException(
        message: 'Failed to get current user: ${e.toString()}',
        code: 'get-current-user-failed',
      );
    }
  }
  
  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = result.user;
      
      if (firebaseUser == null) {
        throw AuthException(message: 'Sign in failed: user is null');
      }
      
      return UserModel(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber,
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: firebaseUser.metadata.creationTime,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseErrorToMessage(e),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(
        message: 'Sign in failed: ${e.toString()}',
        code: 'sign-in-failed',
      );
    }
  }
  
  @override
  Future<UserModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = result.user;
      
      if (firebaseUser == null) {
        throw AuthException(message: 'Sign up failed: user is null');
      }
      
      // Update the display name
      await firebaseUser.updateDisplayName(name);
      
      // Reload to get updated data
      await firebaseUser.reload();
      
      return UserModel(
        id: firebaseUser.uid,
        name: name,
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber,
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: firebaseUser.metadata.creationTime,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseErrorToMessage(e),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(
        message: 'Sign up failed: ${e.toString()}',
        code: 'sign-up-failed',
      );
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw AuthException(
        message: 'Sign out failed: ${e.toString()}',
        code: 'sign-out-failed',
      );
    }
  }
  
  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        message: _mapFirebaseErrorToMessage(e),
        code: e.code,
      );
    } catch (e) {
      throw AuthException(
        message: 'Password reset failed: ${e.toString()}',
        code: 'password-reset-failed',
      );
    }
  }
  
  @override
  Future<bool> isAuthenticated() async {
    return auth.currentUser != null;
  }
  
  /// Maps Firebase error codes to user-friendly messages
  String _mapFirebaseErrorToMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return e.message ?? 'An unknown error occurred';
    }
  }
} 