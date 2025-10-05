part of 'coordinator_bloc.dart';

abstract class CoordinatorState extends Equatable {
  const CoordinatorState();

  @override
  List<Object?> get props => [];
}

class CoordinatorInitial extends CoordinatorState {}

class CoordinatorLoading extends CoordinatorState {}

class PendingApprovalsLoaded extends CoordinatorState {
  final List<VolunteerApplication> applications;

  const PendingApprovalsLoaded(this.applications);

  @override
  List<Object?> get props => [applications];
}

class ParticipationApproved extends CoordinatorState {
  final VolunteerApplication application;

  const ParticipationApproved(this.application);

  @override
  List<Object?> get props => [application];
}

class CertificateGenerated extends CoordinatorState {
  final Certificate certificate;

  const CertificateGenerated(this.certificate);

  @override
  List<Object?> get props => [certificate];
}

class IssuedCertificatesLoaded extends CoordinatorState {
  final List<Certificate> certificates;

  const IssuedCertificatesLoaded(this.certificates);

  @override
  List<Object?> get props => [certificates];
}

class CoordinatorStatisticsLoaded extends CoordinatorState {
  final Map<String, dynamic> statistics;

  const CoordinatorStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class MonthlyReportGenerated extends CoordinatorState {
  final Map<String, dynamic> report;

  const MonthlyReportGenerated(this.report);

  @override
  List<Object?> get props => [report];
}

class CoordinatorError extends CoordinatorState {
  final String message;

  const CoordinatorError(this.message);

  @override
  List<Object?> get props => [message];
}
