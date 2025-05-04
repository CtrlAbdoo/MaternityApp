import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/pregnancy.dart';

/// Repository interface for pregnancy operations
abstract class PregnancyRepository {
  /// Get current active pregnancy for a user
  Future<Either<Failure, Pregnancy?>> getCurrentPregnancy({
    required String userId,
  });
  
  /// Get all pregnancies for a user
  Future<Either<Failure, List<Pregnancy>>> getPregnancies({
    required String userId,
  });
  
  /// Get a specific pregnancy
  Future<Either<Failure, Pregnancy>> getPregnancy({
    required String pregnancyId,
  });
  
  /// Create a new pregnancy record
  Future<Either<Failure, Pregnancy>> createPregnancy({
    required String userId,
    required DateTime dueDate,
    DateTime? startDate,
  });
  
  /// Update an existing pregnancy record
  Future<Either<Failure, Pregnancy>> updatePregnancy({
    required String pregnancyId,
    required String userId,
    DateTime? dueDate,
    DateTime? startDate,
    int? babyCount,
  });
  
  /// End a pregnancy
  Future<Either<Failure, Pregnancy>> endPregnancy({
    required String pregnancyId,
    required DateTime endDate,
    String? outcome,
    String? notes,
  });
  
  /// Delete a pregnancy record
  Future<Either<Failure, void>> deletePregnancy({
    required String pregnancyId,
  });
  
  /// Adds a health check to a pregnancy
  Future<Either<Failure, Pregnancy>> addHealthCheck({
    required String pregnancyId,
    required HealthCheck healthCheck,
  });
  
  /// Updates a health check
  Future<Either<Failure, Pregnancy>> updateHealthCheck({
    required String pregnancyId,
    required HealthCheck healthCheck,
  });
  
  /// Deletes a health check
  Future<Either<Failure, Pregnancy>> deleteHealthCheck({
    required String pregnancyId,
    required String healthCheckId,
  });
  
  /// Add a note to a pregnancy record
  Future<Either<Failure, Pregnancy>> addPregnancyNote({
    required String pregnancyId,
    required String userId,
    required String note,
  });
} 