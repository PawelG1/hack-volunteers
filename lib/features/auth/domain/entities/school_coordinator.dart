import 'package:equatable/equatable.dart';

/// School coordinator entity
class SchoolCoordinator extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String schoolId; // ID szkoły
  final String schoolName;
  final String position; // Stanowisko (np. pedagog, nauczyciel)
  final String phoneNumber;
  final String? officeRoom; // Numer pokoju/gabinetu
  final List<String> managedClasses; // Zarządzane klasy
  final int activeStudents; // Liczba aktywnych uczniów
  final int approvedCertificates; // Zatwierdzonych zaświadczeń
  final DateTime assignedAt; // Data przypisania jako koordynator

  const SchoolCoordinator({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.schoolId,
    required this.schoolName,
    required this.position,
    required this.phoneNumber,
    this.officeRoom,
    this.managedClasses = const [],
    this.activeStudents = 0,
    this.approvedCertificates = 0,
    required this.assignedAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        schoolId,
        schoolName,
        position,
        phoneNumber,
        officeRoom,
        managedClasses,
        activeStudents,
        approvedCertificates,
        assignedAt,
      ];

  SchoolCoordinator copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? schoolId,
    String? schoolName,
    String? position,
    String? phoneNumber,
    String? officeRoom,
    List<String>? managedClasses,
    int? activeStudents,
    int? approvedCertificates,
    DateTime? assignedAt,
  }) {
    return SchoolCoordinator(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      position: position ?? this.position,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      officeRoom: officeRoom ?? this.officeRoom,
      managedClasses: managedClasses ?? this.managedClasses,
      activeStudents: activeStudents ?? this.activeStudents,
      approvedCertificates: approvedCertificates ?? this.approvedCertificates,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }
}
