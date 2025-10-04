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