import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../repositories/organization_repository.dart';

class GetOrganizationEvents implements UseCase<List<VolunteerEvent>, GetOrganizationEventsParams> {
  final OrganizationRepository repository;

  GetOrganizationEvents(this.repository);

  @override
  Future<Either<Failure, List<VolunteerEvent>>> call(GetOrganizationEventsParams params) async {
    return await repository.getOrganizationEvents(params.organizationId);
  }
}

class GetOrganizationEventsParams {
  final String organizationId;

  GetOrganizationEventsParams({required this.organizationId});
}