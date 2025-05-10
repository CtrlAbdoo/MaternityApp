import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/core/network/network_info.dart';
import 'package:maternity_app/data/datasources/medication_remote_datasource.dart';
import 'package:maternity_app/domain/entities/medication.dart';
import 'package:maternity_app/domain/repositories/medication_repository.dart';

/// Implementation of MedicationRepository
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MedicationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Medication>>> getMedications({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final medications = await remoteDataSource.getMedications(userId: userId);
        return Right(medications);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Medication>> addMedication({
    required String userId,
    required String name,
    required String dosage,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final medication = await remoteDataSource.addMedication(
          userId: userId,
          name: name,
          dosage: dosage,
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          notes: notes,
        );
        return Right(medication);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final medication = await remoteDataSource.updateMedication(
          medicationId: medicationId,
          userId: userId,
          name: name,
          dosage: dosage,
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          notes: notes,
          isActive: isActive,
        );
        return Right(medication);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedication({
    required String medicationId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteMedication(
          medicationId: medicationId,
          userId: userId,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
} 