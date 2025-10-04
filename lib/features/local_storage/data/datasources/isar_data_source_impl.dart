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
    await isar.writeTxn(() async {
      // First, delete any existing interest for this event
      await isar.userInterestIsarModels
          .filter()
          .eventIdEqualTo(interest.eventId)
          .deleteAll();
      
      // Then save the new interest
      await isar.userInterestIsarModels.put(interest);
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

    return interests.map((i) => i.eventId).toList();
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
