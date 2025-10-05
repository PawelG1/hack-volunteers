import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/volunteer.dart';
import '../entities/organization.dart';
import '../entities/school_coordinator.dart';

/// Repository for authentication and user management
abstract class AuthRepository {
  /// Sign up as Volunteer
  Future<Either<Failure, Volunteer>> signUpVolunteer({
    required String email,
    required String password,
    required String fullName,
    String? schoolId,
    String? className,
  });

  /// Sign up as Organization
  Future<Either<Failure, Organization>> signUpOrganization({
    required String email,
    required String password,
    required String name,
    required String nip,
    String? krs,
    required String address,
    required String phone,
  });

  /// Sign up as School Coordinator
  Future<Either<Failure, SchoolCoordinator>> signUpCoordinator({
    required String email,
    required String password,
    required String fullName,
    required String schoolId,
    required List<String> managedClasses,
  });

  /// Sign in with email and password
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Get current user stream (for real-time updates)
  Stream<User?> getCurrentUserStream();

  /// Update volunteer profile
  Future<Either<Failure, Volunteer>> updateVolunteerProfile(Volunteer volunteer);

  /// Get current volunteer profile (synchronous, from cache)
  Volunteer? getVolunteerProfile();

  /// Update organization profile
  Future<Either<Failure, Organization>> updateOrganizationProfile(
      Organization organization);

  /// Update coordinator profile
  Future<Either<Failure, SchoolCoordinator>> updateCoordinatorProfile(
      SchoolCoordinator coordinator);

  /// Reset password
  Future<Either<Failure, void>> resetPassword(String email);

  /// Delete account
  Future<Either<Failure, void>> deleteAccount();
}
