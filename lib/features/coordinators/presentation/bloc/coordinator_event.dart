part of 'coordinator_bloc.dart';

abstract class CoordinatorEvent extends Equatable {
  const CoordinatorEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingApprovals extends CoordinatorEvent {
  final String coordinatorId;

  const LoadPendingApprovals({required this.coordinatorId});

  @override
  List<Object?> get props => [coordinatorId];
}

class ApproveVolunteerParticipation extends CoordinatorEvent {
  final String applicationId;
  final String coordinatorId;
  final String? notes;

  const ApproveVolunteerParticipation({
    required this.applicationId,
    required this.coordinatorId,
    this.notes,
  });

  @override
  List<Object?> get props => [applicationId, coordinatorId, notes];
}

class GenerateVolunteerCertificate extends CoordinatorEvent {
  final String applicationId;
  final String coordinatorId;
  final String coordinatorName;

  const GenerateVolunteerCertificate({
    required this.applicationId,
    required this.coordinatorId,
    required this.coordinatorName,
  });

  @override
  List<Object?> get props => [applicationId, coordinatorId, coordinatorName];
}

class LoadIssuedCertificates extends CoordinatorEvent {
  final String coordinatorId;

  const LoadIssuedCertificates({required this.coordinatorId});

  @override
  List<Object?> get props => [coordinatorId];
}

class LoadCoordinatorStatistics extends CoordinatorEvent {
  final String coordinatorId;

  const LoadCoordinatorStatistics({required this.coordinatorId});

  @override
  List<Object?> get props => [coordinatorId];
}

class GenerateCoordinatorMonthlyReport extends CoordinatorEvent {
  final String coordinatorId;
  final DateTime month;

  const GenerateCoordinatorMonthlyReport({
    required this.coordinatorId,
    required this.month,
  });

  @override
  List<Object?> get props => [coordinatorId, month];
}
