import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/coordinator_repository.dart';

/// Use case to generate a monthly report for the coordinator's school
class GenerateMonthlyReport implements UseCase<Map<String, dynamic>, GenerateMonthlyReportParams> {
  final CoordinatorRepository repository;

  GenerateMonthlyReport(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(GenerateMonthlyReportParams params) async {
    return await repository.generateMonthlyReport(
      coordinatorId: params.coordinatorId,
      month: params.month,
    );
  }
}

/// Parameters for generating a monthly report
class GenerateMonthlyReportParams extends Equatable {
  final String coordinatorId;
  final DateTime month;

  const GenerateMonthlyReportParams({
    required this.coordinatorId,
    required this.month,
  });

  @override
  List<Object?> get props => [coordinatorId, month];
}
