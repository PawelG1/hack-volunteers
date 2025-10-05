import 'package:isar/isar.dart';

part 'user_isar_model.g.dart';

/// Isar model for User storage
@collection
class UserIsarModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String email;

  late String displayName;
  late String passwordHash; // In production use proper hashing
  
  @Enumerated(EnumType.name)
  late UserRoleIsar role;

  String? avatarUrl;
  late DateTime createdAt;
  DateTime? lastLoginAt;
  late bool isActive;

  // Volunteer-specific fields (null if not volunteer)
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? phoneNumber;
  String? address;
  String? city;
  String? school;
  String? schoolClass;
  late List<String> interests;
  late List<String> skills;
  late int totalHours;
  late int completedEvents;
  late double rating;

  UserIsarModel({
    this.id = Isar.autoIncrement,
    required this.email,
    required this.displayName,
    required this.passwordHash,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
    this.firstName,
    this.lastName,
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
  });
}

enum UserRoleIsar {
  volunteer,
  organization,
  schoolCoordinator,
}
