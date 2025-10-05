import 'package:isar/isar.dart';
import '../../domain/entities/volunteer_application.dart';
import '../models/volunteer_application_model.dart';

/// Local data source for organization operations
abstract class OrganizationLocalDataSource {
  /// Get all applications for a specific event
  Future<List<VolunteerApplication>> getApplicationsForEvent(String eventId);

  /// Get all applications for an organization
  Future<List<VolunteerApplication>> getApplicationsByOrganization(
      String organizationId);

  /// Accept an application
  Future<VolunteerApplication> acceptApplication(String applicationId);

  /// Reject an application with reason
  Future<VolunteerApplication> rejectApplication(
    String applicationId,
    String reason,
  );

  /// Mark attendance for a volunteer
  Future<VolunteerApplication> markAttendance({
    required String applicationId,
    required bool attended,
    int? hoursWorked,
    double? rating,
    String? feedback,
  });

  /// Rate a volunteer
  Future<void> rateVolunteer({
    required String applicationId,
    required double rating,
    String? feedback,
  });

  /// Create a new application
  Future<VolunteerApplication> createApplication({
    required String eventId,
    required String volunteerId,
    required String organizationId,
    String? message,
  });
}

/// Implementation of OrganizationLocalDataSource using Isar
class OrganizationLocalDataSourceImpl implements OrganizationLocalDataSource {
  final Isar isar;

  OrganizationLocalDataSourceImpl({required this.isar});

  @override
  Future<List<VolunteerApplication>> getApplicationsForEvent(
      String eventId) async {
    final models = await isar.volunteerApplicationModels
        .filter()
        .eventIdEqualTo(eventId)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<VolunteerApplication>> getApplicationsByOrganization(
      String organizationId) async {
    final models = await isar.volunteerApplicationModels
        .filter()
        .organizationIdEqualTo(organizationId)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<VolunteerApplication> acceptApplication(String applicationId) async {
    return await isar.writeTxn(() async {
      final model = await isar.volunteerApplicationModels
          .filter()
          .applicationIdEqualTo(applicationId)
          .findFirst();

      if (model == null) {
        throw Exception('Application not found: $applicationId');
      }

      model.status = ApplicationStatus.accepted;
      model.respondedAt = DateTime.now();

      await isar.volunteerApplicationModels.put(model);
      return model.toEntity();
    });
  }

  @override
  Future<VolunteerApplication> rejectApplication(
    String applicationId,
    String reason,
  ) async {
    return await isar.writeTxn(() async {
      final model = await isar.volunteerApplicationModels
          .filter()
          .applicationIdEqualTo(applicationId)
          .findFirst();

      if (model == null) {
        throw Exception('Application not found: $applicationId');
      }

      model.status = ApplicationStatus.rejected;
      model.rejectionReason = reason;
      model.respondedAt = DateTime.now();

      await isar.volunteerApplicationModels.put(model);
      return model.toEntity();
    });
  }

  @override
  Future<VolunteerApplication> markAttendance({
    required String applicationId,
    required bool attended,
    int? hoursWorked,
    double? rating,
    String? feedback,
  }) async {
    return await isar.writeTxn(() async {
      final model = await isar.volunteerApplicationModels
          .filter()
          .applicationIdEqualTo(applicationId)
          .findFirst();

      if (model == null) {
        throw Exception('Application not found: $applicationId');
      }

      // Update status based on attendance
      model.status =
          attended ? ApplicationStatus.attended : ApplicationStatus.notAttended;
      model.attendanceMarkedAt = DateTime.now();

      if (hoursWorked != null) model.hoursWorked = hoursWorked;
      if (rating != null) model.rating = rating;
      if (feedback != null) model.feedback = feedback;

      await isar.volunteerApplicationModels.put(model);
      return model.toEntity();
    });
  }

  @override
  Future<void> rateVolunteer({
    required String applicationId,
    required double rating,
    String? feedback,
  }) async {
    await isar.writeTxn(() async {
      final model = await isar.volunteerApplicationModels
          .filter()
          .applicationIdEqualTo(applicationId)
          .findFirst();

      if (model == null) {
        throw Exception('Application not found: $applicationId');
      }

      model.rating = rating;
      if (feedback != null) model.feedback = feedback;

      await isar.volunteerApplicationModels.put(model);
    });
  }

  @override
  Future<VolunteerApplication> createApplication({
    required String eventId,
    required String volunteerId,
    required String organizationId,
    String? message,
  }) async {
    print('💾 ORG_DS: Creating application...');
    print('   eventId: $eventId');
    print('   volunteerId: $volunteerId');
    print('   organizationId: $organizationId');
    print('   message: $message');
    
    return await isar.writeTxn(() async {
      final applicationId = '${DateTime.now().millisecondsSinceEpoch}_$volunteerId';
      
      final model = VolunteerApplicationModel()
        ..applicationId = applicationId
        ..eventId = eventId
        ..volunteerId = volunteerId
        ..organizationId = organizationId
        ..status = ApplicationStatus.pending
        ..message = message
        ..appliedAt = DateTime.now();

      await isar.volunteerApplicationModels.put(model);
      
      print('💾 ORG_DS: Application saved to Isar');
      print('   applicationId: $applicationId');
      print('   status: ${model.status}');
      
      return model.toEntity();
    });
  }
}
