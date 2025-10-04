part of 'organization_bloc.dart';

abstract class OrganizationState extends Equatable {
  const OrganizationState();

  @override
  List<Object?> get props => [];
}

class OrganizationInitial extends OrganizationState {}

class OrganizationLoading extends OrganizationState {}

class OrganizationEventsLoaded extends OrganizationState {
  final List<VolunteerEvent> events;

  const OrganizationEventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class OrganizationEventCreated extends OrganizationState {
  final VolunteerEvent event;

  const OrganizationEventCreated(this.event);

  @override
  List<Object?> get props => [event];
}

class OrganizationEventUpdated extends OrganizationState {
  final VolunteerEvent event;

  const OrganizationEventUpdated(this.event);

  @override
  List<Object?> get props => [event];
}

class OrganizationEventDeleted extends OrganizationState {
  final String eventId;

  const OrganizationEventDeleted(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class OrganizationError extends OrganizationState {
  final String message;

  const OrganizationError(this.message);

  @override
  List<Object?> get props => [message];
}