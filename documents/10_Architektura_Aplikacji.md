# 10. Architektura Aplikacji

**Dokument:** 10_Architektura_Aplikacji.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 10.1. Przegląd architektury

### 10.1.1. Wzorzec architektoniczny

Aplikacja SmokPomaga wykorzystuje **Clean Architecture** w połączeniu z **BLoC Pattern** dla zarządzania stanem.

```
┌────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Pages   │  │  Widgets │  │  BLoC    │  │  Router  │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└────────────────────────────────────────────────────────────┘
                            ↕
┌────────────────────────────────────────────────────────────┐
│                     BUSINESS LAYER                          │
│  ┌──────────────────┐  ┌──────────────────┐               │
│  │   Use Cases      │  │    Entities      │               │
│  └──────────────────┘  └──────────────────┘               │
└────────────────────────────────────────────────────────────┘
                            ↕
┌────────────────────────────────────────────────────────────┐
│                     DATA LAYER                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Repositories │  │ Data Sources │  │    Models    │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└────────────────────────────────────────────────────────────┘
```

### 10.1.2. Zasady Clean Architecture

1. **Separation of Concerns** - Każda warstwa ma osobną odpowiedzialność
2. **Dependency Rule** - Zależności skierowane do środka (wewnątrz nie zna zewnątrz)
3. **Testability** - Każda warstwa może być testowana niezależnie
4. **Independence** - Business logic niezależna od UI i frameworków

## 10.2. Warstwy aplikacji

### 10.2.1. Presentation Layer (lib/features/*/presentation/)

**Odpowiedzialność:**
- Wyświetlanie UI użytkownikowi
- Obsługa interakcji użytkownika
- Przekazywanie zdarzeń do BLoC
- Reagowanie na zmiany stanu z BLoC

**Komponenty:**

```
lib/features/<feature>/presentation/
├── pages/              # Ekrany (Scaffold)
│   ├── volunteer_dashboard.dart
│   ├── event_details_page.dart
│   └── ...
├── widgets/            # Komponenty UI wielokrotnego użytku
│   ├── event_card.dart
│   ├── certificate_card.dart
│   └── ...
└── bloc/              # State management
    ├── <feature>_bloc.dart
    ├── <feature>_event.dart
    └── <feature>_state.dart
```

**Przykład - Event Details Page:**

```dart
class EventDetailsPage extends StatelessWidget {
  final String eventId;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EventsBloc>()
        ..add(LoadEventDetails(eventId)),
      child: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return CircularProgressIndicator();
          }
          if (state is EventDetailsLoaded) {
            return _buildEventDetails(state.event);
          }
          return ErrorWidget();
        },
      ),
    );
  }
}
```

### 10.2.2. Business Layer (lib/features/*/domain/)

**Odpowiedzialność:**
- Logika biznesowa aplikacji
- Definicja encji (modeli domenowych)
- Abstrakcje repozytoriów
- Use cases (przypadki użycia)

**Komponenty:**

```
lib/features/<feature>/domain/
├── entities/           # Modele domenowe (czyste klasy)
│   ├── event.dart
│   ├── certificate.dart
│   └── ...
├── repositories/       # Abstrakcje (interfejsy)
│   └── events_repository.dart
└── usecases/          # Logika biznesowa
    ├── get_events.dart
    ├── apply_to_event.dart
    └── ...
```

**Przykład - Entity:**

```dart
class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final int volunteersNeeded;
  final String location;
  
  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.volunteersNeeded,
    required this.location,
  });
  
  @override
  List<Object> get props => [id, title, description, date, volunteersNeeded, location];
}
```

**Przykład - Use Case:**

```dart
class GetEvents {
  final EventsRepository repository;
  
  GetEvents(this.repository);
  
  Future<Either<Failure, List<Event>>> call() async {
    return await repository.getEvents();
  }
}
```

**Przykład - Repository Interface:**

```dart
abstract class EventsRepository {
  Future<Either<Failure, List<Event>>> getEvents();
  Future<Either<Failure, Event>> getEventById(String id);
  Future<Either<Failure, void>> applyToEvent(String eventId, String userId);
}
```

### 10.2.3. Data Layer (lib/features/*/data/)

**Odpowiedzialność:**
- Implementacja repozytoriów
- Źródła danych (local/remote)
- Mapowanie między modelami a encjami
- Obsługa cache i persistence

**Komponenty:**

```
lib/features/<feature>/data/
├── models/            # Data Transfer Objects (DTO)
│   └── event_model.dart
├── datasources/       # Źródła danych
│   ├── events_local_datasource.dart
│   └── events_remote_datasource.dart
└── repositories/      # Implementacje
    └── events_repository_impl.dart
```

**Przykład - Model:**

```dart
@collection
class EventModel extends Event {
  Id? isarId;
  
  EventModel({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required int volunteersNeeded,
    required String location,
  }) : super(
    id: id,
    title: title,
    description: description,
    date: date,
    volunteersNeeded: volunteersNeeded,
    location: location,
  );
  
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      volunteersNeeded: event.volunteersNeeded,
      location: event.location,
    );
  }
}
```

**Przykład - Data Source:**

```dart
abstract class EventsLocalDataSource {
  Future<List<EventModel>> getEvents();
  Future<EventModel> getEventById(String id);
  Future<void> cacheEvents(List<EventModel> events);
}

class EventsLocalDataSourceImpl implements EventsLocalDataSource {
  final Isar isar;
  
  EventsLocalDataSourceImpl(this.isar);
  
  @override
  Future<List<EventModel>> getEvents() async {
    return await isar.eventModels.where().findAll();
  }
  
  @override
  Future<EventModel> getEventById(String id) async {
    return await isar.eventModels.filter().idEqualTo(id).findFirst() 
        ?? (throw CacheException());
  }
  
  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    await isar.writeTxn(() async {
      await isar.eventModels.putAll(events);
    });
  }
}
```

**Przykład - Repository Implementation:**

```dart
class EventsRepositoryImpl implements EventsRepository {
  final EventsLocalDataSource localDataSource;
  final EventsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  EventsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEvents = await remoteDataSource.getEvents();
        await localDataSource.cacheEvents(remoteEvents);
        return Right(remoteEvents);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localEvents = await localDataSource.getEvents();
        return Right(localEvents);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

## 10.3. State Management - BLoC Pattern

### 10.3.1. Struktura BLoC

```dart
// Event (zdarzenie z UI)
abstract class EventsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvents extends EventsEvent {}
class LoadEventDetails extends EventsEvent {
  final String eventId;
  LoadEventDetails(this.eventId);
  @override
  List<Object> get props => [eventId];
}

// State (stan aplikacji)
abstract class EventsState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}
class EventsLoading extends EventsState {}
class EventsLoaded extends EventsState {
  final List<Event> events;
  EventsLoaded(this.events);
  @override
  List<Object> get props => [events];
}
class EventsError extends EventsState {
  final String message;
  EventsError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC (business logic component)
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final GetEventDetails getEventDetails;
  
  EventsBloc({
    required this.getEvents,
    required this.getEventDetails,
  }) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadEventDetails>(_onLoadEventDetails);
  }
  
  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());
    final result = await getEvents();
    result.fold(
      (failure) => emit(EventsError(_mapFailureToMessage(failure))),
      (events) => emit(EventsLoaded(events)),
    );
  }
  
  Future<void> _onLoadEventDetails(
    LoadEventDetails event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());
    final result = await getEventDetails(event.eventId);
    result.fold(
      (failure) => emit(EventsError(_mapFailureToMessage(failure))),
      (eventDetails) => emit(EventDetailsLoaded(eventDetails)),
    );
  }
}
```

### 10.3.2. Przepływ danych w BLoC

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User taps button                                          │
│    ↓                                                         │
│ 2. Widget dispatches Event to BLoC                          │
│    context.read<EventsBloc>().add(LoadEvents())             │
│    ↓                                                         │
│ 3. BLoC receives Event                                       │
│    on<LoadEvents>(_onLoadEvents)                            │
│    ↓                                                         │
│ 4. BLoC emits Loading State                                 │
│    emit(EventsLoading())                                    │
│    ↓                                                         │
│ 5. BLoC calls Use Case                                      │
│    await getEvents()                                        │
│    ↓                                                         │
│ 6. Use Case calls Repository                                │
│    repository.getEvents()                                   │
│    ↓                                                         │
│ 7. Repository fetches data from Data Source                 │
│    localDataSource.getEvents() or remoteDataSource.getEvents() │
│    ↓                                                         │
│ 8. Data returned to Repository                              │
│    List<EventModel>                                         │
│    ↓                                                         │
│ 9. Repository maps to Entities and returns                  │
│    Right(List<Event>)                                       │
│    ↓                                                         │
│ 10. Use Case returns to BLoC                                │
│     Either<Failure, List<Event>>                            │
│     ↓                                                        │
│ 11. BLoC emits new State                                    │
│     emit(EventsLoaded(events))                              │
│     ↓                                                        │
│ 12. Widget rebuilds with new State                          │
│     BlocBuilder receives EventsLoaded                       │
│     ↓                                                        │
│ 13. UI updates                                              │
│     ListView displays events                                │
└─────────────────────────────────────────────────────────────┘
```

## 10.4. Core Layer (lib/core/)

### 10.4.1. Struktura core

```
lib/core/
├── error/              # Obsługa błędów
│   ├── failures.dart
│   └── exceptions.dart
├── usecases/          # Bazowe klasy use cases
│   └── usecase.dart
├── utils/             # Narzędzia pomocnicze
│   ├── input_converter.dart
│   └── date_formatter.dart
├── network/           # Networking
│   └── network_info.dart
├── theme/             # Motyw aplikacji
│   ├── app_theme.dart
│   └── app_colors.dart
└── widgets/           # Współdzielone widgety
    ├── custom_button.dart
    └── mlody_krakow_footer.dart
```

### 10.4.2. Error Handling

**Failures (warstwa domenowa):**

```dart
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
class NetworkFailure extends Failure {}
class ValidationFailure extends Failure {
  final String message;
  ValidationFailure(this.message);
  @override
  List<Object> get props => [message];
}
```

**Exceptions (warstwa danych):**

```dart
class ServerException implements Exception {}
class CacheException implements Exception {}
class NetworkException implements Exception {}
```

### 10.4.3. Base UseCase

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
```

## 10.5. Dependency Injection (DI)

### 10.5.1. Service Locator - GetIt

```dart
final getIt = GetIt.instance;

Future<void> init() async {
  // BLoCs
  getIt.registerFactory(
    () => EventsBloc(
      getEvents: getIt(),
      getEventDetails: getIt(),
      applyToEvent: getIt(),
    ),
  );
  
  getIt.registerFactory(
    () => AuthBloc(
      login: getIt(),
      register: getIt(),
      logout: getIt(),
    ),
  );
  
  // Use Cases
  getIt.registerLazySingleton(() => GetEvents(getIt()));
  getIt.registerLazySingleton(() => GetEventDetails(getIt()));
  getIt.registerLazySingleton(() => ApplyToEvent(getIt()));
  getIt.registerLazySingleton(() => Login(getIt()));
  getIt.registerLazySingleton(() => Register(getIt()));
  
  // Repositories
  getIt.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  
  // Data Sources
  getIt.registerLazySingleton<EventsLocalDataSource>(
    () => EventsLocalDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(),
  );
  
  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );
  
  // External
  final isar = await Isar.open([
    EventModelSchema,
    CertificateModelSchema,
    ApplicationModelSchema,
    UserModelSchema,
  ]);
  getIt.registerLazySingleton(() => isar);
}
```

### 10.5.2. Typy rejestracji

| Typ | Opis | Kiedy używać |
|-----|------|-------------|
| `registerFactory` | Nowa instancja przy każdym wywołaniu | BLoCs (żywotność związana z widgetem) |
| `registerLazySingleton` | Jedna instancja (lazy loading) | Repositories, Use Cases, Services |
| `registerSingleton` | Jedna instancja (eager loading) | Database, SharedPreferences |

## 10.6. Routing - GoRouter

### 10.6.1. Struktura routingu

```dart
final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/volunteer-dashboard',
      builder: (context, state) => const VolunteerDashboard(),
      routes: [
        GoRoute(
          path: 'event/:id',
          builder: (context, state) => EventDetailsPage(
            eventId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'my-certificates',
          builder: (context, state) => const MyCertificatesPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/organization-dashboard',
      builder: (context, state) => const OrganizationDashboard(),
    ),
    GoRoute(
      path: '/coordinator-dashboard',
      builder: (context, state) => const CoordinatorDashboard(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const EventsMapPage(),
    ),
  ],
);
```

### 10.6.2. Nawigacja

```dart
// Push
context.go('/volunteer-dashboard');

// Push z parametrami
context.go('/volunteer-dashboard/event/${event.id}');

// Pop
context.pop();

// Replace
context.replace('/login');
```

## 10.7. Database - Isar

### 10.7.1. Architektura bazy danych

```
┌────────────────────────────────────────┐
│            Isar Instance               │
│  ┌──────────────────────────────────┐  │
│  │  Collection: EventModels         │  │
│  │  ├─ id (String, indexed)         │  │
│  │  ├─ title (String)               │  │
│  │  ├─ date (DateTime, indexed)     │  │
│  │  └─ ...                          │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  Collection: CertificateModels   │  │
│  │  ├─ id (String, indexed)         │  │
│  │  ├─ userId (String, indexed)     │  │
│  │  └─ ...                          │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  Collection: ApplicationModels   │  │
│  │  ├─ eventId (String, indexed)    │  │
│  │  ├─ userId (String, indexed)     │  │
│  │  └─ ...                          │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  Collection: UserModels          │  │
│  │  ├─ id (String, indexed)         │  │
│  │  ├─ email (String, indexed)      │  │
│  │  └─ ...                          │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

### 10.7.2. Query patterns

```dart
// Pobierz wszystkie wydarzenia
final events = await isar.eventModels.where().findAll();

// Znajdź wydarzenie po ID
final event = await isar.eventModels.filter()
  .idEqualTo(eventId)
  .findFirst();

// Filtrowanie z sortowaniem
final upcomingEvents = await isar.eventModels.filter()
  .dateGreaterThan(DateTime.now())
  .sortByDate()
  .findAll();

// Transakcje zapisu
await isar.writeTxn(() async {
  await isar.eventModels.put(newEvent);
});

// Transakcje zapisu wielu obiektów
await isar.writeTxn(() async {
  await isar.eventModels.putAll(events);
});
```

## 10.8. Wzorce projektowe wykorzystane

### 10.8.1. Repository Pattern

- **Cel:** Abstrakcja dostępu do danych
- **Implementacja:** Interface w domain, implementacja w data
- **Korzyści:** Łatwa zmiana źródła danych, testowanie z mockami

### 10.8.2. Dependency Injection

- **Cel:** Odwrócenie zależności
- **Implementacja:** GetIt (Service Locator)
- **Korzyści:** Luźne powiązania, testowanie, Single Responsibility

### 10.8.3. BLoC Pattern

- **Cel:** Separacja logiki biznesowej od UI
- **Implementacja:** flutter_bloc
- **Korzyści:** Reaktywny UI, testowanie, jednokierunkowy przepływ danych

### 10.8.4. Factory Pattern

- **Cel:** Tworzenie obiektów
- **Implementacja:** Metody `.fromEntity()`, `.toEntity()`
- **Korzyści:** Enkapsulacja logiki tworzenia

### 10.8.5. Strategy Pattern

- **Cel:** Wymienne algorytmy
- **Implementacja:** NetworkInfo (różne strategie sprawdzania sieci)
- **Korzyści:** Elastyczność, Open/Closed Principle

## 10.9. Konwencje nazewnictwa

### 10.9.1. Pliki

- **Pages:** `<feature>_page.dart` (np. `event_details_page.dart`)
- **Widgets:** `<name>_widget.dart` lub `<name>.dart` (np. `event_card.dart`)
- **BLoCs:** `<feature>_bloc.dart` (np. `events_bloc.dart`)
- **Models:** `<entity>_model.dart` (np. `event_model.dart`)
- **Repositories:** `<feature>_repository.dart` (np. `events_repository.dart`)

### 10.9.2. Klasy

- **Pages:** PascalCase + `Page` (np. `EventDetailsPage`)
- **Widgets:** PascalCase (np. `EventCard`)
- **BLoCs:** PascalCase + `Bloc` (np. `EventsBloc`)
- **Events:** PascalCase + czasownik (np. `LoadEvents`, `ApplyToEvent`)
- **States:** PascalCase + przymiotnik (np. `EventsLoaded`, `EventsError`)

### 10.9.3. Zmienne

- **camelCase:** `eventId`, `userRole`, `certificateList`
- **Private:** `_privateVariable`
- **Constants:** `kConstantName` lub `CONSTANT_NAME`

## 10.10. Testowanie

### 10.10.1. Struktura testów

```
test/
├── features/
│   └── events/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   └── usecases/
│       └── presentation/
│           └── bloc/
└── core/
    └── utils/
```

### 10.10.2. Typy testów

- **Unit Tests:** Use cases, repositories, utils
- **Widget Tests:** Pojedyncze widgety
- **BLoC Tests:** State management (bloc_test)
- **Integration Tests:** Pełne flow aplikacji

### 10.10.3. Przykład unit testu

```dart
void main() {
  late GetEvents usecase;
  late MockEventsRepository mockRepository;

  setUp(() {
    mockRepository = MockEventsRepository();
    usecase = GetEvents(mockRepository);
  });

  test('should get list of events from repository', () async {
    // arrange
    when(() => mockRepository.getEvents())
        .thenAnswer((_) async => Right(tEventsList));
    
    // act
    final result = await usecase(NoParams());
    
    // assert
    expect(result, Right(tEventsList));
    verify(() => mockRepository.getEvents());
    verifyNoMoreInteractions(mockRepository);
  });
}
```

## 10.11. Rozszerzalność

### 10.11.1. Dodawanie nowego feature

1. Utworzyć folder `lib/features/<new_feature>/`
2. Utworzyć strukturę: `data/`, `domain/`, `presentation/`
3. Zaimplementować entities, repositories, use cases
4. Stworzyć BLoC i UI
5. Zarejestrować w DI (injection_container.dart)
6. Dodać routing (main.dart)

### 10.11.2. Dodawanie nowego data source

1. Zdefiniować interface w `data/datasources/`
2. Zaimplementować klasę (np. `FirebaseDataSource`)
3. Zaktualizować repository implementation
4. Zarejestrować w DI

### 10.11.3. Migracja bazy danych

```dart
// Zmiana w modelu
@collection
class EventModel {
  Id? isarId;
  String? id;
  String? title;
  String? newField; // NOWE POLE
}

// Isar automatycznie obsługuje migracje prostych zmian
// Dla złożonych: zmienić wersję i obsłużyć manualnie
```

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
