import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/medication.dart';
import 'package:maternity_app/domain/repositories/medication_repository.dart';

/// GetMedications use case
class GetMedications {
  final MedicationRepository repository;

  GetMedications(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Medication>>> call(GetMedicationsParams params) async {
    return await repository.getMedications(
      userId: params.userId,
    );
  }
}

/// Get medications parameters
class GetMedicationsParams extends Equatable {
  final String userId;
  final String? pregnancyId;

  const GetMedicationsParams({
    required this.userId,
    this.pregnancyId,
  });

  @override
  List<Object?> get props => [userId, pregnancyId];
} 