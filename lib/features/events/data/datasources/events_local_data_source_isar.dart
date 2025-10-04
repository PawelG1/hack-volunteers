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

    return isarEvents.map((isarEvent) => isarEvent.toModel()).toList();
  }

  @override
  Future<void> cacheEvents(List<VolunteerEventModel> events) async {
    final isarEvents = events
        .map((event) => VolunteerEventIsarModel.fromModel(event))
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

  @override
  Future<void> saveEvent(VolunteerEventModel event) async {
    print('💾 ISAR_IMPL: Saving event ${event.id} - ${event.title}');
    final isarEvent = VolunteerEventIsarModel.fromModel(event);
    await isarDataSource.saveEvent(isarEvent);
    print('💾 ISAR_IMPL: Event saved successfully');
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await isarDataSource.deleteEvent(eventId);
  }

  @override
  Future<List<VolunteerEventModel>> getAllEvents() async {
    return getCachedEvents(); // Alias to getCachedEvents
  }
}
