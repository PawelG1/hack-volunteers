import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/events_repository.dart';

/// Use case for removing event from interested events
/// Parameters: event ID
class RemoveInterestedEvent implements UseCase<void, String> {
  final EventsRepository repository;

  RemoveInterestedEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(String eventId) async {
    return await repository.removeInterestedEvent(eventId);
  }
}
