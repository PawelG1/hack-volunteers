import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base interface for all use cases
/// [T] - return type
/// [Params] - parameters type
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Used when use case doesn't need parameters
class NoParams {
  const NoParams();
}
