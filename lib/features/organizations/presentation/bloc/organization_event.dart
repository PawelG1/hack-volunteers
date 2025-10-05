part of 'organization_bloc.dart';

abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrganizationEvents extends OrganizationEvent {
  final String organizationId;

  const LoadOrganizationEvents({required this.organizationId});

  @override
  List<Object?> get props => [organizationId];
}

class CreateNewEvent extends OrganizationEvent {
  final VolunteerEvent volunteerEvent;

  const CreateNewEvent({required this.volunteerEvent});

  @override
  List<Object?> get props => [volunteerEvent];
}

class UpdateExistingEvent extends OrganizationEvent {
  final VolunteerEvent volunteerEvent;

  const UpdateExistingEvent({required this.volunteerEvent});

  @override
  List<Object?> get props => [volunteerEvent];
}

class DeleteExistingEvent extends OrganizationEvent {
  final String eventId;

  const DeleteExistingEvent({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

// Application Management Events
class LoadEventApplications extends OrganizationEvent {
  final String eventId;

  const LoadEventApplications({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class LoadOrganizationApplications extends OrganizationEvent {
  final String organizationId;

  const LoadOrganizationApplications({required this.organizationId});

  @override
  List<Object?> get props => [organizationId];
}

class AcceptVolunteerApplication extends OrganizationEvent {
  final String applicationId;

  const AcceptVolunteerApplication({required this.applicationId});

  @override
  List<Object?> get props => [applicationId];
}

class RejectVolunteerApplication extends OrganizationEvent {
  final String applicationId;
  final String? reason;

  const RejectVolunteerApplication({
    required this.applicationId,
    this.reason,
  });

  @override
  List<Object?> get props => [applicationId, reason];
}

class MarkVolunteerAttendance extends OrganizationEvent {
  final String applicationId;
  final int hoursWorked;
  final String? feedback;

  const MarkVolunteerAttendance({
    required this.applicationId,
    required this.hoursWorked,
    this.feedback,
  });

  @override
  List<Object?> get props => [applicationId, hoursWorked, feedback];
}

class RateVolunteerPerformance extends OrganizationEvent {
  final String applicationId;
  final double rating;
  final String? comment;

  const RateVolunteerPerformance({
    required this.applicationId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [applicationId, rating, comment];
}
