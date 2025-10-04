# 🗄️ Isar - Lokalna baza danych

## ✅ Co zostało zaimplementowane

### 1. **Modele Isar** (Data Layer)

#### `VolunteerEventIsarModel`
Lokalna kopia wydarzeń z metadanymi:
- `eventId` - ID wydarzenia (z indeksem)
- `title`, `description`, `organization`, `location` - dane wydarzenia
- `date` - data wydarzenia (z indeksem dla sortowania)
- `requiredVolunteers`, `categories` - dodatkowe dane
- `imageUrl` - opcjonalny obrazek
- **Metadane:**
  - `cachedAt` - kiedy dane zostały zapisane (z indeksem)
  - `isSynced` - czy zsynchronizowane z backendem

#### `UserInterestIsarModel`
Zainteresowania użytkownika:
- `eventId` - ID wydarzenia (unique index)
- `interestDate` - kiedy użytkownik wybrał (z indeksem)
- `isInterested` - `true` = polubione, `false` = pominięte

### 2. **Data Sources**

#### `IsarDataSource` (interfejs)
Abstrakcja dla operacji na bazie:
- `init()` - inicjalizacja bazy
- `saveEvents()` / `getEvents()` - wydarzenia
- `saveInterest()` / `getInterests()` - zainteresowania
- `getInterestedEventIds()` / `getSkippedEventIds()`
- `clearEvents()` / `clearInterests()` - czyszczenie
- `close()` - zamknięcie bazy

#### `IsarDataSourceImpl` (implementacja)
Pełna implementacja z Isar:
- Transakcje (`writeTxn`)
- Filtry i indeksy
- Bezpieczne zapisy
- Error handling

#### `EventsLocalDataSourceIsarImpl`
Bridge między Isar a istniejącym kodem:
- Konwersja `VolunteerEventModel` ↔ `VolunteerEventIsarModel`
- Zachowanie istniejącego interfejsu
- Łatwa integracja z repository

### 3. **Dependency Injection**

Isar zintegrowany z `GetIt`:
```dart
// Inicjalizacja przy starcie
final isarDataSource = IsarDataSourceImpl();
await isarDataSource.init();

// Rejestracja
sl.registerLazySingleton<IsarDataSource>(() => isarDataSource);
sl.registerLazySingleton(() => EventsLocalDataSourceIsarImpl(sl()));
```

## 🏗️ Architektura

```
Domain Layer (niezmienna)
    ↓
Data Layer
    ├── Remote (Firebase - przyszłość)
    └── Local (Isar - teraz!)
        ├── Models (Isar collections)
        ├── DataSources (Isar operations)
        └── Bridge (integracja z istniejącym kodem)
```

## 📊 Struktura bazy Isar

```
hack_volunteers_db/
├── VolunteerEventIsarModel (collection)
│   ├── Index: eventId
│   ├── Index: date
│   └── Index: cachedAt
│
└── UserInterestIsarModel (collection)
    ├── Index (unique): eventId
    └── Index: interestDate
```

## 🎯 Funkcjonalności

### ✅ Aktualnie działają:

1. **Cache wydarzeń offline**
   - Wydarzenia zapisują się lokalnie
   - Dostępne bez internetu
   - Szybkie ładowanie

2. **Zapisywanie zainteresowań**
   - Like/Skip wydarzeń
   - Persistent storage
   - Historia akcji użytkownika

3. **Queries i filtrowanie**
   - Filtrowanie po `eventId`
   - Filtrowanie po `isInterested`
   - Sortowanie po dacie

### 🔜 Do zaimplementowania:

1. **Synchronizacja z Firebase**
   - Upload zainteresowań do cloud
   - Download nowych wydarzeń
   - Conflict resolution

2. **Advanced queries**
   - Filtrowanie po kategoriach
   - Filtrowanie po lokalizacji
   - Filtrowanie po dacie
   - Full-text search

3. **Cache management**
   - Automatyczne czyszczenie starych danych
   - Limit rozmiaru cache
   - Smart prefetching

4. **Offline mode**
   - Queue dla akcji offline
   - Auto-sync przy połączeniu
   - Conflict resolution

## 💻 Jak używać

### Dodawanie nowej kolekcji Isar:

1. **Utwórz model:**
```dart
@collection
class MyModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String someField;
  
  // Empty constructor required!
  MyModel();
}
```

2. **Wygeneruj kod:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. **Dodaj do schema w `IsarDataSourceImpl`:**
```dart
await Isar.open([
  VolunteerEventIsarModelSchema,
  UserInterestIsarModelSchema,
  MyModelSchema, // <- tutaj
], ...);
```

### Wykonywanie operacji:

```dart
// Zapisywanie
await isar.writeTxn(() async {
  await isar.myModels.put(model);
});

// Odczyt
final items = await isar.myModels.where().findAll();

// Filtrowanie
final filtered = await isar.myModels
    .filter()
    .someFieldEqualTo('value')
    .findAll();

// Usuwanie
await isar.writeTxn(() async {
  await isar.myModels.delete(id);
});
```

## 🚀 Performance

### Zalety Isar:

- ⚡ **Bardzo szybki** - natywny kod C++
- 📦 **Mały** - ~1.5 MB
- 🔍 **Potężne queries** - indeksy, filtry, sortowanie
- 💾 **Offline-first** - działa bez internetu
- 🔄 **Reactive** - watch changes w real-time
- 🎯 **Type-safe** - generowany kod

### Optymalizacje:

1. **Indeksy** - na często używanych polach (`@Index()`)
2. **Unique indexes** - dla unikalnych wartości
3. **Composite indexes** - dla złożonych queries (przyszłość)
4. **Batch operations** - `putAll()` zamiast wielu `put()`

## 📁 Lokalizacja plików

```
lib/
├── features/
│   ├── local_storage/          # ← NOWY FEATURE
│   │   └── data/
│   │       ├── models/
│   │       │   ├── volunteer_event_isar_model.dart
│   │       │   ├── user_interest_isar_model.dart
│   │       │   ├── *.g.dart (generated)
│   │       └── datasources/
│   │           ├── isar_data_source.dart (interface)
│   │           └── isar_data_source_impl.dart
│   │
│   └── events/
│       └── data/
│           └── datasources/
│               └── events_local_data_source_isar.dart  # Bridge
│
└── injection_container.dart     # DI setup
```

## 🎓 Clean Architecture

```
┌─────────────────────────────────────┐
│     Domain Layer (unchanged)         │
│  - Entities                          │
│  - Repository interfaces             │
│  - Use cases                         │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│         Data Layer                   │
│                                      │
│  ┌────────────┐    ┌──────────────┐│
│  │  Remote DS │    │  Local DS    ││
│  │ (Firebase) │    │   (Isar)     ││
│  └────────────┘    └──────────────┘│
│         ↓                 ↓          │
│  ┌─────────────────────────────┐   │
│  │   Repository Implementation  │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

**SOLID zasady zachowane!**
- ✅ Single Responsibility - każda klasa ma jedną odpowiedzialność
- ✅ Open/Closed - łatwo dodać nowe datasources
- ✅ Liskov Substitution - możesz zamienić implementacje
- ✅ Interface Segregation - małe, dedykowane interfejsy
- ✅ Dependency Inversion - zależności od abstrakcji

## 🧪 Testowanie

```dart
// Mock Isar data source dla testów
class MockIsarDataSource extends Mock implements IsarDataSource {}

// Test
test('should cache events locally', () async {
  final mockIsar = MockIsarDataSource();
  final dataSource = EventsLocalDataSourceIsarImpl(mockIsar);
  
  when(mockIsar.saveEvents(any)).thenAnswer((_) async => Future.value());
  
  await dataSource.cacheEvents(testEvents);
  
  verify(mockIsar.saveEvents(any)).called(1);
});
```

## 📝 Status: v0.2.0

- [x] Modele Isar utworzone
- [x] Code generation działa
- [x] Data sources zaimplementowane
- [x] Integracja z DI
- [x] Bridge do istniejącego kodu
- [ ] Użycie w Repository (następny krok)
- [ ] Synchronizacja z Firebase
- [ ] Advanced queries
- [ ] Cache management

---

**Następny krok**: Zamień in-memory storage na Isar w `EventsRepositoryImpl`! 🚀
