import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_application.dart';
import '../repositories/organization_repository.dart';

/// Use case to mark attendance for a volunteer at an event
class MarkAttendance implements UseCase<VolunteerApplication, MarkAttendanceParams> {
  final OrganizationRepository repository;

  MarkAttendance(this.repository);

  @override
  Future<Either<Failure, VolunteerApplication>> call(MarkAttendanceParams params) async {
    return await repository.completeVolunteerWork(
      applicationId: params.applicationId,
      hoursWorked: params.hoursWorked,
      feedback: params.feedback,
    );
  }
}

/// Parameters for marking attendance
class MarkAttendanceParams extends Equatable {
  final String applicationId;
  final int hoursWorked;
  final String? feedback;

  const MarkAttendanceParams({
    required this.applicationId,
    required this.hoursWorked,
    this.feedback,
  });

  @override
  List<Object?> get props => [applicationId, hoursWorked, feedback];
}
