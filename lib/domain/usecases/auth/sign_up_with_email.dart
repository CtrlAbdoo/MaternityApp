import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

/// SignUpWithEmail use case
class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUpWithEmail(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

/// SignUp parameters
class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
} 