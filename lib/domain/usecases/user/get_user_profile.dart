import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/user_repository.dart';

/// GetUserProfile use case
class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(UserParams params) async {
    return await repository.getUserProfile(userId: params.userId);
  }
}

/// User parameters
class UserParams extends Equatable {
  final String userId;

  const UserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
} 