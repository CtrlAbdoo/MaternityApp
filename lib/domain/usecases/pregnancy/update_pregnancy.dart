import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/pregnancy.dart';
import 'package:maternity_app/domain/repositories/pregnancy_repository.dart';

/// UpdatePregnancy use case
class UpdatePregnancy {
  final PregnancyRepository repository;

  UpdatePregnancy(this.repository);

  /// Execute the use case
  Future<Either<Failure, Pregnancy>> call(UpdatePregnancyParams params) async {
    final pregnancy = params.pregnancy;
    return await repository.updatePregnancy(
      pregnancyId: pregnancy.id,
      userId: pregnancy.userId,
      dueDate: pregnancy.dueDate,
      startDate: pregnancy.startDate,
      babyCount: pregnancy.babyCount,
    );
  }
}

/// Update pregnancy parameters
class UpdatePregnancyParams extends Equatable {
  final Pregnancy pregnancy;

  const UpdatePregnancyParams({required this.pregnancy});

  @override
  List<Object?> get props => [pregnancy];
} 