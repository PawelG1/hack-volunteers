import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/organization_repository.dart';

/// Use case to rate a volunteer after an event
class RateVolunteer implements UseCase<void, RateVolunteerParams> {
  final OrganizationRepository repository;

  RateVolunteer(this.repository);

  @override
  Future<Either<Failure, void>> call(RateVolunteerParams params) async {
    return await repository.rateVolunteer(
      applicationId: params.applicationId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

/// Parameters for rating a volunteer
class RateVolunteerParams extends Equatable {
  final String applicationId;
  final double rating;
  final String? comment;

  const RateVolunteerParams({
    required this.applicationId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [applicationId, rating, comment];
}
