import 'package:equatable/equatable.dart';
import '../../domain/entities/volunteer_event.dart';

/// Base class for all events states
abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class EventsInitial extends EventsState {}

/// Loading state
class EventsLoading extends EventsState {}

/// Events loaded successfully
class EventsLoaded extends EventsState {
  final List<VolunteerEvent> events;
  final int currentIndex;

  const EventsLoaded({required this.events, this.currentIndex = 0});

  /// Check if there are more events to show
  bool get hasMoreEvents => currentIndex < events.length;

  /// Get current event
  VolunteerEvent? get currentEvent =>
      hasMoreEvents ? events[currentIndex] : null;

  /// Copy with new values
  EventsLoaded copyWith({List<VolunteerEvent>? events, int? currentIndex}) {
    return EventsLoaded(
      events: events ?? this.events,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [events, currentIndex];
}

/// Error state
class EventsError extends EventsState {
  final String message;

  const EventsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event action completed (swipe processed)
class EventActionCompleted extends EventsState {
  final String message;

  const EventActionCompleted(this.message);

  @override
  List<Object?> get props => [message];
}
