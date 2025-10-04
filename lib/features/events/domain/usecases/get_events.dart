import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_event.dart';
import '../repositories/events_repository.dart';

/// Use case for getting all available events
/// Single Responsibility Principle - one use case, one responsibility
class GetEvents implements UseCase<List<VolunteerEvent>, NoParams> {
  final EventsRepository repository;

  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<VolunteerEvent>>> call(NoParams params) async {
    return await repository.getEvents();
  }
}
