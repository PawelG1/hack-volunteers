import 'package:equatable/equatable.dart';

/// Volunteer profile entity
class Volunteer extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? school; // Szkoła
  final String? schoolClass; // Klasa
  final List<String> interests; // Zainteresowania/kategorie
  final List<String> skills; // Umiejętności
  final int totalHours; // Całkowita liczba godzin wolontariatu
  final int completedEvents; // Liczba ukończonych wydarzeń
  final double rating; // Średnia ocena od organizacji
  final List<String> certificates; // ID certyfikatów

  const Volunteer({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.phoneNumber,
    this.address,
    this.city,
    this.school,
    this.schoolClass,
    this.interests = const [],
    this.skills = const [],
    this.totalHours = 0,
    this.completedEvents = 0,
    this.rating = 0.0,
    this.certificates = const [],
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        dateOfBirth,
        phoneNumber,
        address,
        city,
        school,
        schoolClass,
        interests,
        skills,
        totalHours,
        completedEvents,
        rating,
        certificates,
      ];

  Volunteer copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? address,
    String? city,
    String? school,
    String? schoolClass,
    List<String>? interests,
    List<String>? skills,
    int? totalHours,
    int? completedEvents,
    double? rating,
    List<String>? certificates,
  }) {
    return Volunteer(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      school: school ?? this.school,
      schoolClass: schoolClass ?? this.schoolClass,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      totalHours: totalHours ?? this.totalHours,
      completedEvents: completedEvents ?? this.completedEvents,
      rating: rating ?? this.rating,
      certificates: certificates ?? this.certificates,
    );
  }
}
