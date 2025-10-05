import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_application.dart';
import '../repositories/organization_repository.dart';

/// Use case to accept a volunteer application
class AcceptApplication implements UseCase<VolunteerApplication, String> {
  final OrganizationRepository repository;

  AcceptApplication(this.repository);

  @override
  Future<Either<Failure, VolunteerApplication>> call(String applicationId) async {
    return await repository.acceptApplication(applicationId);
  }
}
