import 'package:equatable/equatable.dart';

/// Volunteer profile entity
class VolunteerProfile extends Equatable {
  final String name;
  final String email;
  final String? phone;
  final String? bio;
  final String? school;
  final DateTime? birthDate;
  final String gender;
  final List<String> interests;
  final String? profileImagePath;
  final int totalHours;
  final int totalEvents;
  final int points;

  const VolunteerProfile({
    required this.name,
    required this.email,
    this.phone,
    this.bio,
    this.school,
    this.birthDate,
    this.gender = 'Nie podano',
    this.interests = const [],
    this.profileImagePath,
    this.totalHours = 0,
    this.totalEvents = 0,
    this.points = 0,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        bio,
        school,
        birthDate,
        gender,
        interests,
        profileImagePath,
        totalHours,
        totalEvents,
        points,
      ];

  VolunteerProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? school,
    DateTime? birthDate,
    String? gender,
    List<String>? interests,
    String? profileImagePath,
    int? totalHours,
    int? totalEvents,
    int? points,
  }) {
    return VolunteerProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      school: school ?? this.school,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      totalHours: totalHours ?? this.totalHours,
      totalEvents: totalEvents ?? this.totalEvents,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'school': school,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'interests': interests,
      'profileImagePath': profileImagePath,
      'totalHours': totalHours,
      'totalEvents': totalEvents,
      'points': points,
    };
  }

  factory VolunteerProfile.fromJson(Map<String, dynamic> json) {
    return VolunteerProfile(
      name: json['name'] as String? ?? 'Jan Kowalski',
      email: json['email'] as String? ?? 'jan.kowalski@example.com',
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      school: json['school'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      gender: json['gender'] as String? ?? 'Nie podano',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      profileImagePath: json['profileImagePath'] as String?,
      totalHours: json['totalHours'] as int? ?? 0,
      totalEvents: json['totalEvents'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
    );
  }
}
