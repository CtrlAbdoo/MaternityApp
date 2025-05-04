import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

class CreateUser {
  final AuthRepository repository;

  CreateUser(this.repository);

  /// Creates a new user with email and password
  Future<Either<Failure, User>> call(CreateUserParams params) async {
    return await repository.signUpWithEmail(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for creating a user
class CreateUserParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const CreateUserParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
} 