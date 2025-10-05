import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/volunteer_application.dart';
import '../repositories/organization_repository.dart';

/// Use case to reject a volunteer application
class RejectApplication implements UseCase<VolunteerApplication, RejectApplicationParams> {
  final OrganizationRepository repository;

  RejectApplication(this.repository);

  @override
  Future<Either<Failure, VolunteerApplication>> call(RejectApplicationParams params) async {
    return await repository.rejectApplication(
      applicationId: params.applicationId,
      rejectionReason: params.reason,
    );
  }
}

/// Parameters for rejecting an application
class RejectApplicationParams extends Equatable {
  final String applicationId;
  final String? reason;

  const RejectApplicationParams({
    required this.applicationId,
    this.reason,
  });

  @override
  List<Object?> get props => [applicationId, reason];
}
