import 'package:isar/isar.dart';

part 'user_interest_isar_model.g.dart';

/// Isar model for user's event interests
@collection
class UserInterestIsarModel {
  /// Use eventId hash as the primary key to enforce uniqueness at database level
  /// This prevents duplicate interests for the same event
  Id get id => fastHash(eventId);

  @Index(unique: true, replace: true)
  late String eventId;

  @Index()
  late DateTime interestDate;

  late bool isInterested; // true = liked, false = skipped

  // Empty constructor required by Isar
  UserInterestIsarModel();

  /// Create interest record
  UserInterestIsarModel.create({
    required this.eventId,
    required this.isInterested,
  }) {
    interestDate = DateTime.now();
  }
}

/// Fast hash function to convert eventId string to Id (int)
/// This ensures the same eventId always gets the same Id
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
