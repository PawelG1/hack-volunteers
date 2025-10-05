import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../repositories/coordinator_repository.dart';

/// Use case to get all certificates issued by a coordinator
class GetIssuedCertificates implements UseCase<List<Certificate>, String> {
  final CoordinatorRepository repository;

  GetIssuedCertificates(this.repository);

  @override
  Future<Either<Failure, List<Certificate>>> call(String coordinatorId) async {
    return await repository.getIssuedCertificates(coordinatorId);
  }
}
