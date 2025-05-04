import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/medication.dart';
import 'package:maternity_app/domain/repositories/medication_repository.dart';

/// AddMedication use case
class AddMedication {
  final MedicationRepository repository;

  AddMedication(this.repository);

  /// Execute the use case
  Future<Either<Failure, Medication>> call(AddMedicationParams params) async {
    return await repository.addMedication(
      userId: params.medication.userId,
      name: params.medication.name,
      dosage: params.medication.dosage,
      frequency: params.medication.frequency,
      startDate: params.medication.startDate,
      endDate: params.medication.endDate,
      notes: params.medication.notes,
    );
  }
}

/// Add medication parameters
class AddMedicationParams extends Equatable {
  final Medication medication;

  const AddMedicationParams({required this.medication});

  @override
  List<Object?> get props => [medication];
} 