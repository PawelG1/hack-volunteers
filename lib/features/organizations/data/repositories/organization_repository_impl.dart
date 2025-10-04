import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../events/data/datasources/events_local_data_source.dart';
import '../../../events/data/models/volunteer_event_model.dart';
import '../../domain/entities/volunteer_application.dart';
import '../../domain/entities/certificate.dart';
import '../../domain/repositories/organization_repository.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final EventsLocalDataSource localDataSource;
  final Uuid uuid = const Uuid();

  OrganizationRepositoryImpl({
    required this.localDataSource,
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
      await localDataSource.saveEvent(eventModel);
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
      await localDataSource.saveEvent(eventModel);
      return Right(updatedEvent);
    } catch (e) {
      return Left(CacheFailure('Failed to update event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await localDataSource.deleteEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete event: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerEvent>>> getOrganizationEvents(String organizationId) async {
    try {
      print('📋 REPO: Getting organization events for organizationId: $organizationId');
      final allEventModels = await localDataSource.getAllEvents();
      print('📋 REPO: Found ${allEventModels.length} total events in Isar');
      
      // Convert models to entities
      final allEvents = allEventModels.map((model) => model.toEntity()).toList();
      
      // For now, return ALL events (later we'll add proper organization filtering)
      // TODO: Filter by organizationId when we have proper organization management
      print('📋 REPO: Returning all ${allEvents.length} events');
      for (final event in allEvents) {
        print('   - ${event.title} (id: ${event.id}, org: ${event.organization}, orgId: ${event.organizationId})');
      }
      
      return Right(allEvents);
    } catch (e) {
      print('📋 REPO: Error getting organization events: $e');
      return Left(CacheFailure('Failed to get organization events: ${e.toString()}'));
    }
  }

  // Mock implementations for other methods
  @override
  Future<Either<Failure, List<VolunteerApplication>>> getEventApplications(String eventId) async {
    // Mock implementation - return empty list for now
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<VolunteerApplication>>> getOrganizationApplications(String organizationId) async {
    // Mock implementation
    return const Right([]);
  }

  @override
  Future<Either<Failure, VolunteerApplication>> acceptApplication(String applicationId) async {
    // Mock implementation
    return Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, VolunteerApplication>> rejectApplication({
    required String applicationId,
    String? rejectionReason,
  }) async {
    // Mock implementation
    return Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, VolunteerApplication>> completeVolunteerWork({
    required String applicationId,
    required int hoursWorked,
    String? feedback,
  }) async {
    // Mock implementation
    return Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, Certificate>> issueCertificate({
    required String volunteerId,
    required String eventId,
    required int hoursWorked,
    String? description,
  }) async {
    // Mock implementation
    return Left(ServerFailure('Not implemented yet'));
  }

  @override
  Future<Either<Failure, List<Certificate>>> getOrganizationCertificates(String organizationId) async {
    // Mock implementation
    return const Right([]);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrganizationStatistics(String organizationId) async {
    // Mock implementation
    return const Right({
      'totalEvents': 0,
      'totalVolunteers': 0,
      'totalHours': 0,
    });
  }

  @override
  Future<Either<Failure, void>> rateVolunteer({
    required String applicationId,
    required double rating,
    String? comment,
  }) async {
    // Mock implementation
    return const Right(null);
  }
}