import 'package:dartz/dartz.dart';
import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/core/network/network_info.dart';
import 'package:maternity_app/data/datasources/pregnancy_remote_datasource.dart';
import 'package:maternity_app/domain/entities/pregnancy.dart';
import 'package:maternity_app/domain/repositories/pregnancy_repository.dart';

/// Implementation of PregnancyRepository
class PregnancyRepositoryImpl implements PregnancyRepository {
  final PregnancyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PregnancyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Pregnancy?>> getCurrentPregnancy({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pregnancy = await remoteDataSource.getCurrentPregnancy(userId: userId);
        return Right(pregnancy);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Pregnancy>> createPregnancy({
    required String userId,
    required DateTime dueDate,
    DateTime? startDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pregnancy = await remoteDataSource.createPregnancy(
          userId: userId,
          dueDate: dueDate,
          startDate: startDate,
        );
        return Right(pregnancy);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Pregnancy>> updatePregnancy({
    required String pregnancyId,
    required String userId,
    DateTime? dueDate,
    DateTime? startDate,
    int? babyCount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pregnancy = await remoteDataSource.updatePregnancy(
          pregnancyId: pregnancyId,
          userId: userId,
          dueDate: dueDate,
          startDate: startDate,
          babyCount: babyCount,
        );
        return Right(pregnancy);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Pregnancy>> addPregnancyNote({
    required String pregnancyId,
    required String userId,
    required String note,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final pregnancy = await remoteDataSource.addPregnancyNote(
          pregnancyId: pregnancyId,
          userId: userId,
          note: note,
        );
        return Right(pregnancy);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<Pregnancy>>> getPregnancies({
    required String userId,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
  
  @override
  Future<Either<Failure, Pregnancy>> getPregnancy({
    required String pregnancyId,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
  
  @override
  Future<Either<Failure, Pregnancy>> endPregnancy({
    required String pregnancyId,
    required DateTime endDate,
    String? outcome,
    String? notes,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
  
  @override
  Future<Either<Failure, void>> deletePregnancy({
    required String pregnancyId,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
  
  @override
  Future<Either<Failure, Pregnancy>> addHealthCheck({
    required String pregnancyId,
    required HealthCheck healthCheck,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
  
  @override
  Future<Either<Failure, Pregnancy>> updateHealthCheck({
    required String pregnancyId,
    required HealthCheck healthCheck,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
  
  @override
  Future<Either<Failure, Pregnancy>> deleteHealthCheck({
    required String pregnancyId,
    required String healthCheckId,
  }) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
} 