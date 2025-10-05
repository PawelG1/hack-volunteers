import 'package:equatable/equatable.dart';

/// Certificate status enum
/// 
/// UWAGA: Zaświadczenia są generowane TYLKO przez koordynatora szkolnego,
/// nie przez organizację!
enum CertificateStatus {
  pending, // Oczekujące na wygenerowanie przez koordynatora
  issued, // Wystawione przez koordynatora (PDF wygenerowany)
}

/// Volunteer certificate entity
/// 
/// Zaświadczenie o uczestnictwie w wolontariacie.
/// Generowane przez KOORDYNATORA SZKOLNEGO po:
/// 1. Organizacja oznaczyła obecność (attended)
/// 2. Koordynator zatwierdził udział (approved)
/// 3. Koordynator generuje zaświadczenie (issued)
class Certificate extends Equatable {
  final String id;
  final String volunteerId;
  final String organizationId;
  final String eventId;
  final String? schoolCoordinatorId; // Koordynator który zatwierdził
  final CertificateStatus status;
  final String volunteerName;
  final String organizationName;
  final String eventTitle;
  final DateTime eventDate;
  final int hoursWorked;
  final String? description; // Opis wykonanej pracy
  final String? skills; // Nabyte umiejętności
  final DateTime createdAt;
  final DateTime? approvedAt; // Data zatwierdzenia
  final String? approvedBy; // Kto zatwierdził (coordinator name)
  final DateTime? issuedAt; // Data wystawienia
  final String? pdfUrl; // Link do PDF certyfikatu
  final String? certificateNumber; // Numer certyfikatu

  const Certificate({
    required this.id,
    required this.volunteerId,
    required this.organizationId,
    required this.eventId,
    this.schoolCoordinatorId,
    required this.status,
    required this.volunteerName,
    required this.organizationName,
    required this.eventTitle,
    required this.eventDate,
    required this.hoursWorked,
    this.description,
    this.skills,
    required this.createdAt,
    this.approvedAt,
    this.approvedBy,
    this.issuedAt,
    this.pdfUrl,
    this.certificateNumber,
  });

  bool get isPending => status == CertificateStatus.pending;
  bool get isIssued => status == CertificateStatus.issued;

  @override
  List<Object?> get props => [
        id,
        volunteerId,
        organizationId,
        eventId,
        schoolCoordinatorId,
        status,
        volunteerName,
        organizationName,
        eventTitle,
        eventDate,
        hoursWorked,
        description,
        skills,
        createdAt,
        approvedAt,
        approvedBy,
        issuedAt,
        pdfUrl,
        certificateNumber,
      ];

  Certificate copyWith({
    String? id,
    String? volunteerId,
    String? organizationId,
    String? eventId,
    String? schoolCoordinatorId,
    CertificateStatus? status,
    String? volunteerName,
    String? organizationName,
    String? eventTitle,
    DateTime? eventDate,
    int? hoursWorked,
    String? description,
    String? skills,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? approvedBy,
    DateTime? issuedAt,
    String? pdfUrl,
    String? certificateNumber,
  }) {
    return Certificate(
      id: id ?? this.id,
      volunteerId: volunteerId ?? this.volunteerId,
      organizationId: organizationId ?? this.organizationId,
      eventId: eventId ?? this.eventId,
      schoolCoordinatorId: schoolCoordinatorId ?? this.schoolCoordinatorId,
      status: status ?? this.status,
      volunteerName: volunteerName ?? this.volunteerName,
      organizationName: organizationName ?? this.organizationName,
      eventTitle: eventTitle ?? this.eventTitle,
      eventDate: eventDate ?? this.eventDate,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      issuedAt: issuedAt ?? this.issuedAt,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      certificateNumber: certificateNumber ?? this.certificateNumber,
    );
  }
}
