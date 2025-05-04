import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/vaccination.dart';

/// Repository interface for vaccination-related operations
abstract class VaccinationRepository {
  /// Creates a new vaccination record
  Future<Either<Failure, Vaccination>> createVaccination({
    required String name,
    required String description,
    required String userId,
    DateTime? scheduledDate,
    String? pregnancyId,
    String? notes,
  });
  
  /// Gets a vaccination record by ID
  Future<Either<Failure, Vaccination>> getVaccination(String vaccinationId);
  
  /// Gets all vaccination records for a user
  Future<Either<Failure, List<Vaccination>>> getVaccinationsForUser(String userId);
  
  /// Gets all vaccination records for a specific pregnancy
  Future<Either<Failure, List<Vaccination>>> getVaccinationsForPregnancy(String pregnancyId);
  
  /// Updates a vaccination record
  Future<Either<Failure, Vaccination>> updateVaccination({
    required String vaccinationId,
    String? name,
    String? description,
    DateTime? scheduledDate,
    String? notes,
  });
  
  /// Deletes a vaccination record
  Future<Either<Failure, void>> deleteVaccination(String vaccinationId);
  
  /// Marks a vaccination as complete/done
  Future<Either<Failure, Vaccination>> markVaccinationAsDone({
    required String vaccinationId,
    required DateTime administeredDate,
    String? location,
    String? provider,
    String? lotNumber,
    String? notes,
  });
  
  /// Gets all upcoming vaccinations for a user
  Future<Either<Failure, List<Vaccination>>> getUpcomingVaccinations(String userId);
  
  /// Gets all overdue vaccinations for a user
  Future<Either<Failure, List<Vaccination>>> getOverdueVaccinations(String userId);
  
  /// Gets all completed vaccinations for a user
  Future<Either<Failure, List<Vaccination>>> getCompletedVaccinations(String userId);
} 