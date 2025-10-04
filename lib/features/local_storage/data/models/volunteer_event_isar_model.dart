import 'package:isar/isar.dart';

part 'volunteer_event_isar_model.g.dart';

/// Isar model for VolunteerEvent
/// Used for local database storage
@collection
class VolunteerEventIsarModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String eventId; // Original event ID from backend

  late String title;
  late String description;
  late String organization;
  late String location;

  @Index()
  late DateTime date;

  late int requiredVolunteers;
  late List<String> categories;

  String? imageUrl;

  // Metadata
  @Index()
  late DateTime cachedAt;

  late bool isSynced;

  // Empty constructor required by Isar
  VolunteerEventIsarModel();

  /// Convert from domain entity
  VolunteerEventIsarModel.create({
    required String eventId,
    required String title,
    required String description,
    required String organization,
    required String location,
    required DateTime date,
    required int requiredVolunteers,
    required List<String> categories,
    String? imageUrl,
  }) {
    this.eventId = eventId;
    this.title = title;
    this.description = description;
    this.organization = organization;
    this.location = location;
    this.date = date;
    this.requiredVolunteers = requiredVolunteers;
    this.categories = categories;
    this.imageUrl = imageUrl;
    cachedAt = DateTime.now();
    isSynced = true;
  }

  /// Convert to map for domain layer
  Map<String, dynamic> toDomain() {
    return {
      'id': eventId,
      'title': title,
      'description': description,
      'organization': organization,
      'location': location,
      'date': date,
      'requiredVolunteers': requiredVolunteers,
      'categories': categories,
      'imageUrl': imageUrl,
    };
  }
}
