import 'package:isar/isar.dart';
import '../../domain/entities/certificate.dart';

part 'certificate_model.g.dart';

/// Isar model for certificates
@collection
class CertificateModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String certificateId; // Unique certificate ID
  
  @Index()
  late String volunteerId;
  
  @Index()
  late String organizationId;
  
  @Index()
  late String eventId;
  
  @Index()
  String? schoolCoordinatorId;
  
  @Enumerated(EnumType.name)
  late CertificateStatus status;
  
  late String volunteerName;
  late String organizationName;
  late String eventTitle;
  late DateTime eventDate;
  late int hoursWorked;
  
  String? description;
  String? skills;
  
  @Index()
  late DateTime createdAt;
  
  DateTime? approvedAt;
  String? approvedBy;
  DateTime? issuedAt;
  
  String? pdfUrl;
  String? certificateNumber;

  CertificateModel();

  /// Convert from domain entity
  factory CertificateModel.fromEntity(Certificate entity) {
    return CertificateModel()
      ..certificateId = entity.id
      ..volunteerId = entity.volunteerId
      ..organizationId = entity.organizationId
      ..eventId = entity.eventId
      ..schoolCoordinatorId = entity.schoolCoordinatorId
      ..status = entity.status
      ..volunteerName = entity.volunteerName
      ..organizationName = entity.organizationName
      ..eventTitle = entity.eventTitle
      ..eventDate = entity.eventDate
      ..hoursWorked = entity.hoursWorked
      ..description = entity.description
      ..skills = entity.skills
      ..createdAt = entity.createdAt
      ..approvedAt = entity.approvedAt
      ..approvedBy = entity.approvedBy
      ..issuedAt = entity.issuedAt
      ..pdfUrl = entity.pdfUrl
      ..certificateNumber = entity.certificateNumber;
  }

  /// Convert to domain entity
  Certificate toEntity() {
    return Certificate(
      id: certificateId,
      volunteerId: volunteerId,
      organizationId: organizationId,
      eventId: eventId,
      schoolCoordinatorId: schoolCoordinatorId,
      status: status,
      volunteerName: volunteerName,
      organizationName: organizationName,
      eventTitle: eventTitle,
      eventDate: eventDate,
      hoursWorked: hoursWorked,
      description: description,
      skills: skills,
      createdAt: createdAt,
      approvedAt: approvedAt,
      approvedBy: approvedBy,
      issuedAt: issuedAt,
      pdfUrl: pdfUrl,
      certificateNumber: certificateNumber,
    );
  }
}
