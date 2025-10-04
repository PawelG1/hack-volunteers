import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../organizations/domain/usecases/create_event.dart';
import '../../domain/usecases/update_event.dart';
import '../../domain/usecases/delete_event.dart';
import '../../domain/usecases/get_organization_events.dart';

part 'organization_event.dart';
part 'organization_state.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  final CreateEvent _createEvent;
  final UpdateEvent _updateEvent;
  final DeleteEvent _deleteEvent;
  final GetOrganizationEvents _getOrganizationEvents;

  OrganizationBloc({
    required CreateEvent createEvent,
    required UpdateEvent updateEvent,
    required DeleteEvent deleteEvent,
    required GetOrganizationEvents getOrganizationEvents,
  })  : _createEvent = createEvent,
        _updateEvent = updateEvent,
        _deleteEvent = deleteEvent,
        _getOrganizationEvents = getOrganizationEvents,
        super(OrganizationInitial()) {
    on<LoadOrganizationEvents>(_onLoadOrganizationEvents);
    on<CreateNewEvent>(_onCreateNewEvent);
    on<UpdateExistingEvent>(_onUpdateExistingEvent);
    on<DeleteExistingEvent>(_onDeleteExistingEvent);
  }

  Future<void> _onLoadOrganizationEvents(
    LoadOrganizationEvents event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    
    final result = await _getOrganizationEvents(GetOrganizationEventsParams(
      organizationId: event.organizationId,
    ));
    
    result.fold(
      (failure) => emit(OrganizationError(failure.toString())),
      (events) => emit(OrganizationEventsLoaded(events)),
    );
  }

  Future<void> _onCreateNewEvent(
    CreateNewEvent event,
    Emitter<OrganizationState> emit,
  ) async {
    try {
      print('OrganizationBloc: Creating new event with title: ${event.volunteerEvent.title}');
      emit(OrganizationLoading());
      
      final result = await _createEvent(CreateEventParams(
        event: event.volunteerEvent,
      ));
      
      result.fold(
        (failure) {
          print('OrganizationBloc: Error creating event: $failure');
          emit(OrganizationError(failure.toString()));
        },
        (createdEvent) {
          print('OrganizationBloc: Event created successfully with ID: ${createdEvent.id}');
          if (state is OrganizationEventsLoaded) {
            final currentEvents = (state as OrganizationEventsLoaded).events;
            emit(OrganizationEventsLoaded([...currentEvents, createdEvent]));
          } else {
            emit(OrganizationEventsLoaded([createdEvent]));
          }
          emit(OrganizationEventCreated(createdEvent));
        },
      );
    } catch (e) {
      print('OrganizationBloc: Unexpected error: $e');
      emit(OrganizationError(e.toString()));
    }
  }

  Future<void> _onUpdateExistingEvent(
    UpdateExistingEvent event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    
    final result = await _updateEvent(UpdateEventParams(
      event: event.volunteerEvent,
    ));
    
    result.fold(
      (failure) => emit(OrganizationError(failure.toString())),
      (updatedEvent) {
        if (state is OrganizationEventsLoaded) {
          final currentEvents = (state as OrganizationEventsLoaded).events;
          final updatedEvents = currentEvents
              .map((e) => e.id == updatedEvent.id ? updatedEvent : e)
              .toList();
          emit(OrganizationEventsLoaded(updatedEvents));
        }
        emit(OrganizationEventUpdated(updatedEvent));
      },
    );
  }

  Future<void> _onDeleteExistingEvent(
    DeleteExistingEvent event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    
    final result = await _deleteEvent(DeleteEventParams(
      eventId: event.eventId,
    ));
    
    result.fold(
      (failure) => emit(OrganizationError(failure.toString())),
      (_) {
        if (state is OrganizationEventsLoaded) {
          final currentEvents = (state as OrganizationEventsLoaded).events;
          final filteredEvents = currentEvents
              .where((e) => e.id != event.eventId)
              .toList();
          emit(OrganizationEventsLoaded(filteredEvents));
        }
        emit(OrganizationEventDeleted(event.eventId));
      },
    );
  }
}