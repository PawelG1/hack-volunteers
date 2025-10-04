import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../entities/volunteer_application.dart';
import '../entities/certificate.dart';

/// Repository for organization-specific operations
abstract class OrganizationRepository {
  /// Publish a new event
  Future<Either<Failure, VolunteerEvent>> publishEvent(VolunteerEvent event);

  /// Update an existing event
  Future<Either<Failure, VolunteerEvent>> updateEvent(VolunteerEvent event);

  /// Delete an event
  Future<Either<Failure, void>> deleteEvent(String eventId);

  /// Get all events published by organization
  Future<Either<Failure, List<VolunteerEvent>>> getOrganizationEvents(
      String organizationId);

  /// Get all applications for an event
  Future<Either<Failure, List<VolunteerApplication>>> getEventApplications(
      String eventId);

  /// Get all applications for organization (across all events)
  Future<Either<Failure, List<VolunteerApplication>>>
      getOrganizationApplications(String organizationId);

  /// Accept volunteer application
  Future<Either<Failure, VolunteerApplication>> acceptApplication(
      String applicationId);

  /// Reject volunteer application
  Future<Either<Failure, VolunteerApplication>> rejectApplication({
    required String applicationId,
    String? rejectionReason,
  });

  /// Mark event as completed for volunteer
  Future<Either<Failure, VolunteerApplication>> completeVolunteerWork({
    required String applicationId,
    required int hoursWorked,
    String? feedback,
  });

  /// Issue certificate to volunteer
  Future<Either<Failure, Certificate>> issueCertificate({
    required String volunteerId,
    required String eventId,
    required int hoursWorked,
    String? description,
  });

  /// Get all certificates issued by organization
  Future<Either<Failure, List<Certificate>>> getOrganizationCertificates(
      String organizationId);

  /// Get organization statistics
  Future<Either<Failure, Map<String, dynamic>>> getOrganizationStatistics(
      String organizationId);

  /// Rate volunteer after event
  Future<Either<Failure, void>> rateVolunteer({
    required String applicationId,
    required double rating,
    String? comment,
  });
}
