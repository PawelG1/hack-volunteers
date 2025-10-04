import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../repositories/events_repository.dart';

/// Parameters for applying to an event
class ApplyForEventParams extends Equatable {
  final String eventId;
  final String volunteerId;
  final String? message;

  const ApplyForEventParams({
    required this.eventId,
    required this.volunteerId,
    this.message,
  });

  @override
  List<Object?> get props => [eventId, volunteerId, message];
}

/// Use case to apply for an event (confirm participation)
class ApplyForEvent
    implements UseCase<VolunteerApplication, ApplyForEventParams> {
  final EventsRepository repository;

  ApplyForEvent(this.repository);

  @override
  Future<Either<Failure, VolunteerApplication>> call(
      ApplyForEventParams params) async {
    return await repository.applyForEvent(
      eventId: params.eventId,
      volunteerId: params.volunteerId,
      message: params.message,
    );
  }
}
