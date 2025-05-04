import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/medication.dart';
import 'package:maternity_app/domain/repositories/medication_repository.dart';

/// Use case to get all active medications for a user
class GetActiveMedications {
  final MedicationRepository repository;

  GetActiveMedications(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Medication>>> call(GetActiveMedicationsParams params) async {
    return await repository.getMedications(userId: params.userId);
  }
}

/// Parameters for GetActiveMedications use case
class GetActiveMedicationsParams extends Equatable {
  final String userId;

  const GetActiveMedicationsParams({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
} 