import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../../domain/usecases/get_pending_approvals.dart';
import '../../domain/usecases/approve_participation.dart';
import '../../domain/usecases/generate_certificate.dart';
import '../../domain/usecases/get_issued_certificates.dart';
import '../../domain/usecases/generate_monthly_report.dart';
import '../../domain/usecases/get_coordinator_statistics.dart';

part 'coordinator_event.dart';
part 'coordinator_state.dart';

class CoordinatorBloc extends Bloc<CoordinatorEvent, CoordinatorState> {
  final GetPendingApprovals _getPendingApprovals;
  final ApproveParticipation _approveParticipation;
  final GenerateCertificate _generateCertificate;
  final GetIssuedCertificates _getIssuedCertificates;
  final GenerateMonthlyReport _generateMonthlyReport;
  final GetCoordinatorStatistics _getCoordinatorStatistics;

  CoordinatorBloc({
    required GetPendingApprovals getPendingApprovals,
    required ApproveParticipation approveParticipation,
    required GenerateCertificate generateCertificate,
    required GetIssuedCertificates getIssuedCertificates,
    required GenerateMonthlyReport generateMonthlyReport,
    required GetCoordinatorStatistics getCoordinatorStatistics,
  })  : _getPendingApprovals = getPendingApprovals,
        _approveParticipation = approveParticipation,
        _generateCertificate = generateCertificate,
        _getIssuedCertificates = getIssuedCertificates,
        _generateMonthlyReport = generateMonthlyReport,
        _getCoordinatorStatistics = getCoordinatorStatistics,
        super(CoordinatorInitial()) {
    on<LoadPendingApprovals>(_onLoadPendingApprovals);
    on<ApproveVolunteerParticipation>(_onApproveVolunteerParticipation);
    on<GenerateVolunteerCertificate>(_onGenerateVolunteerCertificate);
    on<LoadIssuedCertificates>(_onLoadIssuedCertificates);
    on<LoadCoordinatorStatistics>(_onLoadCoordinatorStatistics);
    on<GenerateCoordinatorMonthlyReport>(_onGenerateCoordinatorMonthlyReport);
  }

  Future<void> _onLoadPendingApprovals(
    LoadPendingApprovals event,
    Emitter<CoordinatorState> emit,
  ) async {
    emit(CoordinatorLoading());
    
    final result = await _getPendingApprovals(event.coordinatorId);
    
    result.fold(
      (failure) => emit(CoordinatorError(failure.toString())),
      (applications) => emit(PendingApprovalsLoaded(applications)),
    );
  }

  Future<void> _onApproveVolunteerParticipation(
    ApproveVolunteerParticipation event,
    Emitter<CoordinatorState> emit,
  ) async {
    emit(CoordinatorLoading());
    
    final result = await _approveParticipation(
      ApproveParticipationParams(
        applicationId: event.applicationId,
        coordinatorId: event.coordinatorId,
        notes: event.notes,
      ),
    );
    
    result.fold(
      (failure) => emit(CoordinatorError(failure.toString())),
      (application) => emit(ParticipationApproved(application)),
    );
  }

  Future<void> _onGenerateVolunteerCertificate(
    GenerateVolunteerCertificate event,
    Emitter<CoordinatorState> emit,
  ) async {
    emit(CoordinatorLoading());
    
    final result = await _generateCertificate(
      GenerateCertificateParams(
        applicationId: event.applicationId,
        coordinatorId: event.coordinatorId,
        coordinatorName: event.coordinatorName,
      ),
    );
    
    result.fold(
      (failure) => emit(CoordinatorError(failure.toString())),
      (certificate) => emit(CertificateGenerated(certificate)),
    );
  }

  Future<void> _onLoadIssuedCertificates(
    LoadIssuedCertificates event,
    Emitter<CoordinatorState> emit,
  ) async {
    emit(CoordinatorLoading());
    
    final result = await _getIssuedCertificates(event.coordinatorId);
    
    result.fold(
      (failure) => emit(CoordinatorError(failure.toString())),
      (certificates) => emit(IssuedCertificatesLoaded(certificates)),
    );
  }

  Future<void> _onLoadCoordinatorStatistics(
    LoadCoordinatorStatistics event,
    Emitter<CoordinatorState> emit,
  ) async {
    emit(CoordinatorLoading());
    
    final result = await _getCoordinatorStatistics(event.coordinatorId);
    
    result.fold(
      (failure) => emit(CoordinatorError(failure.toString())),
      (statistics) => emit(CoordinatorStatisticsLoaded(statistics)),
    );
  }

  Future<void> _onGenerateCoordinatorMonthlyReport(
    GenerateCoordinatorMonthlyReport event,
    Emitter<CoordinatorState> emit,
  ) async {
    emit(CoordinatorLoading());
    
    final result = await _generateMonthlyReport(
      GenerateMonthlyReportParams(
        coordinatorId: event.coordinatorId,
        month: event.month,
      ),
    );
    
    result.fold(
      (failure) => emit(CoordinatorError(failure.toString())),
      (report) => emit(MonthlyReportGenerated(report)),
    );
  }
}
