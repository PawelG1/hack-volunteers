import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/domain/entities/certificate.dart';

/// Repository for volunteer-specific operations
abstract class VolunteerRepository {
  /// Get all available events for swiping
  Future<Either<Failure, List<VolunteerEvent>>> getAvailableEvents();

  /// Apply to volunteer for an event
  Future<Either<Failure, VolunteerApplication>> applyForEvent({
    required String volunteerId,
    required String eventId,
    String? motivation,
  });

  /// Cancel application
  Future<Either<Failure, void>> cancelApplication(String applicationId);

  /// Get volunteer's applications
  Future<Either<Failure, List<VolunteerApplication>>>
      getVolunteerApplications(String volunteerId);

  /// Get volunteer's certificates
  Future<Either<Failure, List<Certificate>>> getVolunteerCertificates(
      String volunteerId);

  /// Get volunteer statistics
  Future<Either<Failure, Map<String, dynamic>>> getVolunteerStatistics(
      String volunteerId);

  /// Mark event as interested (like)
  Future<Either<Failure, void>> markEventAsInterested(String eventId);

  /// Mark event as skipped (dislike)
  Future<Either<Failure, void>> markEventAsSkipped(String eventId);
}
