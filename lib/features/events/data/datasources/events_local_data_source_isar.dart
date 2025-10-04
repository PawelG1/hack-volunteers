import '../models/volunteer_event_model.dart';
import 'events_local_data_source.dart';
import '../../../local_storage/data/datasources/isar_data_source.dart';
import '../../../local_storage/data/models/volunteer_event_isar_model.dart';
import '../../../local_storage/data/models/user_interest_isar_model.dart';

/// Local data source using Isar - implements EventsLocalDataSource interface
class EventsLocalDataSourceIsarImpl implements EventsLocalDataSource {
  final IsarDataSource isarDataSource;

  EventsLocalDataSourceIsarImpl(this.isarDataSource);

  @override
  Future<List<VolunteerEventModel>> getCachedEvents() async {
    final isarEvents = await isarDataSource.getEvents();

    return isarEvents.map((isarEvent) {
      final domainMap = isarEvent.toDomain();
      return VolunteerEventModel.fromJson(domainMap);
    }).toList();
  }

  @override
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

  @override
  Future<void> saveInterestedEvent(String eventId) async {
    final interest = UserInterestIsarModel.create(
      eventId: eventId,
      isInterested: true,
    );

    await isarDataSource.saveInterest(interest);
  }

  @override
  Future<void> saveSkippedEvent(String eventId) async {
    final interest = UserInterestIsarModel.create(
      eventId: eventId,
      isInterested: false,
    );

    await isarDataSource.saveInterest(interest);
  }

  @override
  Future<List<String>> getInterestedEventIds() async {
    return await isarDataSource.getInterestedEventIds();
  }

  @override
  Future<void> removeInterestedEvent(String eventId) async {
    await isarDataSource.removeInterest(eventId);
  }

  @override
  Future<void> clearAllInterests() async {
    await isarDataSource.clearInterests();
  }

  /// Get skipped event IDs (additional method, not in interface)
  Future<List<String>> getSkippedEventIds() async {
    return await isarDataSource.getSkippedEventIds();
  }

  /// Clear all cached data (additional method, not in interface)
  Future<void> clearAll() async {
    await isarDataSource.clearEvents();
    await isarDataSource.clearInterests();
  }
}
