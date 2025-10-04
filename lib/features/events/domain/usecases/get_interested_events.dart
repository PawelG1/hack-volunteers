import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_event.dart';
import '../repositories/events_repository.dart';

/// Use case to get events user is interested in (swiped right)
class GetInterestedEvents implements UseCase<List<VolunteerEvent>, NoParams> {
  final EventsRepository repository;

  GetInterestedEvents(this.repository);

  @override
  Future<Either<Failure, List<VolunteerEvent>>> call(NoParams params) async {
    return await repository.getInterestedEvents();
  }
}
