import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/coordinator_repository.dart';

/// Use case to get coordinator statistics
class GetCoordinatorStatistics implements UseCase<Map<String, dynamic>, String> {
  final CoordinatorRepository repository;

  GetCoordinatorStatistics(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String coordinatorId) async {
    return await repository.getCoordinatorStatistics(coordinatorId);
  }
}
