import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/repositories/user_repository.dart';

/// UpdateUserProfile use case
class UpdateUserProfile {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  /// Execute the use case
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    return await repository.updateUserProfile(
      userId: params.userId,
      name: params.name,
      phoneNumber: params.phoneNumber,
      photoUrl: params.photoUrl,
    );
  }
}

/// Update user parameters
class UpdateUserParams extends Equatable {
  final String userId;
  final String? name;
  final String? phoneNumber;
  final String? photoUrl;

  const UpdateUserParams({
    required this.userId,
    this.name,
    this.phoneNumber,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [userId, name, phoneNumber, photoUrl];
} 