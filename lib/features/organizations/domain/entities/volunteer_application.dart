import 'package:equatable/equatable.dart';

/// Application status enum - reprezentuje cały cykl życia zgłoszenia
/// 
/// FLOW PROCESU:
/// 1. WOLONTARIUSZ: pending (wysłał zgłoszenie)
/// 2. ORGANIZACJA: accepted/rejected (akceptuje lub odrzuca)
/// 3. WYDARZENIE: odbywa się
/// 4. ORGANIZACJA: attended/notAttended (oznacza obecność)
/// 5. KOORDYNATOR: approved (zatwierdza udział ucznia)
/// 6. KOORDYNATOR: completed (generuje zaświadczenie)
enum ApplicationStatus {
  pending, // Oczekujące (wolontariusz wysłał zgłoszenie)
  accepted, // Zaakceptowane (organizacja zaakceptowała)
  rejected, // Odrzucone (organizacja odrzuciła)
  attended, // Obecny (organizacja potwierdziła obecność na wydarzeniu)
  notAttended, // Nieobecny (organizacja zaznaczyła brak obecności)
  approved, // Zatwierdzony (koordynator zatwierdził udział)
  completed, // Ukończone z certyfikatem (koordynator wygenerował zaświadczenie)
  cancelled, // Anulowane (wolontariusz anulował)
}

/// Volunteer application to an event
/// 
/// Reprezentuje zgłoszenie wolontariusza do wydarzenia wraz z pełnym cyklem życia:
/// - Zgłoszenie (wolontariusz)
/// - Akceptacja (organizacja)
/// - Obecność (organizacja)
/// - Zatwierdzenie (koordynator)
/// - Certyfikacja (koordynator)
class VolunteerApplication extends Equatable {
  final String id;
  final String eventId;
  final String volunteerId;
  final String organizationId;
  final ApplicationStatus status;
  final String? message; // Wiadomość od wolontariusza
  final String? rejectionReason; // Powód odrzucenia
  final DateTime appliedAt;
  final DateTime? respondedAt; // Kiedy organizacja odpowiedziała
  final DateTime? completedAt; // Kiedy ukończono
  final DateTime? attendanceMarkedAt; // Kiedy organizacja oznaczyła obecność
  final DateTime? approvedAt; // Kiedy koordynator zatwierdził
  final String? coordinatorId; // ID koordynatora który zatwierdził
  final String? certificateId; // ID wygenerowanego zaświadczenia
  final int? hoursWorked; // Przepracowane godziny
  final double? rating; // Ocena od organizacji (1-5)
  final String? feedback; // Opinia od organizacji
  final String? coordinatorNotes; // Notatki koordynatora

  const VolunteerApplication({
    required this.id,
    required this.eventId,
    required this.volunteerId,
    required this.organizationId,
    required this.status,
    this.message,
    this.rejectionReason,
    required this.appliedAt,
    this.respondedAt,
    this.completedAt,
    this.attendanceMarkedAt,
    this.approvedAt,
    this.coordinatorId,
    this.certificateId,
    this.hoursWorked,
    this.rating,
    this.feedback,
    this.coordinatorNotes,
  });

  bool get isPending => status == ApplicationStatus.pending;
  bool get isAccepted => status == ApplicationStatus.accepted;
  bool get isAttended => status == ApplicationStatus.attended;
  bool get isApproved => status == ApplicationStatus.approved;
  bool get isCompleted => status == ApplicationStatus.completed;

  @override
  List<Object?> get props => [
        id,
        eventId,
        volunteerId,
        organizationId,
        status,
        message,
        rejectionReason,
        appliedAt,
        respondedAt,
        completedAt,
        attendanceMarkedAt,
        approvedAt,
        coordinatorId,
        certificateId,
        hoursWorked,
        rating,
        feedback,
        coordinatorNotes,
      ];

  VolunteerApplication copyWith({
    String? id,
    String? eventId,
    String? volunteerId,
    String? organizationId,
    ApplicationStatus? status,
    String? message,
    String? rejectionReason,
    DateTime? appliedAt,
    DateTime? respondedAt,
    DateTime? completedAt,
    DateTime? attendanceMarkedAt,
    DateTime? approvedAt,
    String? coordinatorId,
    String? certificateId,
    int? hoursWorked,
    double? rating,
    String? feedback,
    String? coordinatorNotes,
  }) {
    return VolunteerApplication(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      volunteerId: volunteerId ?? this.volunteerId,
      organizationId: organizationId ?? this.organizationId,
      status: status ?? this.status,
      message: message ?? this.message,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      appliedAt: appliedAt ?? this.appliedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      completedAt: completedAt ?? this.completedAt,
      attendanceMarkedAt: attendanceMarkedAt ?? this.attendanceMarkedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      coordinatorId: coordinatorId ?? this.coordinatorId,
      certificateId: certificateId ?? this.certificateId,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      coordinatorNotes: coordinatorNotes ?? this.coordinatorNotes,
    );
  }
}
