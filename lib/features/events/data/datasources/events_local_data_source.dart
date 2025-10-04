import 'package:isar/isar.dart';
import '../models/volunteer_event_model.dart';
import '../../../local_storage/data/models/volunteer_event_isar_model.dart';

/// Abstract interface for local data source
/// Following Interface Segregation Principle
abstract class EventsLocalDataSource {
  /// Get cached events
  Future<List<VolunteerEventModel>> getCachedEvents();

  /// Cache events
  Future<void> cacheEvents(List<VolunteerEventModel> events);

  /// Save interested event ID
  Future<void> saveInterestedEvent(String eventId);

  /// Save skipped event ID
  Future<void> saveSkippedEvent(String eventId);

  /// Get interested event IDs
  Future<List<String>> getInterestedEventIds();

  /// Remove event from interested events
  Future<void> removeInterestedEvent(String eventId);

  /// Clear all interested events
  Future<void> clearAllInterests();

  /// Save single event (for creating/updating)
  Future<void> saveEvent(VolunteerEventModel event);

  /// Delete event by ID
  Future<void> deleteEvent(String eventId);

  /// Get all events (alias for getCachedEvents for organization repo)
  Future<List<VolunteerEventModel>> getAllEvents();
}

/// Isar implementation for events local data source
class EventsLocalDataSourceImpl implements EventsLocalDataSource {
  final Isar isar;

  EventsLocalDataSourceImpl({required this.isar});

  @override
  Future<List<VolunteerEventModel>> getCachedEvents() async {
    final isarEvents = await isar.volunteerEventIsarModels.where().findAll();
    return isarEvents.map((e) => e.toModel()).toList();
  }

  @override
  Future<void> cacheEvents(List<VolunteerEventModel> events) async {
    await isar.writeTxn(() async {
      // Clear old events and add new ones
      await isar.volunteerEventIsarModels.clear();
      for (final event in events) {
        final isarModel = VolunteerEventIsarModel.fromModel(event);
        await isar.volunteerEventIsarModels.put(isarModel);
      }
    });
  }

  @override
  Future<void> saveInterestedEvent(String eventId) async {
    // For now, we'll handle this in UserInterestIsarModel
    // This is just a placeholder
    print('💾 Saving interested event: $eventId');
  }

  @override
  Future<void> saveSkippedEvent(String eventId) async {
    // Placeholder for skipped events
    print('💾 Saving skipped event: $eventId');
  }

  @override
  Future<List<String>> getInterestedEventIds() async {
    // Placeholder - should query UserInterestIsarModel
    return [];
  }

  @override
  Future<void> removeInterestedEvent(String eventId) async {
    // Placeholder
    print('💾 Removing interested event: $eventId');
  }

  @override
  Future<void> clearAllInterests() async {
    // Placeholder
    print('💾 Clearing all interests');
  }

  @override
  Future<void> saveEvent(VolunteerEventModel event) async {
    print('💾 ISAR: Saving event to database: ${event.id} - ${event.title}');
    await isar.writeTxn(() async {
      // Check if event exists
      final existingEvent = await isar.volunteerEventIsarModels
          .filter()
          .eventIdEqualTo(event.id)
          .findFirst();
      
      if (existingEvent != null) {
        print('💾 ISAR: Updating existing event ${event.id}');
        // Update existing event
        final updatedModel = VolunteerEventIsarModel.fromModel(event);
        updatedModel.id = existingEvent.id; // Keep the same Isar ID
        await isar.volunteerEventIsarModels.put(updatedModel);
      } else {
        print('💾 ISAR: Creating new event ${event.id}');
        // Create new event
        final newModel = VolunteerEventIsarModel.fromModel(event);
        await isar.volunteerEventIsarModels.put(newModel);
      }
    });
    print('💾 ISAR: Event saved successfully!');
    
    // Verify save
    final allEvents = await getAllEvents();
    print('💾 ISAR: Total events in database: ${allEvents.length}');
    for (final e in allEvents) {
      print('   - ${e.id}: ${e.title}');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await isar.writeTxn(() async {
      final eventToDelete = await isar.volunteerEventIsarModels
          .filter()
          .eventIdEqualTo(eventId)
          .findFirst();
      
      if (eventToDelete != null) {
        await isar.volunteerEventIsarModels.delete(eventToDelete.id);
        print('💾 ISAR: Deleted event $eventId');
      }
    });
  }

  @override
  Future<List<VolunteerEventModel>> getAllEvents() async {
    return getCachedEvents();
  }
}
