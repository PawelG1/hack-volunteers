import 'package:equatable/equatable.dart';

enum SchoolType {
  podstawowa, // Szkoła podstawowa
  srednia, // Szkoła średnia
  zawodowa, // Szkoła zawodowa
  technikum, // Technikum
}

/// Szkoła - informacje o placówce edukacyjnej
class School extends Equatable {
  final String id;
  final String name;
  final SchoolType type;
  final String address;
  final String city;
  final String postalCode;
  final String? phone;
  final String? email;
  final String? regon; // Numer REGON szkoły
  final int totalStudents; // Liczba uczniów
  final int totalCoordinators; // Liczba koordynatorów wolontariatu
  final int totalVolunteerHours; // Suma godzin wolontariatu uczniów
  final DateTime createdAt;
  final bool isActive;

  const School({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.postalCode,
    this.phone,
    this.email,
    this.regon,
    required this.totalStudents,
    required this.totalCoordinators,
    required this.totalVolunteerHours,
    required this.createdAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        address,
        city,
        postalCode,
        phone,
        email,
        regon,
        totalStudents,
        totalCoordinators,
        totalVolunteerHours,
        createdAt,
        isActive,
      ];

  School copyWith({
    String? id,
    String? name,
    SchoolType? type,
    String? address,
    String? city,
    String? postalCode,
    String? phone,
    String? email,
    String? regon,
    int? totalStudents,
    int? totalCoordinators,
    int? totalVolunteerHours,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      regon: regon ?? this.regon,
      totalStudents: totalStudents ?? this.totalStudents,
      totalCoordinators: totalCoordinators ?? this.totalCoordinators,
      totalVolunteerHours: totalVolunteerHours ?? this.totalVolunteerHours,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
