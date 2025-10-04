import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/events_repository.dart';

/// Use case for clearing all interested events
class ClearAllInterestedEvents implements UseCase<void, NoParams> {
  final EventsRepository repository;

  ClearAllInterestedEvents(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearAllInterestedEvents();
  }
}