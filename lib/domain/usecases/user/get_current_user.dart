import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

/// Use case to get the current authenticated user
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  /// Call the repository to get the current user
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
} 