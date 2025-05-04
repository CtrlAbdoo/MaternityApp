import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/pregnancy.dart';
import 'package:maternity_app/domain/repositories/pregnancy_repository.dart';

/// GetCurrentPregnancy use case
class GetCurrentPregnancy {
  final PregnancyRepository repository;

  GetCurrentPregnancy(this.repository);

  /// Execute the use case
  Future<Either<Failure, Pregnancy?>> call(PregnancyParams params) async {
    return await repository.getCurrentPregnancy(userId: params.userId);
  }
}

/// Pregnancy parameters
class PregnancyParams extends Equatable {
  final String userId;

  const PregnancyParams({required this.userId});

  @override
  List<Object?> get props => [userId];
} 