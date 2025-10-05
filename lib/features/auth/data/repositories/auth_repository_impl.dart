import 'package:dartz/dartz.dart';
import 'package:isar/isar.dart';
import 'dart:async';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/volunteer.dart';
import '../../domain/entities/organization.dart';
import '../../domain/entities/school_coordinator.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../local_storage/data/models/user_isar_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Isar isar;
  UserIsarModel? _currentUser;
  final StreamController<User?> _userStreamController = StreamController<User?>.broadcast();

  AuthRepositoryImpl(this.isar);

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Simple password check - in production use proper hashing
      final user = await isar.userIsarModels
          .filter()
          .emailEqualTo(email)
          .findFirst();

      if (user == null) {
        return Left(ServerFailure('Użytkownik nie istnieje'));
      }

      if (user.passwordHash != password) {
        return Left(ServerFailure('Nieprawidłowe hasło'));
      }

      if (!user.isActive) {
        return Left(ServerFailure('Konto jest nieaktywne'));
      }

      // Update last login
      user.lastLoginAt = DateTime.now();
      await isar.writeTxn(() async {
        await isar.userIsarModels.put(user);
      });

      _currentUser = user;
      final mappedUser = _mapToUser(user);
      _userStreamController.add(mappedUser);
      return Right(mappedUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Volunteer>> signUpVolunteer({
    required String email,
    required String password,
    required String fullName,
    String? schoolId,
    String? className,
  }) async {
    try {
      // Check if user exists
      final existingUser = await isar.userIsarModels
          .filter()
          .emailEqualTo(email)
          .findFirst();

      if (existingUser != null) {
        return Left(ServerFailure('Użytkownik z tym emailem już istnieje'));
      }

      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final now = DateTime.now();
      final user = UserIsarModel(
        email: email,
        displayName: fullName,
        passwordHash: password, // In production use proper hashing
        role: UserRoleIsar.volunteer,
        createdAt: now,
        lastLoginAt: now,
        firstName: firstName,
        lastName: lastName,
        school: schoolId,
        schoolClass: className,
      );

      await isar.writeTxn(() async {
        await isar.userIsarModels.put(user);
      });

      _currentUser = user;
      final volunteer = _mapToVolunteer(user);
      _userStreamController.add(_mapToUser(user));
      return Right(volunteer);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Organization>> signUpOrganization({
    required String email,
    required String password,
    required String name,
    required String nip,
    String? krs,
    required String address,
    required String phone,
  }) async {
    return Left(ServerFailure('Rejestracja organizacji nie jest jeszcze zaimplementowana'));
  }

  @override
  Future<Either<Failure, SchoolCoordinator>> signUpCoordinator({
    required String email,
    required String password,
    required String fullName,
    required String schoolId,
    required List<String> managedClasses,
  }) async {
    return Left(ServerFailure('Rejestracja koordynatora nie jest jeszcze zaimplementowana'));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      _currentUser = null;
      _userStreamController.add(null);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      if (_currentUser != null) {
        return Right(_mapToUser(_currentUser!));
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<User?> getCurrentUserStream() {
    return _userStreamController.stream;
  }

  Volunteer? getVolunteerProfile() {
    if (_currentUser == null || _currentUser!.role != UserRoleIsar.volunteer) {
      return null;
    }
    return _mapToVolunteer(_currentUser!);
  }

  @override
  Future<Either<Failure, Volunteer>> updateVolunteerProfile(
      Volunteer volunteer) async {
    try {
      if (_currentUser == null) {
        return Left(CacheFailure('Brak zalogowanego użytkownika'));
      }

      _currentUser!.firstName = volunteer.firstName;
      _currentUser!.lastName = volunteer.lastName;
      _currentUser!.dateOfBirth = volunteer.dateOfBirth;
      _currentUser!.phoneNumber = volunteer.phoneNumber;
      _currentUser!.address = volunteer.address;
      _currentUser!.city = volunteer.city;
      _currentUser!.school = volunteer.school;
      _currentUser!.schoolClass = volunteer.schoolClass;
      _currentUser!.interests = volunteer.interests;
      _currentUser!.skills = volunteer.skills;
      _currentUser!.totalHours = volunteer.totalHours;
      _currentUser!.completedEvents = volunteer.completedEvents;
      _currentUser!.rating = volunteer.rating;

      await isar.writeTxn(() async {
        await isar.userIsarModels.put(_currentUser!);
      });

      _userStreamController.add(_mapToUser(_currentUser!));
      return Right(volunteer);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Organization>> updateOrganizationProfile(
      Organization organization) async {
    return Left(ServerFailure('Aktualizacja profilu organizacji nie jest jeszcze zaimplementowana'));
  }

  @override
  Future<Either<Failure, SchoolCoordinator>> updateCoordinatorProfile(
      SchoolCoordinator coordinator) async {
    return Left(ServerFailure('Aktualizacja profilu koordynatora nie jest jeszcze zaimplementowana'));
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    return Left(ServerFailure('Reset hasła nie jest jeszcze zaimplementowany'));
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      if (_currentUser == null) {
        return Left(CacheFailure('Brak zalogowanego użytkownika'));
      }

      await isar.writeTxn(() async {
        await isar.userIsarModels.delete(_currentUser!.id);
      });

      _currentUser = null;
      _userStreamController.add(null);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  User _mapToUser(UserIsarModel model) {
    return User(
      id: model.id.toString(),
      email: model.email,
      displayName: model.displayName,
      role: _mapFromIsarRole(model.role),
      avatarUrl: model.avatarUrl,
      createdAt: model.createdAt,
      lastLoginAt: model.lastLoginAt,
      isActive: model.isActive,
    );
  }

  Volunteer _mapToVolunteer(UserIsarModel model) {
    return Volunteer(
      userId: model.id.toString(),
      firstName: model.firstName ?? '',
      lastName: model.lastName ?? '',
      dateOfBirth: model.dateOfBirth,
      phoneNumber: model.phoneNumber,
      address: model.address,
      city: model.city,
      school: model.school,
      schoolClass: model.schoolClass,
      interests: model.interests,
      skills: model.skills,
      totalHours: model.totalHours,
      completedEvents: model.completedEvents,
      rating: model.rating,
      certificates: const [],
    );
  }

  UserRoleIsar _mapToIsarRole(UserRole role) {
    switch (role) {
      case UserRole.volunteer:
        return UserRoleIsar.volunteer;
      case UserRole.organization:
        return UserRoleIsar.organization;
      case UserRole.schoolCoordinator:
        return UserRoleIsar.schoolCoordinator;
    }
  }

  UserRole _mapFromIsarRole(UserRoleIsar role) {
    switch (role) {
      case UserRoleIsar.volunteer:
        return UserRole.volunteer;
      case UserRoleIsar.organization:
        return UserRole.organization;
      case UserRoleIsar.schoolCoordinator:
        return UserRole.schoolCoordinator;
    }
  }
}
