import 'package:isar/isar.dart';
import '../../domain/entities/volunteer_application.dart';

part 'volunteer_application_model.g.dart';

/// Isar model for volunteer applications
@collection
class VolunteerApplicationModel {
  Id id = Isar.autoIncrement; // Auto-increment ID

  @Index()
  late String applicationId; // Unique application ID
  
  @Index()
  late String eventId;
  
  @Index()
  late String volunteerId;
  
  @Index()
  late String organizationId;
  
  @Enumerated(EnumType.name)
  late ApplicationStatus status;
  
  String? message;
  String? rejectionReason;
  
  @Index()
  late DateTime appliedAt;
  
  DateTime? respondedAt;
  DateTime? completedAt;
  DateTime? attendanceMarkedAt;
  DateTime? approvedAt;
  
  String? coordinatorId;
  String? certificateId;
  
  int? hoursWorked;
  double? rating;
  
  String? feedback;
  String? coordinatorNotes;

  VolunteerApplicationModel();

  /// Convert from domain entity
  factory VolunteerApplicationModel.fromEntity(VolunteerApplication entity) {
    return VolunteerApplicationModel()
      ..applicationId = entity.id
      ..eventId = entity.eventId
      ..volunteerId = entity.volunteerId
      ..organizationId = entity.organizationId
      ..status = entity.status
      ..message = entity.message
      ..rejectionReason = entity.rejectionReason
      ..appliedAt = entity.appliedAt
      ..respondedAt = entity.respondedAt
      ..completedAt = entity.completedAt
      ..attendanceMarkedAt = entity.attendanceMarkedAt
      ..approvedAt = entity.approvedAt
      ..coordinatorId = entity.coordinatorId
      ..certificateId = entity.certificateId
      ..hoursWorked = entity.hoursWorked
      ..rating = entity.rating
      ..feedback = entity.feedback
      ..coordinatorNotes = entity.coordinatorNotes;
  }

  /// Convert to domain entity
  VolunteerApplication toEntity() {
    return VolunteerApplication(
      id: applicationId,
      eventId: eventId,
      volunteerId: volunteerId,
      organizationId: organizationId,
      status: status,
      message: message,
      rejectionReason: rejectionReason,
      appliedAt: appliedAt,
      respondedAt: respondedAt,
      completedAt: completedAt,
      attendanceMarkedAt: attendanceMarkedAt,
      approvedAt: approvedAt,
      coordinatorId: coordinatorId,
      certificateId: certificateId,
      hoursWorked: hoursWorked,
      rating: rating,
      feedback: feedback,
      coordinatorNotes: coordinatorNotes,
    );
  }
}
