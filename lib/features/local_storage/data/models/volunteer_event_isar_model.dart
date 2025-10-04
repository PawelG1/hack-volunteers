import 'package:isar/isar.dart';
import '../../../events/data/models/volunteer_event_model.dart';
import '../../../events/domain/entities/volunteer_event.dart';

part 'volunteer_event_isar_model.g.dart';

/// Isar model for VolunteerEvent
/// Used for local database storage
@collection
class VolunteerEventIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String eventId; // Original event ID from backend/UUID

  late String title;
  late String description;
  late String organization;
  String? organizationId;
  late String location;

  @Index()
  late DateTime date;
  DateTime? endDate;

  late int requiredVolunteers;
  late int currentVolunteers;
  late List<String> categories;

  String? imageUrl;
  
  // Status as byte (0=draft, 1=published, 2=inProgress, 3=completed, 4=cancelled)
  @Index()
  late byte status;

  late DateTime createdAt;
  DateTime? updatedAt;

  String? contactEmail;
  String? contactPhone;

  // Metadata
  @Index()
  late DateTime cachedAt;

  late bool isSynced;

  // Empty constructor required by Isar
  VolunteerEventIsarModel();

  /// Convert from VolunteerEventModel
  factory VolunteerEventIsarModel.fromModel(VolunteerEventModel model) {
    return VolunteerEventIsarModel()
      ..eventId = model.id
      ..title = model.title
      ..description = model.description
      ..organization = model.organization
      ..organizationId = model.organizationId
      ..location = model.location
      ..date = model.date
      ..endDate = model.endDate
      ..requiredVolunteers = model.requiredVolunteers
      ..currentVolunteers = model.currentVolunteers
      ..categories = model.categories
      ..imageUrl = model.imageUrl
      ..status = _statusToByte(model.status)
      ..createdAt = model.createdAt
      ..updatedAt = model.updatedAt
      ..contactEmail = model.contactEmail
      ..contactPhone = model.contactPhone
      ..cachedAt = DateTime.now()
      ..isSynced = true;
  }

  /// Convert to VolunteerEventModel
  VolunteerEventModel toModel() {
    return VolunteerEventModel(
      id: eventId,
      title: title,
      description: description,
      organization: organization,
      organizationId: organizationId,
      location: location,
      date: date,
      endDate: endDate,
      requiredVolunteers: requiredVolunteers,
      currentVolunteers: currentVolunteers,
      categories: categories,
      imageUrl: imageUrl,
      status: _byteToStatus(status),
      createdAt: createdAt,
      updatedAt: updatedAt,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
    );
  }

  static byte _statusToByte(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return 0;
      case EventStatus.published:
        return 1;
      case EventStatus.inProgress:
        return 2;
      case EventStatus.completed:
        return 3;
      case EventStatus.cancelled:
        return 4;
    }
  }

  static EventStatus _byteToStatus(byte statusByte) {
    switch (statusByte) {
      case 0:
        return EventStatus.draft;
      case 1:
        return EventStatus.published;
      case 2:
        return EventStatus.inProgress;
      case 3:
        return EventStatus.completed;
      case 4:
        return EventStatus.cancelled;
      default:
        return EventStatus.published;
    }
  }
}
