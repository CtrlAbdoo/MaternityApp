import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

class SignOutUser {
  final AuthRepository repository;

  SignOutUser(this.repository);

  /// Signs out the current user
  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
} 