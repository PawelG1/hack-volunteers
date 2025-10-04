import '../models/volunteer_event_model.dart';

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
}

/// Mock implementation for now - will be replaced with Isar later
class EventsLocalDataSourceImpl implements EventsLocalDataSource {
  // In-memory storage for now
  List<VolunteerEventModel> _cachedEvents = [];
  final List<String> _interestedEventIds = [];
  final List<String> _skippedEventIds = [];

  @override
  Future<List<VolunteerEventModel>> getCachedEvents() async {
    return _cachedEvents;
  }

  @override
  Future<void> cacheEvents(List<VolunteerEventModel> events) async {
    _cachedEvents = events;
  }

  @override
  Future<void> saveInterestedEvent(String eventId) async {
    if (!_interestedEventIds.contains(eventId)) {
      _interestedEventIds.add(eventId);
    }
  }

  @override
  Future<void> saveSkippedEvent(String eventId) async {
    if (!_skippedEventIds.contains(eventId)) {
      _skippedEventIds.add(eventId);
    }
  }

  @override
  Future<List<String>> getInterestedEventIds() async {
    return _interestedEventIds;
  }
}
