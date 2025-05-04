import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/vaccination.dart';
import 'package:maternity_app/domain/repositories/vaccination_repository.dart';

/// Use case to get all upcoming vaccinations for a user
class GetUpcomingVaccinations {
  final VaccinationRepository repository;

  GetUpcomingVaccinations(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Vaccination>>> call(GetUpcomingVaccinationsParams params) async {
    return await repository.getUpcomingVaccinations(params.userId);
  }
}

/// Parameters for GetUpcomingVaccinations use case
class GetUpcomingVaccinationsParams extends Equatable {
  final String userId;

  const GetUpcomingVaccinationsParams({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
} 