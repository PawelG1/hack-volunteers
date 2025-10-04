import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/volunteer_event.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_local_data_source.dart';
import '../datasources/events_remote_data_source.dart';

/// Implementation of EventsRepository
/// Following Dependency Inversion - depends on abstractions, not implementations
class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;
  final EventsLocalDataSource localDataSource;

  EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<VolunteerEvent>>> getEvents() async {
    try {
      // Try to get from remote
      final remoteEvents = await remoteDataSource.getEvents();

      // Cache the events
      await localDataSource.cacheEvents(remoteEvents);

      return Right(remoteEvents);
    } catch (e) {
      // If remote fails, try to get from cache
      try {
        final cachedEvents = await localDataSource.getCachedEvents();
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

      return Right(interestedEvents);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
