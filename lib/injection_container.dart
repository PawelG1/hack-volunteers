import 'package:get_it/get_it.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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
import 'features/organizations/data/datasources/organization_local_data_source.dart';
import 'features/organizations/domain/usecases/create_event.dart';
import 'features/organizations/domain/usecases/update_event.dart';
import 'features/organizations/domain/usecases/delete_event.dart';
import 'features/organizations/domain/usecases/get_organization_events.dart';
import 'features/organizations/domain/usecases/get_applications_for_event.dart';
import 'features/organizations/domain/usecases/get_organization_applications.dart';
import 'features/organizations/domain/usecases/accept_application.dart';
import 'features/organizations/domain/usecases/reject_application.dart';
import 'features/organizations/domain/usecases/mark_attendance.dart';
import 'features/organizations/domain/usecases/rate_volunteer.dart';
import 'features/organizations/presentation/bloc/organization_bloc.dart';
import 'features/coordinators/domain/repositories/coordinator_repository.dart';
import 'features/coordinators/data/repositories/coordinator_repository_impl.dart';
import 'features/coordinators/data/datasources/coordinator_local_data_source.dart';
import 'features/coordinators/domain/usecases/get_pending_approvals.dart';
import 'features/coordinators/domain/usecases/approve_participation.dart';
import 'features/coordinators/domain/usecases/generate_certificate.dart';
import 'features/coordinators/domain/usecases/get_issued_certificates.dart';
import 'features/coordinators/domain/usecases/generate_monthly_report.dart';
import 'features/coordinators/domain/usecases/get_coordinator_statistics.dart';
import 'features/coordinators/presentation/bloc/coordinator_bloc.dart';
import 'features/volunteers/domain/repositories/volunteer_repository.dart';
import 'features/volunteers/data/repositories/volunteer_repository_impl.dart';
import 'features/volunteers/data/datasources/volunteer_local_data_source.dart';
import 'features/volunteers/domain/usecases/get_volunteer_certificates.dart';
import 'features/volunteers/presentation/bloc/volunteer_certificates_bloc.dart';
import 'core/utils/seed_data.dart';

final sl = GetIt.instance;

/// Setup dependency injection
/// Following Dependency Inversion Principle
Future<void> init() async {
  //! Features - Local Storage (Isar)
  // Initialize Isar database
  final isarDataSource = IsarDataSourceImpl();
  await isarDataSource.init();
  sl.registerLazySingleton<IsarDataSource>(() => isarDataSource);
  
  // Seed initial data (only runs once)
  await SeedData.seedCertificates(isarDataSource.isar);
  await SeedData.seedTestApplications(isarDataSource.isar);

  //! Features - Authentication
  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(isarDataSource.isar),
  );

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
    () => EventsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      organizationLocalDataSource: sl(),
    ),
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
      getApplicationsForEvent: sl(),
      getOrganizationApplications: sl(),
      acceptApplication: sl(),
      rejectApplication: sl(),
      markAttendance: sl(),
      rateVolunteer: sl(),
    ),
  );

  // Use cases - Events
  sl.registerLazySingleton(() => CreateEvent(sl()));
  sl.registerLazySingleton(() => UpdateEvent(sl()));
  sl.registerLazySingleton(() => DeleteEvent(sl()));
  sl.registerLazySingleton(() => GetOrganizationEvents(sl()));
  
  // Use cases - Applications
  sl.registerLazySingleton(() => GetApplicationsForEvent(sl()));
  sl.registerLazySingleton(() => GetOrganizationApplications(sl()));
  sl.registerLazySingleton(() => AcceptApplication(sl()));
  sl.registerLazySingleton(() => RejectApplication(sl()));
  sl.registerLazySingleton(() => MarkAttendance(sl()));
  sl.registerLazySingleton(() => RateVolunteer(sl()));

  // Repository
  sl.registerLazySingleton<OrganizationRepository>(
    () => OrganizationRepositoryImpl(
      eventsLocalDataSource: sl(),
      organizationLocalDataSource: sl(),
    ),
  );
  
  // Data sources
  sl.registerLazySingleton<OrganizationLocalDataSource>(
    () => OrganizationLocalDataSourceImpl(isar: isarDataSource.isar),
  );

  //! Features - Coordinators
  // Bloc
  sl.registerFactory(
    () => CoordinatorBloc(
      getPendingApprovals: sl(),
      approveParticipation: sl(),
      generateCertificate: sl(),
      getIssuedCertificates: sl(),
      generateMonthlyReport: sl(),
      getCoordinatorStatistics: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPendingApprovals(sl()));
  sl.registerLazySingleton(() => ApproveParticipation(sl()));
  sl.registerLazySingleton(() => GenerateCertificate(sl()));
  sl.registerLazySingleton(() => GetIssuedCertificates(sl()));
  sl.registerLazySingleton(() => GenerateMonthlyReport(sl()));
  sl.registerLazySingleton(() => GetCoordinatorStatistics(sl()));

  // Repository
  sl.registerLazySingleton<CoordinatorRepository>(
    () => CoordinatorRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  
  // Data sources
  sl.registerLazySingleton<CoordinatorLocalDataSource>(
    () => CoordinatorLocalDataSourceImpl(isar: isarDataSource.isar),
  );

  //! Features - Volunteers
  // Bloc
  sl.registerFactory(
    () => VolunteerCertificatesBloc(
      getVolunteerCertificates: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetVolunteerCertificates(sl()));

  // Repository
  sl.registerLazySingleton<VolunteerRepository>(
    () => VolunteerRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<VolunteerLocalDataSource>(
    () => VolunteerLocalDataSourceImpl(isar: isarDataSource.isar),
  );

  //! Core
  // Network info will be added later

  //! External
  // Isar initialized above
}
