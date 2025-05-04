import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Get the current authenticated user
  Future<Either<Failure, User>> getCurrentUser();
  
  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmail({
    required String email, 
    required String password
  });
  
  /// Create a new user with email and password
  Future<Either<Failure, User>> signUpWithEmail({
    required String name,
    required String email, 
    required String password
  });
  
  /// Sign out the current user
  Future<Either<Failure, void>> signOut();
  
  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email
  });
  
  /// Check if user is currently authenticated
  Future<Either<Failure, bool>> isAuthenticated();
} 