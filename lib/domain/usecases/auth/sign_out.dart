import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

/// SignOut use case
class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
} 