import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../../../organizations/data/models/volunteer_application_model.dart';
import '../../../organizations/data/models/certificate_model.dart';
import '../../../local_storage/data/models/volunteer_event_isar_model.dart';

/// Local data source for coordinator operations
abstract class CoordinatorLocalDataSource {
  /// Get applications pending approval (attended status)
  Future<List<VolunteerApplication>> getPendingApprovals(
      String coordinatorId);

  /// Approve a volunteer's participation
  Future<VolunteerApplication> approveParticipation({
    required String applicationId,
    required String coordinatorId,
    String? notes,
  });

  /// Generate certificate for approved participation
  Future<Certificate> generateCertificate({
    required String applicationId,
    required String coordinatorId,
    String? coordinatorName,
  });

  /// Get certificates issued by coordinator
  Future<List<Certificate>> getIssuedCertificates(String coordinatorId);

  /// Get all applications for coordinator's school
  Future<List<VolunteerApplication>> getSchoolApplications(
      String coordinatorId);
}

/// Implementation using Isar
class CoordinatorLocalDataSourceImpl implements CoordinatorLocalDataSource {
  final Isar isar;
  final Uuid uuid = const Uuid();

  CoordinatorLocalDataSourceImpl({required this.isar});

  @override
  Future<List<VolunteerApplication>> getPendingApprovals(
      String coordinatorId) async {
    // TODO: Filter by school when we have school management
    // For now, return all applications with "attended" status
    final models = await isar.volunteerApplicationModels
        .filter()
        .statusEqualTo(ApplicationStatus.attended)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<VolunteerApplication> approveParticipation({
    required String applicationId,
    required String coordinatorId,
    String? notes,
  }) async {
    return await isar.writeTxn(() async {
      final model = await isar.volunteerApplicationModels
          .filter()
          .applicationIdEqualTo(applicationId)
          .findFirst();

      if (model == null) {
        throw Exception('Application not found: $applicationId');
      }

      // Verify that attendance was marked
      if (model.status != ApplicationStatus.attended) {
        throw Exception(
            'Cannot approve: attendance not marked by organization');
      }

      model.status = ApplicationStatus.approved;
      model.approvedAt = DateTime.now();
      model.coordinatorId = coordinatorId;
      if (notes != null) model.coordinatorNotes = notes;

      await isar.volunteerApplicationModels.put(model);
      return model.toEntity();
    });
  }

  @override
  Future<Certificate> generateCertificate({
    required String applicationId,
    required String coordinatorId,
    String? coordinatorName,
  }) async {
    return await isar.writeTxn(() async {
      // Get the approved application
      final appModel = await isar.volunteerApplicationModels
          .filter()
          .applicationIdEqualTo(applicationId)
          .findFirst();

      if (appModel == null) {
        throw Exception('Application not found: $applicationId');
      }

      if (appModel.status != ApplicationStatus.approved) {
        throw Exception('Application must be approved before generating certificate');
      }

      // Get event details
      final eventModel = await isar.volunteerEventIsarModels
          .filter()
          .eventIdEqualTo(appModel.eventId)
          .findFirst();

      if (eventModel == null) {
        throw Exception('Event not found: ${appModel.eventId}');
      }

      // Generate certificate number
      final certNumber =
          'CERT-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}';

      // Create certificate
      final certModel = CertificateModel()
        ..certificateId = uuid.v4()
        ..volunteerId = appModel.volunteerId
        ..organizationId = appModel.organizationId
        ..eventId = appModel.eventId
        ..schoolCoordinatorId = coordinatorId
        ..status = CertificateStatus.issued
        ..volunteerName = 'Wolontariusz ${appModel.volunteerId}' // TODO: Get real name
        ..organizationName = eventModel.organization
        ..eventTitle = eventModel.title
        ..eventDate = eventModel.date
        ..hoursWorked = appModel.hoursWorked ?? 0
        ..description = appModel.feedback
        ..createdAt = DateTime.now()
        ..approvedAt = appModel.approvedAt
        ..approvedBy = coordinatorName ?? 'Koordynator'
        ..issuedAt = DateTime.now()
        ..certificateNumber = certNumber;

      await isar.certificateModels.put(certModel);

      // Update application status to completed
      appModel.status = ApplicationStatus.completed;
      appModel.certificateId = certModel.certificateId;
      await isar.volunteerApplicationModels.put(appModel);

      return certModel.toEntity();
    });
  }

  @override
  Future<List<Certificate>> getIssuedCertificates(
      String coordinatorId) async {
    final models = await isar.certificateModels
        .filter()
        .schoolCoordinatorIdEqualTo(coordinatorId)
        .findAll();

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<VolunteerApplication>> getSchoolApplications(
      String coordinatorId) async {
    // TODO: Filter by school when we have school management
    // For now, return all applications
    final models = await isar.volunteerApplicationModels.where().findAll();

    return models.map((m) => m.toEntity()).toList();
  }
}
