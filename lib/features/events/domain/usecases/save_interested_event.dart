import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/events_repository.dart';

/// Use case for saving user's interest in an event (swipe right)
class SaveInterestedEvent implements UseCase<void, SaveInterestedEventParams> {
  final EventsRepository repository;

  SaveInterestedEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveInterestedEventParams params) async {
    return await repository.saveInterestedEvent(params.eventId);
  }
}

class SaveInterestedEventParams extends Equatable {
  final String eventId;

  const SaveInterestedEventParams({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
