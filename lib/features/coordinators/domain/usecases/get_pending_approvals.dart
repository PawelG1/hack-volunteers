import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../repositories/coordinator_repository.dart';

/// Use case to get applications pending coordinator approval
/// These are applications with status = 'attended' (organization marked attendance)
class GetPendingApprovals implements UseCase<List<VolunteerApplication>, String> {
  final CoordinatorRepository repository;

  GetPendingApprovals(this.repository);

  @override
  Future<Either<Failure, List<VolunteerApplication>>> call(String coordinatorId) async {
    return await repository.getPendingApprovals(coordinatorId);
  }
}
