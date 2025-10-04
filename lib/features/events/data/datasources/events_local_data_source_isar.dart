import '../models/volunteer_event_model.dart';
import '../../../local_storage/data/datasources/isar_data_source.dart';
import '../../../local_storage/data/models/volunteer_event_isar_model.dart';
import '../../../local_storage/data/models/user_interest_isar_model.dart';

/// Local data source using Isar
class EventsLocalDataSourceIsarImpl {
  final IsarDataSource isarDataSource;

  EventsLocalDataSourceIsarImpl(this.isarDataSource);

  /// Get cached events from Isar
  Future<List<VolunteerEventModel>> getCachedEvents() async {
    final isarEvents = await isarDataSource.getEvents();

    return isarEvents.map((isarEvent) {
      final domainMap = isarEvent.toDomain();
      return VolunteerEventModel.fromJson(domainMap);
    }).toList();
  }

  /// Cache events to Isar
  Future<void> cacheEvents(List<VolunteerEventModel> events) async {
    final isarEvents = events
        .map(
          (event) => VolunteerEventIsarModel.create(
            eventId: event.id,
            title: event.title,
            description: event.description,
            organization: event.organization,
            location: event.location,
            date: event.date,
            requiredVolunteers: event.requiredVolunteers,
            categories: event.categories,
            imageUrl: event.imageUrl,
          ),
        )
        .toList();

    await isarDataSource.saveEvents(isarEvents);
  }

  /// Save interested event
  Future<void> saveInterestedEvent(String eventId) async {
    final interest = UserInterestIsarModel.create(
      eventId: eventId,
      isInterested: true,
    );

    await isarDataSource.saveInterest(interest);
  }

  /// Save skipped event
  Future<void> saveSkippedEvent(String eventId) async {
    final interest = UserInterestIsarModel.create(
      eventId: eventId,
      isInterested: false,
    );

    await isarDataSource.saveInterest(interest);
  }

  /// Get interested event IDs
  Future<List<String>> getInterestedEventIds() async {
    return await isarDataSource.getInterestedEventIds();
  }

  /// Get skipped event IDs
  Future<List<String>> getSkippedEventIds() async {
    return await isarDataSource.getSkippedEventIds();
  }

  /// Clear all cached data
  Future<void> clearAll() async {
    await isarDataSource.clearEvents();
    await isarDataSource.clearInterests();
  }
}
