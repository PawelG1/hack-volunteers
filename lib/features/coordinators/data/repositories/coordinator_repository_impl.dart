import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../../domain/repositories/coordinator_repository.dart';
import '../datasources/coordinator_local_data_source.dart';
import '../../../auth/domain/entities/volunteer.dart';

/// Implementation of CoordinatorRepository using local data source (Isar)
class CoordinatorRepositoryImpl implements CoordinatorRepository {
  final CoordinatorLocalDataSource localDataSource;

  CoordinatorRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<VolunteerApplication>>> getPendingApprovals(String coordinatorId) async {
    try {
      final applications = await localDataSource.getPendingApprovals(coordinatorId);
      return Right(applications);
    } catch (e) {
      return Left(CacheFailure('Failed to get pending approvals: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, VolunteerApplication>> approveParticipation({
    required String applicationId,
    required String coordinatorId,
    String? notes,
  }) async {
    try {
      final application = await localDataSource.approveParticipation(
        applicationId: applicationId,
        coordinatorId: coordinatorId,
        notes: notes,
      );
      return Right(application);
    } catch (e) {
      return Left(CacheFailure('Failed to approve participation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Certificate>> generateCertificate({
    required String applicationId,
    required String coordinatorId,
    required String coordinatorName,
  }) async {
    try {
      final certificate = await localDataSource.generateCertificate(
        applicationId: applicationId,
        coordinatorId: coordinatorId,
        coordinatorName: coordinatorName,
      );
      return Right(certificate);
    } catch (e) {
      return Left(CacheFailure('Failed to generate certificate: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Certificate>>> getIssuedCertificates(String coordinatorId) async {
    try {
      final certificates = await localDataSource.getIssuedCertificates(coordinatorId);
      return Right(certificates);
    } catch (e) {
      return Left(CacheFailure('Failed to get issued certificates: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<VolunteerApplication>>> getSchoolApplications(String coordinatorId) async {
    try {
      final applications = await localDataSource.getSchoolApplications(coordinatorId);
      return Right(applications);
    } catch (e) {
      return Left(CacheFailure('Failed to get school applications: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCoordinatorStatistics(String coordinatorId) async {
    try {
      final applications = await localDataSource.getSchoolApplications(coordinatorId);
      final certificates = await localDataSource.getIssuedCertificates(coordinatorId);
      
      // Calculate statistics
      final totalApplications = applications.length;
      final approvedApplications = applications.where((app) => 
        app.status == ApplicationStatus.approved || 
        app.status == ApplicationStatus.completed
      ).length;
      final completedApplications = applications.where((app) => 
        app.status == ApplicationStatus.completed
      ).length;
      final pendingApprovals = applications.where((app) => 
        app.status == ApplicationStatus.attended
      ).length;
      
      int totalHours = 0;
      for (final app in applications) {
        if (app.hoursWorked != null) {
          totalHours += app.hoursWorked!;
        }
      }

      // Count unique volunteers
      final uniqueVolunteers = applications.map((app) => app.volunteerId).toSet().length;

      return Right({
        'totalApplications': totalApplications,
        'approvedApplications': approvedApplications,
        'completedApplications': completedApplications,
        'pendingApprovals': pendingApprovals,
        'totalCertificates': certificates.length,
        'totalHours': totalHours,
        'uniqueVolunteers': uniqueVolunteers,
      });
    } catch (e) {
      return Left(CacheFailure('Failed to get coordinator statistics: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> generateMonthlyReport({
    required String coordinatorId,
    required DateTime month,
  }) async {
    try {
      final applications = await localDataSource.getSchoolApplications(coordinatorId);
      
      // Filter applications by month
      final monthStart = DateTime(month.year, month.month, 1);
      final monthEnd = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
      
      final monthApplications = applications.where((app) {
        final approvedDate = app.approvedAt;
        return approvedDate != null && 
               approvedDate.isAfter(monthStart) && 
               approvedDate.isBefore(monthEnd);
      }).toList();

      int totalHours = 0;
      for (final app in monthApplications) {
        if (app.hoursWorked != null) {
          totalHours += app.hoursWorked!;
        }
      }

      final uniqueVolunteers = monthApplications.map((app) => app.volunteerId).toSet().length;

      return Right({
        'month': '${month.year}-${month.month.toString().padLeft(2, '0')}',
        'totalApplications': monthApplications.length,
        'totalHours': totalHours,
        'uniqueVolunteers': uniqueVolunteers,
        'applications': monthApplications.map((app) => {
          'volunteerId': app.volunteerId,
          'eventId': app.eventId,
          'hoursWorked': app.hoursWorked,
          'approvedAt': app.approvedAt?.toIso8601String(),
        }).toList(),
      });
    } catch (e) {
      return Left(CacheFailure('Failed to generate monthly report: ${e.toString()}'));
    }
  }

  // Legacy methods - TODO: Implement when student management is ready
  @override
  Future<Either<Failure, List<Volunteer>>> getAssignedStudents(String coordinatorId) async {
    // TODO: Implement student management
    return Left(ServerFailure('Student management not implemented yet'));
  }

  @override
  Future<Either<Failure, List<Volunteer>>> getStudentsByClass({
    required String coordinatorId,
    required String className,
  }) async {
    // TODO: Implement student management
    return Left(ServerFailure('Student management not implemented yet'));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSchoolStatistics(String schoolId) async {
    // TODO: Implement school-wide statistics
    return Left(ServerFailure('School statistics not implemented yet'));
  }
}
