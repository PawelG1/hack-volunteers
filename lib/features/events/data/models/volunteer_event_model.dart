import '../../domain/entities/volunteer_event.dart';

/// Data model extending domain entity
/// Handles JSON serialization/deserialization
class VolunteerEventModel extends VolunteerEvent {
  const VolunteerEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.organization,
    super.organizationId,
    required super.location,
    required super.date,
    super.endDate,
    required super.requiredVolunteers,
    super.currentVolunteers = 0,
    required super.categories,
    super.imageUrl,
    super.status = EventStatus.published,
    required super.createdAt,
    super.updatedAt,
    super.contactEmail,
    super.contactPhone,
  });

  /// Create model from JSON
  factory VolunteerEventModel.fromJson(Map<String, dynamic> json) {
    return VolunteerEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organization: json['organization'] as String,
      organizationId: json['organizationId'] as String?,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : null,
      requiredVolunteers: json['requiredVolunteers'] as int,
      currentVolunteers: json['currentVolunteers'] as int? ?? 0,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      status: EventStatus.values.firstWhere(
        (e) => e.toString() == 'EventStatus.${json['status']}',
        orElse: () => EventStatus.published,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organization': organization,
      'organizationId': organizationId,
      'location': location,
      'date': date.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'requiredVolunteers': requiredVolunteers,
      'currentVolunteers': currentVolunteers,
      'categories': categories,
      'imageUrl': imageUrl,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
    };
  }

  /// Create model from domain entity
  factory VolunteerEventModel.fromEntity(VolunteerEvent entity) {
    return VolunteerEventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      organization: entity.organization,
      organizationId: entity.organizationId,
      location: entity.location,
      date: entity.date,
      endDate: entity.endDate,
      requiredVolunteers: entity.requiredVolunteers,
      currentVolunteers: entity.currentVolunteers,
      categories: entity.categories,
      imageUrl: entity.imageUrl,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      contactEmail: entity.contactEmail,
      contactPhone: entity.contactPhone,
    );
  }
}
