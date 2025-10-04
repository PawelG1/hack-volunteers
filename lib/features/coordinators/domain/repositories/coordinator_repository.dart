import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/volunteer.dart';
import '../../../organizations/domain/entities/certificate.dart';

/// Repository for school coordinator operations
abstract class CoordinatorRepository {
  /// Get all students assigned to coordinator
  Future<Either<Failure, List<Volunteer>>> getAssignedStudents(
      String coordinatorId);

  /// Get students by class
  Future<Either<Failure, List<Volunteer>>> getStudentsByClass({
    required String coordinatorId,
    required String className,
  });

  /// Get pending certificates for approval
  Future<Either<Failure, List<Certificate>>> getPendingCertificates(
      String coordinatorId);

  /// Approve certificate
  Future<Either<Failure, Certificate>> approveCertificate(
      String certificateId);

  /// Reject certificate
  Future<Either<Failure, Certificate>> rejectCertificate({
    required String certificateId,
    String? rejectionReason,
  });

  /// Get school statistics
  Future<Either<Failure, Map<String, dynamic>>> getSchoolStatistics(
      String schoolId);

  /// Get coordinator statistics
  Future<Either<Failure, Map<String, dynamic>>> getCoordinatorStatistics(
      String coordinatorId);

  /// Generate school volunteer report
  Future<Either<Failure, Map<String, dynamic>>> generateSchoolReport({
    required String schoolId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Generate coordinator report
  Future<Either<Failure, Map<String, dynamic>>> generateCoordinatorReport({
    required String coordinatorId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
