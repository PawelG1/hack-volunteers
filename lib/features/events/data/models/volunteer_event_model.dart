import '../../domain/entities/volunteer_event.dart';

/// Data model extending domain entity
/// Handles JSON serialization/deserialization
class VolunteerEventModel extends VolunteerEvent {
  const VolunteerEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.organization,
    required super.location,
    required super.date,
    required super.requiredVolunteers,
    required super.categories,
    super.imageUrl,
  });

  /// Create model from JSON
  factory VolunteerEventModel.fromJson(Map<String, dynamic> json) {
    return VolunteerEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organization: json['organization'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      requiredVolunteers: json['requiredVolunteers'] as int,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organization': organization,
      'location': location,
      'date': date.toIso8601String(),
      'requiredVolunteers': requiredVolunteers,
      'categories': categories,
      'imageUrl': imageUrl,
    };
  }

  /// Create model from domain entity
  factory VolunteerEventModel.fromEntity(VolunteerEvent entity) {
    return VolunteerEventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      organization: entity.organization,
      location: entity.location,
      date: entity.date,
      requiredVolunteers: entity.requiredVolunteers,
      categories: entity.categories,
      imageUrl: entity.imageUrl,
    );
  }
}
