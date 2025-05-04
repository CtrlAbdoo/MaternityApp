import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/medication.dart';

/// Repository interface for medication operations
abstract class MedicationRepository {
  /// Get medications for a user
  Future<Either<Failure, List<Medication>>> getMedications({
    required String userId,
  });
  
  /// Add a new medication
  Future<Either<Failure, Medication>> addMedication({
    required String userId,
    required String name,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  });
  
  /// Update an existing medication
  Future<Either<Failure, Medication>> updateMedication({
    required String medicationId,
    required String userId,
    String? name,
    String? dosage,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
  });
  
  /// Delete a medication
  Future<Either<Failure, void>> deleteMedication({
    required String medicationId,
    required String userId,
  });
} 