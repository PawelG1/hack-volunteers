import 'package:equatable/equatable.dart';

/// Domain entity representing a volunteer event
class VolunteerEvent extends Equatable {
  final String id;
  final String title;
  final String description;
  final String organization;
  final String location;
  final DateTime date;
  final int requiredVolunteers;
  final List<String> categories;
  final String? imageUrl;

  const VolunteerEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.organization,
    required this.location,
    required this.date,
    required this.requiredVolunteers,
    required this.categories,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    organization,
    location,
    date,
    requiredVolunteers,
    categories,
    imageUrl,
  ];
}
