import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';

/// Repository interface for user profile operations
abstract class UserRepository {
  /// Get user profile data
  Future<Either<Failure, User>> getUserProfile({
    required String userId,
  });
  
  /// Update user profile
  Future<Either<Failure, User>> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  });
  
  /// Delete user profile
  Future<Either<Failure, void>> deleteUserProfile({
    required String userId,
  });
  
  /// Save user data locally for offline use
  Future<Either<Failure, void>> cacheUserData({
    required User user,
  });
  
  /// Get cached user data
  Future<Either<Failure, User>> getCachedUserData();
} 