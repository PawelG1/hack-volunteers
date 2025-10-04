import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/events_repository.dart';

/// Use case for saving user's disinterest in an event (swipe left)
class SaveSkippedEvent implements UseCase<void, SaveSkippedEventParams> {
  final EventsRepository repository;

  SaveSkippedEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveSkippedEventParams params) async {
    return await repository.saveSkippedEvent(params.eventId);
  }
}

class SaveSkippedEventParams extends Equatable {
  final String eventId;

  const SaveSkippedEventParams({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
