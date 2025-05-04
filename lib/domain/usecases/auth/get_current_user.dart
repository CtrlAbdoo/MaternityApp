import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

/// GetCurrentUser use case from auth repository
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  /// Execute the use case
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
} 