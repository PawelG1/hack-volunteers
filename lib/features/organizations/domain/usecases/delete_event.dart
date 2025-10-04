import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/organization_repository.dart';

class DeleteEvent implements UseCase<void, DeleteEventParams> {
  final OrganizationRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteEventParams params) async {
    return await repository.deleteEvent(params.eventId);
  }
}

class DeleteEventParams {
  final String eventId;

  DeleteEventParams({required this.eventId});
}