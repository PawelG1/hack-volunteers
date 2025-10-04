import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../repositories/organization_repository.dart';

class UpdateEvent implements UseCase<VolunteerEvent, UpdateEventParams> {
  final OrganizationRepository repository;

  UpdateEvent(this.repository);

  @override
  Future<Either<Failure, VolunteerEvent>> call(UpdateEventParams params) async {
    return await repository.updateEvent(params.event);
  }
}

class UpdateEventParams {
  final VolunteerEvent event;

  UpdateEventParams({required this.event});
}