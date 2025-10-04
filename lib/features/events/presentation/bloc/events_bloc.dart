import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_events.dart';
import '../../domain/usecases/save_interested_event.dart';
import '../../domain/usecases/save_skipped_event.dart';
import 'events_event.dart';
import 'events_state.dart';

/// BLoC for managing events and swipe actions
/// Single Responsibility - manages only events-related state
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final SaveInterestedEvent saveInterestedEvent;
  final SaveSkippedEvent saveSkippedEvent;

  EventsBloc({
    required this.getEvents,
    required this.saveInterestedEvent,
    required this.saveSkippedEvent,
  }) : super(EventsInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<SwipeRightEvent>(_onSwipeRight);
    on<SwipeLeftEvent>(_onSwipeLeft);
    on<NextEventEvent>(_onNextEvent);
  }

  Future<void> _onLoadEvents(
    LoadEventsEvent event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());

    final result = await getEvents(const NoParams());

    result.fold((failure) => emit(EventsError(failure.message)), (events) {
      if (events.isEmpty) {
        emit(const EventsError('Brak dostępnych wydarzeń'));
      } else {
        emit(EventsLoaded(events: events, currentIndex: 0));
      }
    });
  }

  Future<void> _onSwipeRight(
    SwipeRightEvent event,
    Emitter<EventsState> emit,
  ) async {
    if (state is EventsLoaded) {
      final currentState = state as EventsLoaded;

      // Save interested event
      final result = await saveInterestedEvent(
        SaveInterestedEventParams(eventId: event.eventId),
      );

      result.fold((failure) => emit(EventsError(failure.message)), (_) {
        // Move to next event
        final newIndex = currentState.currentIndex + 1;
        if (newIndex >= currentState.events.length) {
          emit(const EventsError('To wszystkie wydarzenia!'));
        } else {
          emit(currentState.copyWith(currentIndex: newIndex));
        }
      });
    }
  }

  Future<void> _onSwipeLeft(
    SwipeLeftEvent event,
    Emitter<EventsState> emit,
  ) async {
    if (state is EventsLoaded) {
      final currentState = state as EventsLoaded;

      // Save skipped event
      final result = await saveSkippedEvent(
        SaveSkippedEventParams(eventId: event.eventId),
      );

      result.fold((failure) => emit(EventsError(failure.message)), (_) {
        // Move to next event
        final newIndex = currentState.currentIndex + 1;
        if (newIndex >= currentState.events.length) {
          emit(const EventsError('To wszystkie wydarzenia!'));
        } else {
          emit(currentState.copyWith(currentIndex: newIndex));
        }
      });
    }
  }

  void _onNextEvent(NextEventEvent event, Emitter<EventsState> emit) {
    if (state is EventsLoaded) {
      final currentState = state as EventsLoaded;
      final newIndex = currentState.currentIndex + 1;

      if (newIndex >= currentState.events.length) {
        emit(const EventsError('To wszystkie wydarzenia!'));
      } else {
        emit(currentState.copyWith(currentIndex: newIndex));
      }
    }
  }
}
