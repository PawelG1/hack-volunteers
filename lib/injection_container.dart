import 'package:get_it/get_it.dart';
import 'features/events/data/datasources/events_local_data_source.dart';
// import 'features/events/data/datasources/events_local_data_source_isar.dart'; // Ready when AGP compatibility fixed
import 'features/events/data/datasources/events_remote_data_source.dart';
import 'features/events/data/repositories/events_repository_impl.dart';
import 'features/events/domain/repositories/events_repository.dart';
import 'features/events/domain/usecases/get_events.dart';
import 'features/events/domain/usecases/save_interested_event.dart';
import 'features/events/domain/usecases/save_skipped_event.dart';
import 'features/events/presentation/bloc/events_bloc.dart';
// Isar imports - ready when AGP compatibility is fixed:
// import 'features/local_storage/data/datasources/isar_data_source.dart';
// import 'features/local_storage/data/datasources/isar_data_source_impl.dart';

final sl = GetIt.instance;

/// Setup dependency injection
/// Following Dependency Inversion Principle
Future<void> init() async {
  //! Features - Local Storage (Isar)
  // TODO: Initialize Isar when Android Gradle Plugin compatibility is resolved
  // Initialize Isar database
  // final isarDataSource = IsarDataSourceImpl();
  // await isarDataSource.init();
  // sl.registerLazySingleton<IsarDataSource>(() => isarDataSource);

  //! Features - Events
  // Bloc
  sl.registerFactory(
    () => EventsBloc(
      getEvents: sl(),
      saveInterestedEvent: sl(),
      saveSkippedEvent: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => SaveInterestedEvent(sl()));
  sl.registerLazySingleton(() => SaveSkippedEvent(sl()));

  // Repository
  sl.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(),
  );

  // TODO: Switch to Isar when Android Gradle Plugin compatibility is resolved
  // For now using in-memory implementation
  sl.registerLazySingleton<EventsLocalDataSource>(
    () => EventsLocalDataSourceImpl(),
  );

  // Isar implementation ready to use when build issues are resolved:
  // sl.registerLazySingleton<EventsLocalDataSource>(
  //   () => EventsLocalDataSourceIsarImpl(sl()),
  // );

  //! Core
  // Network info will be added later

  //! External
  // Isar initialized above
}
