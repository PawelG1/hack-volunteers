import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/volunteer_event_isar_model.dart';
import '../models/user_interest_isar_model.dart';
import 'isar_data_source.dart';

/// Implementation of Isar data source
class IsarDataSourceImpl implements IsarDataSource {
  Isar? _isar;

  Isar get isar {
    if (_isar == null) {
      throw Exception('Isar not initialized. Call init() first.');
    }
    return _isar!;
  }

  @override
  Future<void> init() async {
    if (_isar != null) return; // Already initialized

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [VolunteerEventIsarModelSchema, UserInterestIsarModelSchema],
      directory: dir.path,
      name: 'hack_volunteers_db',
    );
  }

  // ==================== EVENTS ====================

  @override
  Future<void> saveEvents(List<VolunteerEventIsarModel> events) async {
    await isar.writeTxn(() async {
      await isar.volunteerEventIsarModels.putAll(events);
    });
  }

  @override
  Future<List<VolunteerEventIsarModel>> getEvents() async {
    return await isar.volunteerEventIsarModels.where().findAll();
  }

  @override
  Future<VolunteerEventIsarModel?> getEventById(String eventId) async {
    return await isar.volunteerEventIsarModels
        .filter()
        .eventIdEqualTo(eventId)
        .findFirst();
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await isar.writeTxn(() async {
      await isar.volunteerEventIsarModels
          .filter()
          .eventIdEqualTo(eventId)
          .deleteFirst();
    });
  }

  @override
  Future<void> clearEvents() async {
    await isar.writeTxn(() async {
      await isar.volunteerEventIsarModels.clear();
    });
  }

  // ==================== USER INTERESTS ====================

  @override
  Future<void> saveInterest(UserInterestIsarModel interest) async {
    print('💾 DATABASE: Attempting to save interest for ${interest.eventId} with ID ${interest.id}');
    
    await isar.writeTxn(() async {
      // ATOMIC CHECK: Use putIfAbsent-like logic
      // First try to get existing record
      final existing = await isar.userInterestIsarModels.get(interest.id);
      
      if (existing != null) {
        print('💾 DATABASE: Found existing interest for ${interest.eventId}, isInterested: ${existing.isInterested}');
        
        // Only update if state changed
        if (existing.isInterested != interest.isInterested) {
          await isar.userInterestIsarModels.put(interest);
          print('💾 DATABASE: Updated interest for ${interest.eventId} from ${existing.isInterested} to ${interest.isInterested}');
        } else {
          print('🚫 DATABASE BLOCKED: Duplicate interest for ${interest.eventId}, same state (${interest.isInterested}) - skipping');
        }
      } else {
        // CRITICAL: Double-check with unique constraint 
        // In case of race condition, this will fail with unique constraint violation
        try {
          await isar.userInterestIsarModels.put(interest);
          print('💾 DATABASE: Saved NEW interest for ${interest.eventId} (isInterested: ${interest.isInterested})');
        } catch (e) {
          // This should catch unique constraint violations
          print('🚫 DATABASE ERROR: Failed to save ${interest.eventId} - likely duplicate: $e');
          // Try to get the existing record that caused the conflict
          final conflicting = await isar.userInterestIsarModels.get(interest.id);
          if (conflicting != null) {
            print('💾 DATABASE: Conflict resolved - found existing ${interest.eventId} with isInterested: ${conflicting.isInterested}');
          }
        }
      }
    });
  }

  @override
  Future<List<UserInterestIsarModel>> getInterests() async {
    return await isar.userInterestIsarModels.where().findAll();
  }

  @override
  Future<List<String>> getInterestedEventIds() async {
    final interests = await isar.userInterestIsarModels
        .filter()
        .isInterestedEqualTo(true)
        .findAll();

    final eventIds = interests.map((i) => i.eventId).toList();
    
    // Debug: Check for duplicates
    final uniqueIds = eventIds.toSet();
    if (eventIds.length != uniqueIds.length) {
      print('🚨 DATABASE CORRUPTION: Found ${eventIds.length - uniqueIds.length} duplicate interests!');
      print('📋 All interests: ${eventIds}');
      print('📋 Unique interests: ${uniqueIds.toList()}');
      
      // Log detailed info about each interest record
      for (final interest in interests) {
        print('💾 Interest record: ID=${interest.id}, eventId=${interest.eventId}, isInterested=${interest.isInterested}');
      }
      
      // NUCLEAR OPTION: Return only unique IDs
      final uniqueList = uniqueIds.toList();
      print('🔧 DEDUPLICATION: Returning ${uniqueList.length} unique events instead of ${eventIds.length}');
      return uniqueList;
    } else {
      print('✅ DATABASE OK: ${eventIds.length} unique interested events found');
    }

    return eventIds;
  }

  @override
  Future<List<String>> getSkippedEventIds() async {
    final interests = await isar.userInterestIsarModels
        .filter()
        .isInterestedEqualTo(false)
        .findAll();

    return interests.map((i) => i.eventId).toList();
  }

  @override
  Future<void> removeInterest(String eventId) async {
    await isar.writeTxn(() async {
      final interest = await isar.userInterestIsarModels
          .filter()
          .eventIdEqualTo(eventId)
          .findFirst();

      if (interest != null) {
        await isar.userInterestIsarModels.delete(interest.id);
      }
    });
  }

  @override
  Future<void> clearInterests() async {
    await isar.writeTxn(() async {
      await isar.userInterestIsarModels.clear();
    });
  }

  // ==================== LIFECYCLE ====================

  @override
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
