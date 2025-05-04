import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/auth_repository.dart';

/// Use case to sign in a user with email and password
class SignInUser {
  final AuthRepository repository;

  SignInUser(this.repository);

  /// Signs in a user with email and password
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for sign in
class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
} 