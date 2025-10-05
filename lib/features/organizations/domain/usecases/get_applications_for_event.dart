import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_application.dart';
import '../repositories/organization_repository.dart';

/// Use case to get all applications for a specific event
class GetApplicationsForEvent implements UseCase<List<VolunteerApplication>, String> {
  final OrganizationRepository repository;

  GetApplicationsForEvent(this.repository);

  @override
  Future<Either<Failure, List<VolunteerApplication>>> call(String eventId) async {
    return await repository.getEventApplications(eventId);
  }
}
