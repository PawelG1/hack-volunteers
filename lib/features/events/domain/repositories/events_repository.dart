import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/volunteer_event.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';

/// Abstract repository interface for events
/// Following Dependency Inversion Principle - domain doesn't depend on data layer
abstract class EventsRepository {
  /// Get all available events
  Future<Either<Failure, List<VolunteerEvent>>> getEvents();

  /// Save user's interest in an event (swipe right)
  Future<Either<Failure, void>> saveInterestedEvent(String eventId);

  /// Save user's disinterest in an event (swipe left)
  Future<Either<Failure, void>> saveSkippedEvent(String eventId);

  /// Get events user is interested in
  Future<Either<Failure, List<VolunteerEvent>>> getInterestedEvents();

  /// Apply for event (confirm participation after showing interest)
  Future<Either<Failure, VolunteerApplication>> applyForEvent({
    required String eventId,
    required String volunteerId,
    String? message,
  });

  /// Remove event from interested events (undo swipe right)
  Future<Either<Failure, void>> removeInterestedEvent(String eventId);

  /// Clear all interested events
  Future<Either<Failure, void>> clearAllInterestedEvents();
}
