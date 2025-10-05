import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../repositories/coordinator_repository.dart';

/// Use case to generate a certificate for an approved volunteer
/// Changes application status from 'approved' to 'completed'
/// Creates a new Certificate entity
class GenerateCertificate implements UseCase<Certificate, GenerateCertificateParams> {
  final CoordinatorRepository repository;

  GenerateCertificate(this.repository);

  @override
  Future<Either<Failure, Certificate>> call(GenerateCertificateParams params) async {
    return await repository.generateCertificate(
      applicationId: params.applicationId,
      coordinatorId: params.coordinatorId,
      coordinatorName: params.coordinatorName,
    );
  }
}

/// Parameters for generating a certificate
class GenerateCertificateParams extends Equatable {
  final String applicationId;
  final String coordinatorId;
  final String coordinatorName;

  const GenerateCertificateParams({
    required this.applicationId,
    required this.coordinatorId,
    required this.coordinatorName,
  });

  @override
  List<Object?> get props => [applicationId, coordinatorId, coordinatorName];
}
