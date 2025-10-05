import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../events/data/datasources/events_local_data_source.dart';
import '../../../events/data/models/volunteer_event_model.dart';
import '../../domain/entities/volunteer_application.dart';
import '../../domain/entities/certificate.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/organization_local_data_source.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final EventsLocalDataSource eventsLocalDataSource;
  final OrganizationLocalDataSource organizationLocalDataSource;
  final Uuid uuid = const Uuid();

  OrganizationRepositoryImpl({
    required this.eventsLocalDataSource,
    required this.organizationLocalDataSource,
  });

  @override
  Future<Either<Failure, VolunteerEvent>> publishEvent(VolunteerEvent event) async {
    return await createEvent(event);
  }

  @override
  Future<Either<Failure, VolunteerEvent>> createEvent(VolunteerEvent event) async {
    try {
      // Generate new ID if not provided
      final eventWithId = event.copyWith(
        id: event.id.isEmpty ? uuid.v4() : event.id,
        createdAt: event.createdAt,
        updatedAt: DateTime.now(),
      );

      // Convert to model for data layer
      final eventModel = VolunteerEventModel.fromEntity(eventWithId);
      await eventsLocalDataSource.saveEvent(eventModel);
      return Right(eventWithId);
    } catch (e) {
      return Left(CacheFailure('Failed to create event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VolunteerEvent>> updateEvent(VolunteerEvent event) async {
    try {
      final updatedEvent = event.copyWith(updatedAt: DateTime.now());
      final eventModel = VolunteerEventModel.fromEntity(updatedEvent);
      await eventsLocalDataSource.saveEvent(eventModel);
      return Right(updatedEvent);
    } catch (e) {
      return Left(CacheFailure('Failed to update event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await eventsLocalDataSource.deleteEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerEvent>>> getOrganizationEvents(String organizationId) async {
    try {
      print('📋 REPO: Getting organization events for organizationId: $organizationId');
      final allEventModels = await eventsLocalDataSource.getAllEvents();
      print('📋 REPO: Found ${allEventModels.length} total events in Isar');
      
      // Convert models to entities
      final allEvents = allEventModels.map((model) => model.toEntity()).toList();
      
      // Filter by organizationId
      final organizationEvents = allEvents.where((event) {
        return event.organizationId == organizationId;
      }).toList();
      
      print('📋 REPO: Filtered to ${organizationEvents.length} events for organizationId: $organizationId');
      for (final event in organizationEvents) {
        print('   - ${event.title} (id: ${event.id}, org: ${event.organization}, orgId: ${event.organizationId})');
      }
      
      return Right(organizationEvents);
    } catch (e) {
      print('📋 REPO: Error getting organization events: $e');
      return Left(CacheFailure('Failed to get organization events: ${e.toString()}'));
    }
  }

  // Application management methods
  @override
  Future<Either<Failure, List<VolunteerApplication>>> getEventApplications(String eventId) async {
    try {
      print('📋 REPO: Getting applications for eventId: $eventId');
      final applications = await organizationLocalDataSource.getApplicationsForEvent(eventId);
      print('📋 REPO: Found ${applications.length} applications for event $eventId');
      for (final app in applications) {
        print('   - Application ${app.id}: volunteer=${app.volunteerId}, status=${app.status}');
      }
      return Right(applications);
    } catch (e) {
      print('📋 REPO: Error getting event applications: $e');
      return Left(CacheFailure('Failed to get event applications: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerApplication>>> getOrganizationApplications(String organizationId) async {
    try {
      print('📋 REPO: Getting applications for organizationId: $organizationId');
      final applications = await organizationLocalDataSource.getApplicationsByOrganization(organizationId);
      print('📋 REPO: Found ${applications.length} applications for organization $organizationId');
      for (final app in applications) {
        print('   - Application ${app.id}: event=${app.eventId}, volunteer=${app.volunteerId}, status=${app.status}');
      }
      return Right(applications);
    } catch (e) {
      print('📋 REPO: Error getting organization applications: $e');
      return Left(CacheFailure('Failed to get organization applications: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VolunteerApplication>> acceptApplication(String applicationId) async {
    try {
      final application = await organizationLocalDataSource.acceptApplication(applicationId);
      return Right(application);
    } catch (e) {
      return Left(CacheFailure('Failed to accept application: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VolunteerApplication>> rejectApplication({
    required String applicationId,
    String? rejectionReason,
  }) async {
    try {
      final application = await organizationLocalDataSource.rejectApplication(
        applicationId,
        rejectionReason ?? 'No reason provided',
      );
      return Right(application);
    } catch (e) {
      return Left(CacheFailure('Failed to reject application: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VolunteerApplication>> completeVolunteerWork({
    required String applicationId,
    required int hoursWorked,
    String? feedback,
  }) async {
    try {
      final application = await organizationLocalDataSource.markAttendance(
        applicationId: applicationId,
        attended: true,
        hoursWorked: hoursWorked,
        feedback: feedback,
      );
      return Right(application);
    } catch (e) {
      return Left(CacheFailure('Failed to mark attendance: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> rateVolunteer({
    required String applicationId,
    required double rating,
    String? comment,
  }) async {
    try {
      await organizationLocalDataSource.rateVolunteer(
        applicationId: applicationId,
        rating: rating,
        feedback: comment,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to rate volunteer: ${e.toString()}'));
    }
  }

  // Certificate methods - NOT IMPLEMENTED (Coordinator responsibility)
  @override
  Future<Either<Failure, Certificate>> issueCertificate({
    required String volunteerId,
    required String eventId,
    required int hoursWorked,
    String? description,
  }) async {
    return Left(ServerFailure('Organizations cannot issue certificates - only coordinators can'));
  }

  @override
  Future<Either<Failure, List<Certificate>>> getOrganizationCertificates(String organizationId) async {
    return Left(ServerFailure('Organizations cannot access certificates - only coordinators can'));
  }

  // Statistics
  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrganizationStatistics(String organizationId) async {
    try {
      final applications = await organizationLocalDataSource.getApplicationsByOrganization(organizationId);
      final events = await eventsLocalDataSource.getAllEvents();
      
      // Calculate statistics
      final totalEvents = events.length;
      final totalApplications = applications.length;
      final acceptedApplications = applications.where((app) => 
        app.status == ApplicationStatus.accepted || 
        app.status == ApplicationStatus.attended
      ).length;
      final completedApplications = applications.where((app) => 
        app.status == ApplicationStatus.completed
      ).length;
      
      int totalHours = 0;
      for (final app in applications) {
        if (app.hoursWorked != null) {
          totalHours += app.hoursWorked!;
        }
      }

      return Right({
        'totalEvents': totalEvents,
        'totalApplications': totalApplications,
        'acceptedApplications': acceptedApplications,
        'completedApplications': completedApplications,
        'totalHours': totalHours,
      });
    } catch (e) {
      return Left(CacheFailure('Failed to get statistics: ${e.toString()}'));
    }
  }
}