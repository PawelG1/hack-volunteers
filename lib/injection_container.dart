import 'package:get_it/get_it.dart';
import 'features/events/data/datasources/events_local_data_source.dart';
import 'features/events/data/datasources/events_local_data_source_isar.dart';
import 'features/events/data/datasources/events_remote_data_source.dart';
import 'features/events/data/repositories/events_repository_impl.dart';
import 'features/events/domain/repositories/events_repository.dart';
import 'features/events/domain/usecases/get_events.dart';
import 'features/events/domain/usecases/get_interested_events.dart';
import 'features/events/domain/usecases/apply_for_event.dart';
import 'features/events/domain/usecases/remove_interested_event.dart';
import 'features/events/domain/usecases/save_interested_event.dart';
import 'features/events/domain/usecases/save_skipped_event.dart';
import 'features/events/domain/usecases/clear_all_interested_events.dart';
import 'features/events/presentation/bloc/events_bloc.dart';
import 'features/local_storage/data/datasources/isar_data_source.dart';
import 'features/local_storage/data/datasources/isar_data_source_impl.dart';
import 'features/organizations/domain/repositories/organization_repository.dart';
import 'features/organizations/data/repositories/organization_repository_impl.dart';
import 'features/organizations/domain/usecases/create_event.dart';
import 'features/organizations/domain/usecases/update_event.dart';
import 'features/organizations/domain/usecases/delete_event.dart';
import 'features/organizations/domain/usecases/get_organization_events.dart';
import 'features/organizations/presentation/bloc/organization_bloc.dart';

final sl = GetIt.instance;

/// Setup dependency injection
/// Following Dependency Inversion Principle
Future<void> init() async {
  //! Features - Local Storage (Isar)
  // Initialize Isar database
  final isarDataSource = IsarDataSourceImpl();
  await isarDataSource.init();
  sl.registerLazySingleton<IsarDataSource>(() => isarDataSource);

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
  sl.registerLazySingleton(() => GetInterestedEvents(sl()));
  sl.registerLazySingleton(() => ApplyForEvent(sl()));
  sl.registerLazySingleton(() => RemoveInterestedEvent(sl()));
  sl.registerLazySingleton(() => SaveInterestedEvent(sl()));
  sl.registerLazySingleton(() => SaveSkippedEvent(sl()));
  sl.registerLazySingleton(() => ClearAllInterestedEvents(sl()));

  // Repository
  sl.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(),
  );

  // Using Isar implementation for persistent local storage
  sl.registerLazySingleton<EventsLocalDataSource>(
    () => EventsLocalDataSourceIsarImpl(sl()),
  );

  //! Features - Organizations
  // Bloc
  sl.registerFactory(
    () => OrganizationBloc(
      createEvent: sl(),
      updateEvent: sl(),
      deleteEvent: sl(),
      getOrganizationEvents: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateEvent(sl()));
  sl.registerLazySingleton(() => UpdateEvent(sl()));
  sl.registerLazySingleton(() => DeleteEvent(sl()));
  sl.registerLazySingleton(() => GetOrganizationEvents(sl()));

  // Repository
  sl.registerLazySingleton<OrganizationRepository>(
    () => OrganizationRepositoryImpl(localDataSource: sl()),
  );

  //! Core
  // Network info will be added later

  //! External
  // Isar initialized above
}
