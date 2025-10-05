import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_application.dart';
import '../repositories/organization_repository.dart';

/// Use case to get all applications for an organization
class GetOrganizationApplications implements UseCase<List<VolunteerApplication>, String> {
  final OrganizationRepository repository;

  GetOrganizationApplications(this.repository);

  @override
  Future<Either<Failure, List<VolunteerApplication>>> call(String organizationId) async {
    return await repository.getOrganizationApplications(organizationId);
  }
}
