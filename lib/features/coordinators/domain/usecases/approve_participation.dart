import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../repositories/coordinator_repository.dart';

/// Use case to approve a volunteer's participation
/// Changes application status from 'attended' to 'approved'
class ApproveParticipation implements UseCase<VolunteerApplication, ApproveParticipationParams> {
  final CoordinatorRepository repository;

  ApproveParticipation(this.repository);

  @override
  Future<Either<Failure, VolunteerApplication>> call(ApproveParticipationParams params) async {
    return await repository.approveParticipation(
      applicationId: params.applicationId,
      coordinatorId: params.coordinatorId,
      notes: params.notes,
    );
  }
}

/// Parameters for approving participation
class ApproveParticipationParams extends Equatable {
  final String applicationId;
  final String coordinatorId;
  final String? notes;

  const ApproveParticipationParams({
    required this.applicationId,
    required this.coordinatorId,
    this.notes,
  });

  @override
  List<Object?> get props => [applicationId, coordinatorId, notes];
}
