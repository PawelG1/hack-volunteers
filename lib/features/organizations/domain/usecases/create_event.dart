import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../repositories/organization_repository.dart';

class CreateEvent implements UseCase<VolunteerEvent, CreateEventParams> {
  final OrganizationRepository repository;

  CreateEvent(this.repository);

  @override
  Future<Either<Failure, VolunteerEvent>> call(CreateEventParams params) async {
    return await repository.createEvent(params.event);
  }
}

class CreateEventParams {
  final VolunteerEvent event;

  CreateEventParams({required this.event});
}