# 15. Dokumentacja Kodu Źródłowego

**Dokument:** 15_Kody_Zrodlowe.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 15.1. Przegląd

Niniejszy dokument zawiera szczegółową dokumentację struktury kodu źródłowego aplikacji SmokPomaga, konwencji programistycznych oraz instrukcji dla programistów.

---

## 15.2. Struktura projektu

### 15.2.1. Główne katalogi

```
hack_volunteers/
├── lib/                    # Kod źródłowy Dart/Flutter
│   ├── main.dart          # Punkt wejścia aplikacji
│   ├── injection_container.dart  # Dependency Injection
│   ├── core/              # Współdzielone komponenty
│   └── features/          # Moduły funkcjonalne
├── android/               # Kod natywny Android
├── ios/                   # Kod natywny iOS (nie rozwijany)
├── test/                  # Testy jednostkowe i widgetów
├── assets/                # Zasoby (obrazy, fonty)
├── documents/             # Dokumentacja techniczna
└── scripts/               # Skrypty pomocnicze
```

### 15.2.2. Struktura lib/

```
lib/
├── main.dart                           # Entry point
├── injection_container.dart            # GetIt DI setup
│
├── core/                               # Warstwa współdzielona
│   ├── error/                          # Obsługa błędów
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                        # Networking
│   │   └── network_info.dart
│   ├── theme/                          # Motyw aplikacji
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   ├── usecases/                       # Bazowa klasa UseCase
│   │   └── usecase.dart
│   ├── utils/                          # Narzędzia pomocnicze
│   │   ├── date_formatter.dart
│   │   └── validators.dart
│   └── widgets/                        # Współdzielone widgety
│       ├── custom_button.dart
│       └── mlody_krakow_footer.dart
│
└── features/                           # Moduły funkcjonalne
    ├── auth/                           # Autoryzacja
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_local_datasource.dart
    │   │   │   └── auth_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── login.dart
    │   │       ├── register.dart
    │   │       └── logout.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── register_page.dart
    │       └── widgets/
    │           └── login_form.dart
    │
    ├── events/                         # Wydarzenia
    ├── volunteers/                     # Panel wolontariusza
    ├── organizations/                  # Panel organizacji
    ├── coordinators/                   # Panel koordynatora
    ├── certificates/                   # Certyfikaty
    └── map/                            # Mapa wydarzeń
```

---

## 15.3. Konwencje nazewnictwa

### 15.3.1. Pliki

| Typ | Konwencja | Przykład |
|-----|-----------|----------|
| Pages | `<name>_page.dart` | `login_page.dart` |
| Widgets | `<name>_widget.dart` lub `<name>.dart` | `event_card.dart` |
| BLoCs | `<feature>_bloc.dart` | `auth_bloc.dart` |
| Events | `<feature>_event.dart` | `auth_event.dart` |
| States | `<feature>_state.dart` | `auth_state.dart` |
| Models | `<entity>_model.dart` | `user_model.dart` |
| Entities | `<entity>.dart` | `user.dart` |
| Repositories | `<feature>_repository.dart` | `auth_repository.dart` |
| Use Cases | `<action>.dart` | `login.dart`, `get_events.dart` |
| Data Sources | `<feature>_<type>_datasource.dart` | `auth_local_datasource.dart` |

### 15.3.2. Klasy

| Typ | Konwencja | Przykład |
|-----|-----------|----------|
| Pages | PascalCase + `Page` | `LoginPage` |
| Widgets | PascalCase | `EventCard` |
| BLoCs | PascalCase + `Bloc` | `AuthBloc` |
| Events | PascalCase + czasownik | `LoginButtonPressed` |
| States | PascalCase + przymiotnik | `AuthLoading`, `EventsLoaded` |
| Models | PascalCase + `Model` | `UserModel` |
| Entities | PascalCase | `User`, `Event` |
| Use Cases | PascalCase | `Login`, `GetEvents` |

### 15.3.3. Zmienne i funkcje

```dart
// Zmienne - camelCase
String userName = 'Jan Kowalski';
int eventCount = 10;
bool isLoading = false;

// Prywatne zmienne - _camelCase
String _privateToken = 'abc123';

// Stałe - camelCase lub SCREAMING_SNAKE_CASE
const int maxEvents = 100;
const String API_BASE_URL = 'https://api.example.com';

// Funkcje - camelCase
void fetchEvents() {}
Future<void> saveToDatabase() async {}

// Prywatne funkcje - _camelCase
void _initializeDatabase() {}
```

### 15.3.4. Komentarze

```dart
/// Dokumentacja klasy (widoczna w IntelliSense).
/// 
/// Używa składni Markdown.
/// 
/// Przykład:
/// ```dart
/// final user = User(name: 'Jan');
/// ```
class User {
  /// Imię i nazwisko użytkownika.
  final String name;
  
  /// Adres email.
  /// 
  /// Musi być w formacie: user@domain.com
  final String email;
  
  User({required this.name, required this.email});
}

// Komentarz jednolinijkowy dla implementacji
// TODO: Dodać walidację emaila
// FIXME: Naprawić bug z duplikatami
// NOTE: Ta funkcja jest deprecated
```

---

## 15.4. Architektura kodu (Clean Architecture)

### 15.4.1. Feature structure template

Każdy feature ma strukturę:

```
features/<feature_name>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

### 15.4.2. Przykład: Feature "Events"

**1. Entity (domain/entities/event.dart):**

```dart
import 'package:equatable/equatable.dart';

/// Encja reprezentująca wydarzenie wolontariackie.
class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double latitude;
  final double longitude;
  final int volunteersNeeded;
  final int volunteersApplied;
  final String category;
  final String? imageUrl;
  
  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.volunteersNeeded,
    required this.volunteersApplied,
    required this.category,
    this.imageUrl,
  });
  
  @override
  List<Object?> get props => [
    id, title, description, date, location, 
    latitude, longitude, volunteersNeeded, 
    volunteersApplied, category, imageUrl,
  ];
}
```

**2. Repository Interface (domain/repositories/events_repository.dart):**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event.dart';

/// Abstrakcja repozytorium wydarzeń.
abstract class EventsRepository {
  /// Pobiera wszystkie wydarzenia.
  /// 
  /// Returns:
  ///   Right(List<Event>) - lista wydarzeń
  ///   Left(Failure) - błąd (ServerFailure, CacheFailure, etc.)
  Future<Either<Failure, List<Event>>> getEvents();
  
  /// Pobiera wydarzenie po ID.
  Future<Either<Failure, Event>> getEventById(String id);
  
  /// Aplikuje użytkownika na wydarzenie.
  Future<Either<Failure, void>> applyToEvent(String eventId, String userId);
}
```

**3. Use Case (domain/usecases/get_events.dart):**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/events_repository.dart';

/// Use case do pobierania wszystkich wydarzeń.
class GetEvents implements UseCase<List<Event>, NoParams> {
  final EventsRepository repository;
  
  GetEvents(this.repository);
  
  @override
  Future<Either<Failure, List<Event>>> call(NoParams params) async {
    return await repository.getEvents();
  }
}
```

**4. Model (data/models/event_model.dart):**

```dart
import 'package:isar/isar.dart';
import '../../domain/entities/event.dart';

part 'event_model.g.dart'; // Generated by Isar

@collection
class EventModel extends Event {
  Id? isarId; // Isar auto-increment ID
  
  EventModel({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required double latitude,
    required double longitude,
    required int volunteersNeeded,
    required int volunteersApplied,
    required String category,
    String? imageUrl,
  }) : super(
    id: id,
    title: title,
    description: description,
    date: date,
    location: location,
    latitude: latitude,
    longitude: longitude,
    volunteersNeeded: volunteersNeeded,
    volunteersApplied: volunteersApplied,
    category: category,
    imageUrl: imageUrl,
  );
  
  /// Factory do konwersji z Entity.
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      latitude: event.latitude,
      longitude: event.longitude,
      volunteersNeeded: event.volunteersNeeded,
      volunteersApplied: event.volunteersApplied,
      category: event.category,
      imageUrl: event.imageUrl,
    );
  }
}
```

**5. Data Source (data/datasources/events_local_datasource.dart):**

```dart
import 'package:isar/isar.dart';
import '../models/event_model.dart';

/// Abstrakcja lokalnego źródła danych wydarzeń.
abstract class EventsLocalDataSource {
  Future<List<EventModel>> getEvents();
  Future<EventModel> getEventById(String id);
  Future<void> cacheEvents(List<EventModel> events);
}

/// Implementacja lokalnego źródła danych (Isar).
class EventsLocalDataSourceImpl implements EventsLocalDataSource {
  final Isar isar;
  
  EventsLocalDataSourceImpl(this.isar);
  
  @override
  Future<List<EventModel>> getEvents() async {
    return await isar.eventModels.where().findAll();
  }
  
  @override
  Future<EventModel> getEventById(String id) async {
    final event = await isar.eventModels.filter().idEqualTo(id).findFirst();
    if (event == null) {
      throw CacheException();
    }
    return event;
  }
  
  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    await isar.writeTxn(() async {
      await isar.eventModels.putAll(events);
    });
  }
}
```

**6. Repository Implementation (data/repositories/events_repository_impl.dart):**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_local_datasource.dart';

/// Implementacja repozytorium wydarzeń.
class EventsRepositoryImpl implements EventsRepository {
  final EventsLocalDataSource localDataSource;
  
  EventsRepositoryImpl({required this.localDataSource});
  
  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    try {
      final events = await localDataSource.getEvents();
      return Right(events);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, Event>> getEventById(String id) async {
    try {
      final event = await localDataSource.getEventById(id);
      return Right(event);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> applyToEvent(String eventId, String userId) async {
    // Implementacja aplikowania na wydarzenie
    try {
      // Logika biznesowa...
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

**7. BLoC (presentation/bloc/events_bloc.dart):**

```dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/get_events.dart';

part 'events_event.dart';
part 'events_state.dart';

/// BLoC zarządzający stanem wydarzeń.
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  
  EventsBloc({required this.getEvents}) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
  }
  
  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());
    
    final result = await getEvents(NoParams());
    
    result.fold(
      (failure) => emit(EventsError(_mapFailureToMessage(failure))),
      (events) => emit(EventsLoaded(events)),
    );
  }
  
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Nie znaleziono wydarzeń w pamięci lokalnej.';
      default:
        return 'Nieoczekiwany błąd.';
    }
  }
}
```

**8. Page (presentation/pages/events_list_page.dart):**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/events_bloc.dart';
import '../widgets/event_card.dart';

/// Strona wyświetlająca listę wydarzeń.
class EventsListPage extends StatelessWidget {
  const EventsListPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventsBloc>()..add(LoadEvents()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Wydarzenia')),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is EventsLoaded) {
              return ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  return EventCard(event: state.events[index]);
                },
              );
            }
            
            if (state is EventsError) {
              return Center(child: Text(state.message));
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

---

## 15.5. Dependency Injection (GetIt)

### 15.5.1. Struktura injection_container.dart

```dart
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
// Imports...

final getIt = GetIt.instance;

Future<void> init() async {
  // ===== Features: Auth =====
  
  // BLoCs
  getIt.registerFactory(() => AuthBloc(
    login: getIt(),
    register: getIt(),
    logout: getIt(),
  ));
  
  // Use Cases
  getIt.registerLazySingleton(() => Login(getIt()));
  getIt.registerLazySingleton(() => Register(getIt()));
  getIt.registerLazySingleton(() => Logout(getIt()));
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  
  // Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  
  // ===== Core =====
  
  // External
  final isar = await Isar.open([
    EventModelSchema,
    CertificateModelSchema,
    ApplicationModelSchema,
    UserModelSchema,
  ]);
  getIt.registerLazySingleton(() => isar);
  
  // ... więcej features
}
```

### 15.5.2. Typy rejestracji

```dart
// Factory - nowa instancja przy każdym wywołaniu (dla BLoCs)
getIt.registerFactory(() => EventsBloc(getEvents: getIt()));

// Lazy Singleton - jedna instancja (lazy loading)
getIt.registerLazySingleton(() => GetEvents(getIt()));

// Singleton - jedna instancja (eager loading)
getIt.registerSingleton(MyService());
```

---

## 15.6. Testing

### 15.6.1. Unit Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockEventsRepository extends Mock implements EventsRepository {}

void main() {
  late GetEvents usecase;
  late MockEventsRepository mockRepository;
  
  setUp(() {
    mockRepository = MockEventsRepository();
    usecase = GetEvents(mockRepository);
  });
  
  final tEventsList = [
    Event(id: '1', title: 'Test Event', /* ... */),
  ];
  
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
  
  test('should return CacheFailure when no local data', () async {
    // arrange
    when(() => mockRepository.getEvents())
        .thenAnswer((_) async => Left(CacheFailure()));
    
    // act
    final result = await usecase(NoParams());
    
    // assert
    expect(result, Left(CacheFailure()));
  });
}
```

### 15.6.2. Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockEventsBloc extends Mock implements EventsBloc {}

void main() {
  late MockEventsBloc mockBloc;
  
  setUp(() {
    mockBloc = MockEventsBloc();
  });
  
  testWidgets('should show loading indicator when state is EventsLoading', 
    (tester) async {
    // arrange
    when(() => mockBloc.state).thenReturn(EventsLoading());
    when(() => mockBloc.stream).thenAnswer((_) => Stream.empty());
    
    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<EventsBloc>(
          create: (_) => mockBloc,
          child: EventsListPage(),
        ),
      ),
    );
    
    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

---

## 15.7. Code Generation

### 15.7.1. Isar Schema Generation

```bash
# Generuj schematy Isar
flutter pub run build_runner build --delete-conflicting-outputs

# W trybie watch (automatyczne regenerowanie)
flutter pub run build_runner watch
```

### 15.7.2. Pliki generowane

```
lib/features/events/data/models/
├── event_model.dart        # Ręcznie napisany
└── event_model.g.dart      # Wygenerowany przez Isar
```

---

## 15.8. Linting i formatowanie

### 15.8.1. analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - avoid_print
    - prefer_single_quotes
    - always_use_package_imports
```

### 15.8.2. Formatowanie kodu

```bash
# Formatuj wszystkie pliki
dart format lib/

# Formatuj konkretny plik
dart format lib/main.dart

# Sprawdź bez zmian
dart format --output=none lib/
```

### 15.8.3. Analiza kodu

```bash
# Analizuj kod
flutter analyze

# Fix automatycznych problemów
dart fix --apply
```

---

## 15.9. Git Workflow

### 15.9.1. Konwencja commitów

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Typy:**
- `feat`: Nowa funkcjonalność
- `fix`: Naprawa błędu
- `docs`: Zmiany w dokumentacji
- `style`: Formatowanie, brak zmian logiki
- `refactor`: Refaktoryzacja kodu
- `test`: Dodanie/modyfikacja testów
- `chore`: Zadania administracyjne (np. update dependencies)

**Przykłady:**

```bash
git commit -m "feat(auth): Add email validation to register form"
git commit -m "fix(events): Fix crash when loading events with null imageUrl"
git commit -m "docs: Update README with installation instructions"
git commit -m "refactor(events): Extract event card to separate widget"
```

### 15.9.2. Branch strategy

```
main                # Produkcja (stabilna)
├── develop         # Rozwój (integracja features)
    ├── feature/auth-flow
    ├── feature/events-map
    └── bugfix/login-crash
```

---

## 15.10. Performance Best Practices

### 15.10.1. Widget rebuilds

```dart
// ❌ ZŁE - cały widget rebuilds
Widget build(BuildContext context) {
  return BlocBuilder<EventsBloc, EventsState>(
    builder: (context, state) {
      return Column(
        children: [
          Header(),              // Rebuilds niepotrzebnie
          EventsList(state),
          Footer(),              // Rebuilds niepotrzebnie
        ],
      );
    },
  );
}

// ✅ DOBRE - tylko lista rebuilds
Widget build(BuildContext context) {
  return Column(
    children: [
      const Header(),          // const = nie rebuilds
      BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          return EventsList(state);
        },
      ),
      const Footer(),          // const = nie rebuilds
    ],
  );
}
```

### 15.10.2. Database queries

```dart
// ❌ ZŁE - wiele pojedynczych zapytań
for (var id in eventIds) {
  final event = await isar.eventModels.filter().idEqualTo(id).findFirst();
  events.add(event);
}

// ✅ DOBRE - jedno zapytanie batch
final events = await isar.eventModels
  .filter()
  .anyOf(eventIds, (q, id) => q.idEqualTo(id))
  .findAll();
```

### 15.10.3. Image loading

```dart
// Użyj cached_network_image dla obrazków z sieci
CachedNetworkImage(
  imageUrl: event.imageUrl!,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
