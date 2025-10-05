import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/volunteer_event.dart';
import '../../domain/repositories/events_repository.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/data/datasources/organization_local_data_source.dart';
import '../datasources/events_local_data_source.dart';
import '../datasources/events_remote_data_source.dart';

/// Implementation of EventsRepository
/// Following Dependency Inversion - depends on abstractions, not implementations
class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;
  final EventsLocalDataSource localDataSource;
  final OrganizationLocalDataSource organizationLocalDataSource;
  final Uuid uuid = const Uuid();

  EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.organizationLocalDataSource,
  });

  @override
  Future<Either<Failure, List<VolunteerEvent>>> getEvents() async {
    try {
      print('📱 VOLUNTEER REPO: Getting events...');
      
      // ALWAYS fetch from remote to get latest data (including images)
      print('📱 VOLUNTEER REPO: Fetching from remote...');
      final remoteEvents = await remoteDataSource.getEvents();
      
      // Cache the remote events (this will update imageUrl fields)
      await localDataSource.cacheEvents(remoteEvents);
      print('📱 VOLUNTEER REPO: Cached ${remoteEvents.length} remote events');
      
      for (final event in remoteEvents) {
        print('   - ${event.title} (id: ${event.id}, imageUrl: ${event.imageUrl})');
      }
      
      return Right(remoteEvents);
    } catch (e) {
      print('📱 VOLUNTEER REPO: Error getting events: $e');
      // If remote fails, try cache as fallback
      try {
        final cachedEvents = await localDataSource.getCachedEvents();
        print('📱 VOLUNTEER REPO: Using cached events: ${cachedEvents.length}');
        if (cachedEvents.isEmpty) {
          return const Left(CacheFailure('No cached events available'));
        }
        return Right(cachedEvents);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> saveInterestedEvent(String eventId) async {
    try {
      await localDataSource.saveInterestedEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSkippedEvent(String eventId) async {
    try {
      await localDataSource.saveSkippedEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerEvent>>> getInterestedEvents() async {
    try {
      final interestedIds = await localDataSource.getInterestedEventIds();
      final allEvents = await localDataSource.getCachedEvents();

      final interestedEvents = allEvents
          .where((event) => interestedIds.contains(event.id))
          .toList();

      // CRITICAL FIX: Remove duplicates that might exist in cached events
      final uniqueEvents = <String, VolunteerEvent>{};
      for (final event in interestedEvents) {
        uniqueEvents[event.id] = event; // This will overwrite duplicates
      }
      final deduplicatedEvents = uniqueEvents.values.toList();

      // Debug: Log deduplication
      if (interestedEvents.length != deduplicatedEvents.length) {
        print('🔧 REPOSITORY DEDUPLICATION: ${interestedEvents.length} → ${deduplicatedEvents.length}');
      }

      return Right(deduplicatedEvents);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VolunteerApplication>> applyForEvent({
    required String eventId,
    required String volunteerId,
    String? message,
  }) async {
    try {
      // Get event to find organizationId
      final allEvents = await localDataSource.getCachedEvents();
      final event = allEvents.firstWhere((e) => e.id == eventId);

      // Create and save application to database
      final application = await organizationLocalDataSource.createApplication(
        eventId: eventId,
        volunteerId: volunteerId,
        organizationId: event.organizationId ?? 'unknown',
        message: message,
      );

      print('✅ Application created and saved: ${application.id}');
      print('   Event: $eventId');
      print('   Volunteer: $volunteerId');
      print('   Organization: ${event.organizationId}');
      print('   Status: ${application.status}');

      return Right(application);
    } catch (e) {
      print('❌ Error applying for event: $e');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeInterestedEvent(String eventId) async {
    try {
      await localDataSource.removeInterestedEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllInterestedEvents() async {
    try {
      await localDataSource.clearAllInterests();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
