import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../organizations/domain/usecases/create_event.dart';
import '../../domain/usecases/update_event.dart';
import '../../domain/usecases/delete_event.dart';
import '../../domain/usecases/get_organization_events.dart';
import '../../domain/entities/volunteer_application.dart';
import '../../domain/usecases/get_applications_for_event.dart';
import '../../domain/usecases/get_organization_applications.dart';
import '../../domain/usecases/accept_application.dart';
import '../../domain/usecases/reject_application.dart';
import '../../domain/usecases/mark_attendance.dart';
import '../../domain/usecases/rate_volunteer.dart';

part 'organization_event.dart';
part 'organization_state.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  final CreateEvent _createEvent;
  final UpdateEvent _updateEvent;
  final DeleteEvent _deleteEvent;
  final GetOrganizationEvents _getOrganizationEvents;
  final GetApplicationsForEvent _getApplicationsForEvent;
  final GetOrganizationApplications _getOrganizationApplications;
  final AcceptApplication _acceptApplication;
  final RejectApplication _rejectApplication;
  final MarkAttendance _markAttendance;
  final RateVolunteer _rateVolunteer;

  OrganizationBloc({
    required CreateEvent createEvent,
    required UpdateEvent updateEvent,
    required DeleteEvent deleteEvent,
    required GetOrganizationEvents getOrganizationEvents,
    required GetApplicationsForEvent getApplicationsForEvent,
    required GetOrganizationApplications getOrganizationApplications,
    required AcceptApplication acceptApplication,
    required RejectApplication rejectApplication,
    required MarkAttendance markAttendance,
    required RateVolunteer rateVolunteer,
  })  : _createEvent = createEvent,
        _updateEvent = updateEvent,
        _deleteEvent = deleteEvent,
        _getOrganizationEvents = getOrganizationEvents,
        _getApplicationsForEvent = getApplicationsForEvent,
        _getOrganizationApplications = getOrganizationApplications,
        _acceptApplication = acceptApplication,
        _rejectApplication = rejectApplication,
        _markAttendance = markAttendance,
        _rateVolunteer = rateVolunteer,
        super(OrganizationInitial()) {
    on<LoadOrganizationEvents>(_onLoadOrganizationEvents);
    on<CreateNewEvent>(_onCreateNewEvent);
    on<UpdateExistingEvent>(_onUpdateExistingEvent);
    on<DeleteExistingEvent>(_onDeleteExistingEvent);
    on<LoadEventApplications>(_onLoadEventApplications);
    on<LoadOrganizationApplications>(_onLoadOrganizationApplications);
    on<AcceptVolunteerApplication>(_onAcceptVolunteerApplication);
    on<RejectVolunteerApplication>(_onRejectVolunteerApplication);
    on<MarkVolunteerAttendance>(_onMarkVolunteerAttendance);
    on<RateVolunteerPerformance>(_onRateVolunteerPerformance);
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
          // Emit success state first
          emit(OrganizationEventCreated(createdEvent));
          
          // Then reload events from database to ensure we have the latest data with organizationId
          print('OrganizationBloc: Reloading events from database after creation');
          final organizationId = createdEvent.organizationId ?? 'sample-org';
          add(LoadOrganizationEvents(organizationId: organizationId));
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

  // Application handlers
  Future<void> _onLoadEventApplications(
    LoadEventApplications event,
    Emitter<OrganizationState> emit,
  ) async {
    print('📋 ORG_BLOC: Loading applications for eventId: ${event.eventId}');
    emit(ApplicationsLoading());
    
    final result = await _getApplicationsForEvent(event.eventId);
    
    result.fold(
      (failure) {
        print('❌ ORG_BLOC: Failed to load event applications: ${failure.toString()}');
        emit(OrganizationError(failure.toString()));
      },
      (applications) {
        print('✅ ORG_BLOC: Loaded ${applications.length} applications for event');
        emit(ApplicationsLoaded(applications));
      },
    );
  }

  Future<void> _onLoadOrganizationApplications(
    LoadOrganizationApplications event,
    Emitter<OrganizationState> emit,
  ) async {
    print('📋 ORG_BLOC: Loading applications for organizationId: ${event.organizationId}');
    emit(ApplicationsLoading());
    
    final result = await _getOrganizationApplications(event.organizationId);
    
    result.fold(
      (failure) {
        print('❌ ORG_BLOC: Failed to load organization applications: ${failure.toString()}');
        emit(OrganizationError(failure.toString()));
      },
      (applications) {
        print('✅ ORG_BLOC: Loaded ${applications.length} applications for organization');
        for (final app in applications) {
          print('   - Application ${app.id}: event=${app.eventId}, volunteer=${app.volunteerId}, status=${app.status}');
        }
        emit(ApplicationsLoaded(applications));
      },
    );
  }

  Future<void> _onAcceptVolunteerApplication(
    AcceptVolunteerApplication event,
    Emitter<OrganizationState> emit,
  ) async {
    print('✅ ORG_BLOC: Accepting application ${event.applicationId}');
    emit(ApplicationsLoading());
    
    final result = await _acceptApplication(event.applicationId);
    
    result.fold(
      (failure) {
        print('❌ ORG_BLOC: Failed to accept application: ${failure.toString()}');
        emit(OrganizationError(failure.toString()));
      },
      (application) {
        print('✅ ORG_BLOC: Application accepted successfully: ${application.id}');
        emit(ApplicationAccepted(application));
      },
    );
  }

  Future<void> _onRejectVolunteerApplication(
    RejectVolunteerApplication event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(ApplicationsLoading());
    
    final result = await _rejectApplication(
      RejectApplicationParams(
        applicationId: event.applicationId,
        reason: event.reason,
      ),
    );
    
    result.fold(
      (failure) => emit(OrganizationError(failure.toString())),
      (application) => emit(ApplicationRejected(application)),
    );
  }

  Future<void> _onMarkVolunteerAttendance(
    MarkVolunteerAttendance event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(ApplicationsLoading());
    
    final result = await _markAttendance(
      MarkAttendanceParams(
        applicationId: event.applicationId,
        hoursWorked: event.hoursWorked,
        feedback: event.feedback,
      ),
    );
    
    result.fold(
      (failure) => emit(OrganizationError(failure.toString())),
      (application) => emit(AttendanceMarked(application)),
    );
  }

  Future<void> _onRateVolunteerPerformance(
    RateVolunteerPerformance event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(ApplicationsLoading());
    
    final result = await _rateVolunteer(
      RateVolunteerParams(
        applicationId: event.applicationId,
        rating: event.rating,
        comment: event.comment,
      ),
    );
    
    result.fold(
      (failure) => emit(OrganizationError(failure.toString())),
      (_) => emit(const VolunteerRated('Volunteer rated successfully')),
    );
  }
}

