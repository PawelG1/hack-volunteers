import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../repositories/volunteer_repository.dart';

/// Use case to get all certificates for a volunteer
class GetVolunteerCertificates implements UseCase<List<Certificate>, String> {
  final VolunteerRepository repository;

  GetVolunteerCertificates(this.repository);

  @override
  Future<Either<Failure, List<Certificate>>> call(String volunteerId) async {
    return await repository.getVolunteerCertificates(volunteerId);
  }
}
