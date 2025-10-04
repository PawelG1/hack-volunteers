import 'package:equatable/equatable.dart';

/// Base class for all events events (BLoC events)
abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

/// Load events
class LoadEventsEvent extends EventsEvent {}

/// User swiped right (interested)
class SwipeRightEvent extends EventsEvent {
  final String eventId;

  const SwipeRightEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

/// User swiped left (not interested)
class SwipeLeftEvent extends EventsEvent {
  final String eventId;

  const SwipeLeftEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

/// Move to next event
class NextEventEvent extends EventsEvent {}
