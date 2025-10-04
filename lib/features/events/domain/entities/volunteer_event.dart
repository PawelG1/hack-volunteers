import 'package:equatable/equatable.dart';

enum EventStatus {
  draft, // Szkic
  published, // Opublikowany
  inProgress, // W trakcie
  completed, // Zakończony
  cancelled, // Odwołany
}

/// Domain entity representing a volunteer event
class VolunteerEvent extends Equatable {
  final String id;
  final String title;
  final String description;
  final String organization; // Nazwa organizacji (dla wyświetlania)
  final String? organizationId; // ID organizacji (opcjonalne dla starych eventów)
  final String location;
  final DateTime date;
  final DateTime? endDate; // Data zakończenia (opcjonalna)
  final int requiredVolunteers;
  final int currentVolunteers; // Liczba zaaplikowanych wolontariuszy
  final List<String> categories;
  final String? imageUrl;
  final EventStatus status; // Status eventu
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? contactEmail; // Email kontaktowy organizacji
  final String? contactPhone; // Telefon kontaktowy

  const VolunteerEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.organization,
    this.organizationId,
    required this.location,
    required this.date,
    this.endDate,
    required this.requiredVolunteers,
    this.currentVolunteers = 0,
    required this.categories,
    this.imageUrl,
    this.status = EventStatus.published,
    required this.createdAt,
    this.updatedAt,
    this.contactEmail,
    this.contactPhone,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        organization,
        organizationId,
        location,
        date,
        endDate,
        requiredVolunteers,
        currentVolunteers,
        categories,
        imageUrl,
        status,
        createdAt,
        updatedAt,
        contactEmail,
        contactPhone,
      ];

  VolunteerEvent copyWith({
    String? id,
    String? title,
    String? description,
    String? organization,
    String? organizationId,
    String? location,
    DateTime? date,
    DateTime? endDate,
    int? requiredVolunteers,
    int? currentVolunteers,
    List<String>? categories,
    String? imageUrl,
    EventStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contactEmail,
    String? contactPhone,
  }) {
    return VolunteerEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organization: organization ?? this.organization,
      organizationId: organizationId ?? this.organizationId,
      location: location ?? this.location,
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      requiredVolunteers: requiredVolunteers ?? this.requiredVolunteers,
      currentVolunteers: currentVolunteers ?? this.currentVolunteers,
      categories: categories ?? this.categories,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}
