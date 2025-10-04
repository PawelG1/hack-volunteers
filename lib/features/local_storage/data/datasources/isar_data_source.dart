import '../models/volunteer_event_isar_model.dart';
import '../models/user_interest_isar_model.dart';

/// Abstract interface for Isar database operations
abstract class IsarDataSource {
  /// Initialize Isar database
  Future<void> init();

  /// Events operations
  Future<void> saveEvents(List<VolunteerEventIsarModel> events);
  Future<List<VolunteerEventIsarModel>> getEvents();
  Future<VolunteerEventIsarModel?> getEventById(String eventId);
  Future<void> deleteEvent(String eventId);
  Future<void> clearEvents();

  /// User interests operations
  Future<void> saveInterest(UserInterestIsarModel interest);
  Future<List<UserInterestIsarModel>> getInterests();
  Future<List<String>> getInterestedEventIds();
  Future<List<String>> getSkippedEventIds();
  Future<void> clearInterests();

  /// Close database
  Future<void> close();
}
