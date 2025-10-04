import 'package:isar/isar.dart';

part 'user_interest_isar_model.g.dart';

/// Isar model for user's event interests
@collection
class UserInterestIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
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
