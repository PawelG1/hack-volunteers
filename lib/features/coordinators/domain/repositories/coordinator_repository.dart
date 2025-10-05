import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/volunteer.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/domain/entities/certificate.dart';

/// Repository for school coordinator operations
/// Coordinator responsibilities:
/// 1. Approve participation after attendance is marked by organization
/// 2. Generate certificates for approved volunteers
/// 3. Generate reports for school administration
abstract class CoordinatorRepository {
  /// Get applications pending coordinator approval (status = attended)
  Future<Either<Failure, List<VolunteerApplication>>> getPendingApprovals(
      String coordinatorId);

  /// Get all applications for coordinator's school
  Future<Either<Failure, List<VolunteerApplication>>> getSchoolApplications(
      String coordinatorId);

  /// Approve a volunteer's participation (changes status to approved)
  Future<Either<Failure, VolunteerApplication>> approveParticipation({
    required String applicationId,
    required String coordinatorId,
    String? notes,
  });

  /// Generate certificate for approved volunteer (changes status to completed)
  Future<Either<Failure, Certificate>> generateCertificate({
    required String applicationId,
    required String coordinatorId,
    required String coordinatorName,
  });

  /// Get all certificates issued by coordinator
  Future<Either<Failure, List<Certificate>>> getIssuedCertificates(
      String coordinatorId);

  /// Get coordinator statistics
  Future<Either<Failure, Map<String, dynamic>>> getCoordinatorStatistics(
      String coordinatorId);

  /// Generate monthly report for school
  Future<Either<Failure, Map<String, dynamic>>> generateMonthlyReport({
    required String coordinatorId,
    required DateTime month,
  });

  // Legacy methods - to be implemented later
  /// Get all students assigned to coordinator
  Future<Either<Failure, List<Volunteer>>> getAssignedStudents(
      String coordinatorId);

  /// Get students by class
  Future<Either<Failure, List<Volunteer>>> getStudentsByClass({
    required String coordinatorId,
    required String className,
  });

  /// Get school statistics
  Future<Either<Failure, Map<String, dynamic>>> getSchoolStatistics(
      String schoolId);
}
