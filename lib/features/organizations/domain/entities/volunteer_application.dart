import 'package:equatable/equatable.dart';

/// Application status enum
enum ApplicationStatus {
  pending, // Oczekujące
  accepted, // Zaakceptowane
  rejected, // Odrzucone
  completed, // Ukończone
  cancelled, // Anulowane
}

/// Volunteer application to an event
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
  final int? hoursWorked; // Przepracowane godziny
  final double? rating; // Ocena od organizacji (1-5)
  final String? feedback; // Opinia od organizacji

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
    this.hoursWorked,
    this.rating,
    this.feedback,
  });

  bool get isPending => status == ApplicationStatus.pending;
  bool get isAccepted => status == ApplicationStatus.accepted;
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
        hoursWorked,
        rating,
        feedback,
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
    int? hoursWorked,
    double? rating,
    String? feedback,
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
      hoursWorked: hoursWorked ?? this.hoursWorked,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
    );
  }
}
