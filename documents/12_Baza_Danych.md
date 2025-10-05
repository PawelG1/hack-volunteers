# 12. Dokumentacja Bazy Danych

**Dokument:** 12_Baza_Danych.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 12.1. Przegląd bazy danych

### 12.1.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Typ bazy** | NoSQL (obiektowa) |
| **Silnik** | Isar Database 3.1.0+1 |
| **Język** | Dart (schema + queries) |
| **Lokalizacja** | Lokalna pamięć urządzenia Android |
| **Szyfrowanie** | Brak (obecnie) |
| **Wersja schematu** | 1 |
| **Maksymalny rozmiar** | Ograniczony dostępną pamięcią |

### 12.1.2. Ścieżka do bazy danych

```
Android: /data/data/com.mlodykrakow.hack_volunteers/files/default.isar
```

### 12.1.3. Kolekcje (tabele)

| Nazwa kolekcji | Encja domenowa | Liczba pól | Indeksy |
|----------------|----------------|------------|---------|
| `eventModels` | Event | 13 | 3 |
| `certificateModels` | Certificate | 7 | 2 |
| `applicationModels` | Application | 7 | 3 |
| `userModels` | User | 8 | 3 |

---

## 12.2. Kolekcja: eventModels (Wydarzenia)

### 12.2.1. Opis

Przechowuje informacje o wydarzeniach wolontariackich organizowanych przez organizacje partnerskie.

### 12.2.2. Schema (Dart)

```dart
@collection
class EventModel {
  Id? isarId; // Auto-increment ID (Isar internal)
  
  late String id; // Business ID (UUID)
  late String title;
  late String description;
  late DateTime date;
  late String location;
  late double latitude;
  late double longitude;
  late int volunteersNeeded;
  late int volunteersApplied;
  late String category;
  String? imageUrl;
  late String requirements;
  late String status; // upcoming, ongoing, completed, cancelled
  late DateTime createdAt;
}
```

### 12.2.3. Struktura pól

| Pole | Typ | Nullable | Default | Opis |
|------|-----|----------|---------|------|
| `isarId` | Id (int64) | Tak | Auto | Klucz główny (wewnętrzny Isar) |
| `id` | String | Nie | - | Identyfikator biznesowy (UUID) |
| `title` | String | Nie | - | Tytuł wydarzenia (np. "Sprzątanie Parku Jordana") |
| `description` | String | Nie | - | Szczegółowy opis wydarzenia (markdown/plain text) |
| `date` | DateTime | Nie | - | Data i godzina rozpoczęcia wydarzenia |
| `location` | String | Nie | - | Adres tekstowy (np. "Park Jordana, Kraków") |
| `latitude` | double | Nie | - | Szerokość geograficzna (np. 50.0647) |
| `longitude` | double | Nie | - | Długość geograficzna (np. 19.9450) |
| `volunteersNeeded` | int | Nie | - | Liczba potrzebnych wolontariuszy |
| `volunteersApplied` | int | Nie | 0 | Liczba wolontariuszy, którzy się zgłosili |
| `category` | String | Nie | - | Kategoria (ekologia, edukacja, sport, kultura, inne) |
| `imageUrl` | String | Tak | null | URL do zdjęcia wydarzenia |
| `requirements` | String | Nie | "" | Wymagania dla wolontariuszy |
| `status` | String | Nie | "upcoming" | Status (upcoming/ongoing/completed/cancelled) |
| `createdAt` | DateTime | Nie | now() | Data utworzenia rekordu |

### 12.2.4. Indeksy

| Nazwa indeksu | Pole(a) | Typ | Cel |
|---------------|---------|-----|-----|
| `id_idx` | `id` | Unique | Szybkie wyszukiwanie po UUID |
| `date_idx` | `date` | Regular | Sortowanie chronologiczne |
| `category_idx` | `category` | Regular | Filtrowanie po kategorii |

### 12.2.5. Przykładowe dane

```dart
EventModel(
  id: '550e8400-e29b-41d4-a716-446655440000',
  title: 'Sprzątanie Parku Jordana',
  description: 'Pomóż nam przywrócić czystość w Parku Jordana! Zbierzemy śmieci, posprzątatmy ścieżki i zadbamy o zieleń.',
  date: DateTime(2025, 10, 15, 10, 0),
  location: 'Park Jordana, Kraków',
  latitude: 50.0647,
  longitude: 19.9450,
  volunteersNeeded: 20,
  volunteersApplied: 12,
  category: 'ekologia',
  imageUrl: 'https://example.com/images/park-jordana.jpg',
  requirements: 'Rękawice robocze, wygodne ubranie',
  status: 'upcoming',
  createdAt: DateTime(2025, 9, 1, 12, 0),
)
```

### 12.2.6. Wartości dopuszczalne

**status:**
- `upcoming` - Wydarzenie zaplanowane (przyszłość)
- `ongoing` - Wydarzenie trwa (obecnie)
- `completed` - Wydarzenie zakończone
- `cancelled` - Wydarzenie odwołane

**category:**
- `ekologia` - Ochrona środowiska
- `edukacja` - Nauczanie, korepetycje
- `sport` - Wydarzenia sportowe
- `kultura` - Wydarzenia kulturalne
- `pomoc_spoleczna` - Pomoc osobom potrzebującym
- `inne` - Inne kategorie

### 12.2.7. Zapytania typowe

```dart
// Pobierz wszystkie nadchodzące wydarzenia
final upcomingEvents = await isar.eventModels
  .filter()
  .statusEqualTo('upcoming')
  .sortByDate()
  .findAll();

// Pobierz wydarzenie po ID
final event = await isar.eventModels
  .filter()
  .idEqualTo(eventId)
  .findFirst();

// Pobierz wydarzenia z kategorii "ekologia"
final ecoEvents = await isar.eventModels
  .filter()
  .categoryEqualTo('ekologia')
  .findAll();

// Pobierz wydarzenia z ostatnich 7 dni
final recentEvents = await isar.eventModels
  .filter()
  .dateGreaterThan(DateTime.now().subtract(Duration(days: 7)))
  .sortByDateDesc()
  .findAll();
```

---

## 12.3. Kolekcja: certificateModels (Certyfikaty)

### 12.3.1. Opis

Przechowuje certyfikaty wolontariackie wystawione wolontariuszom po ukończeniu wydarzeń.

### 12.3.2. Schema (Dart)

```dart
@collection
class CertificateModel {
  Id? isarId;
  
  late String id; // UUID
  late String userId; // FK to User
  late String eventTitle;
  late int hoursCompleted;
  late DateTime issueDate;
  String? certificateUrl; // URL do PDF
  late String description;
}
```

### 12.3.3. Struktura pól

| Pole | Typ | Nullable | Default | Opis |
|------|-----|----------|---------|------|
| `isarId` | Id (int64) | Tak | Auto | Klucz główny (wewnętrzny Isar) |
| `id` | String | Nie | - | Identyfikator certyfikatu (UUID) |
| `userId` | String | Nie | - | Klucz obcy do użytkownika (User.id) |
| `eventTitle` | String | Nie | - | Tytuł wydarzenia (skopiowany z Event) |
| `hoursCompleted` | int | Nie | - | Liczba przepracowanych godzin |
| `issueDate` | DateTime | Nie | now() | Data wystawienia certyfikatu |
| `certificateUrl` | String | Tak | null | URL do pliku PDF certyfikatu |
| `description` | String | Nie | - | Dodatkowy opis / osiągnięcia |

### 12.3.4. Indeksy

| Nazwa indeksu | Pole(a) | Typ | Cel |
|---------------|---------|-----|-----|
| `id_idx` | `id` | Unique | Szybkie wyszukiwanie po UUID |
| `userId_idx` | `userId` | Regular | Pobieranie certyfikatów użytkownika |

### 12.3.5. Przykładowe dane

```dart
CertificateModel(
  id: 'cert-001-2025',
  userId: 'user-jan-kowalski',
  eventTitle: 'Sprzątanie Parku Jordana',
  hoursCompleted: 4,
  issueDate: DateTime(2025, 10, 15, 14, 0),
  certificateUrl: 'https://example.com/certificates/cert-001-2025.pdf',
  description: 'Uczestniczył w całym wydarzeniu, zebrał 15 worków śmieci.',
)
```

### 12.3.6. Relacje

```
User (1) ─────< Certificate (*)
```

- Jeden użytkownik może mieć wiele certyfikatów
- Certyfikat należy do dokładnie jednego użytkownika

### 12.3.7. Zapytania typowe

```dart
// Pobierz wszystkie certyfikaty użytkownika
final userCerts = await isar.certificateModels
  .filter()
  .userIdEqualTo(userId)
  .sortByIssueDateDesc()
  .findAll();

// Policz sumę godzin użytkownika
final certificates = await isar.certificateModels
  .filter()
  .userIdEqualTo(userId)
  .findAll();
final totalHours = certificates.fold(0, (sum, cert) => sum + cert.hoursCompleted);

// Pobierz certyfikaty z ostatniego miesiąca
final recentCerts = await isar.certificateModels
  .filter()
  .issueDateGreaterThan(DateTime.now().subtract(Duration(days: 30)))
  .findAll();
```

---

## 12.4. Kolekcja: applicationModels (Aplikacje)

### 12.4.1. Opis

Przechowuje aplikacje wolontariuszy na wydarzenia (zgłoszenia udziału).

### 12.4.2. Schema (Dart)

```dart
@collection
class ApplicationModel {
  Id? isarId;
  
  late String id; // UUID
  late String eventId; // FK to Event
  late String userId; // FK to User
  late String status; // pending, approved, rejected
  late DateTime appliedAt;
  late String motivation;
  DateTime? reviewedAt;
}
```

### 12.4.3. Struktura pól

| Pole | Typ | Nullable | Default | Opis |
|------|-----|----------|---------|------|
| `isarId` | Id (int64) | Tak | Auto | Klucz główny (wewnętrzny Isar) |
| `id` | String | Nie | - | Identyfikator aplikacji (UUID) |
| `eventId` | String | Nie | - | Klucz obcy do wydarzenia (Event.id) |
| `userId` | String | Nie | - | Klucz obcy do użytkownika (User.id) |
| `status` | String | Nie | "pending" | Status aplikacji (pending/approved/rejected) |
| `appliedAt` | DateTime | Nie | now() | Data i czas złożenia aplikacji |
| `motivation` | String | Nie | "" | Motywacja wolontariusza (opcjonalne pole tekstowe) |
| `reviewedAt` | DateTime | Tak | null | Data i czas przeglądnięcia przez organizację |

### 12.4.4. Indeksy

| Nazwa indeksu | Pole(a) | Typ | Cel |
|---------------|---------|-----|-----|
| `id_idx` | `id` | Unique | Szybkie wyszukiwanie po UUID |
| `userId_idx` | `userId` | Regular | Pobieranie aplikacji użytkownika |
| `eventId_idx` | `eventId` | Regular | Pobieranie aplikacji na wydarzenie |

### 12.4.5. Przykładowe dane

```dart
ApplicationModel(
  id: 'app-12345',
  eventId: '550e8400-e29b-41d4-a716-446655440000',
  userId: 'user-jan-kowalski',
  status: 'approved',
  appliedAt: DateTime(2025, 10, 1, 15, 30),
  motivation: 'Chcę pomóc w ochronie środowiska i zdobyć doświadczenie w akcjach ekologicznych.',
  reviewedAt: DateTime(2025, 10, 2, 10, 0),
)
```

### 12.4.6. Wartości dopuszczalne

**status:**
- `pending` - Oczekuje na rozpatrzenie
- `approved` - Zaakceptowana przez organizację
- `rejected` - Odrzucona przez organizację

### 12.4.7. Relacje

```
Event (1) ─────< Application (*)
User (1) ─────< Application (*)
```

- Jedno wydarzenie może mieć wiele aplikacji
- Jeden użytkownik może mieć wiele aplikacji
- Aplikacja dotyczy dokładnie jednego wydarzenia i jednego użytkownika

### 12.4.8. Zapytania typowe

```dart
// Pobierz aplikacje użytkownika
final userApps = await isar.applicationModels
  .filter()
  .userIdEqualTo(userId)
  .sortByAppliedAtDesc()
  .findAll();

// Pobierz aplikacje na wydarzenie
final eventApps = await isar.applicationModels
  .filter()
  .eventIdEqualTo(eventId)
  .findAll();

// Pobierz aplikacje oczekujące na rozpatrzenie
final pendingApps = await isar.applicationModels
  .filter()
  .statusEqualTo('pending')
  .findAll();

// Sprawdź, czy użytkownik już aplikował na wydarzenie
final existingApp = await isar.applicationModels
  .filter()
  .userIdEqualTo(userId)
  .and()
  .eventIdEqualTo(eventId)
  .findFirst();
```

---

## 12.5. Kolekcja: userModels (Użytkownicy)

### 12.5.1. Opis

Przechowuje dane użytkowników systemu (wolontariusze, organizacje, koordynatorzy).

### 12.5.2. Schema (Dart)

```dart
@collection
class UserModel {
  Id? isarId;
  
  late String id; // UUID
  late String email;
  late String name;
  late String role; // volunteer, organization, coordinator
  late String hashedPassword;
  String? phoneNumber;
  String? avatarUrl;
  late DateTime createdAt;
}
```

### 12.5.3. Struktura pól

| Pole | Typ | Nullable | Default | Opis |
|------|-----|----------|---------|------|
| `isarId` | Id (int64) | Tak | Auto | Klucz główny (wewnętrzny Isar) |
| `id` | String | Nie | - | Identyfikator użytkownika (UUID) |
| `email` | String | Nie | - | Adres email (unikalny) |
| `name` | String | Nie | - | Imię i nazwisko |
| `role` | String | Nie | - | Rola użytkownika (volunteer/organization/coordinator) |
| `hashedPassword` | String | Nie | - | Zahashowane hasło (obecnie mock, future: bcrypt) |
| `phoneNumber` | String | Tak | null | Numer telefonu (opcjonalnie) |
| `avatarUrl` | String | Tak | null | URL do zdjęcia profilowego |
| `createdAt` | DateTime | Nie | now() | Data rejestracji |

### 12.5.4. Indeksy

| Nazwa indeksu | Pole(a) | Typ | Cel |
|---------------|---------|-----|-----|
| `id_idx` | `id` | Unique | Szybkie wyszukiwanie po UUID |
| `email_idx` | `email` | Unique | Logowanie, walidacja unikalności |
| `role_idx` | `role` | Regular | Filtrowanie po roli |

### 12.5.5. Przykładowe dane

```dart
UserModel(
  id: 'user-jan-kowalski',
  email: 'jan.kowalski@student.uek.krakow.pl',
  name: 'Jan Kowalski',
  role: 'volunteer',
  hashedPassword: 'hashed_password_123', // Mock (future: bcrypt)
  phoneNumber: '+48 123 456 789',
  avatarUrl: null,
  createdAt: DateTime(2025, 9, 1, 10, 0),
)
```

### 12.5.6. Wartości dopuszczalne

**role:**
- `volunteer` - Wolontariusz (student lub osoba zewnętrzna)
- `organization` - Organizacja (NGO, fundacja, firma)
- `coordinator` - Koordynator UEK (administrator studentów)

### 12.5.7. Relacje

```
User (1) ─────< Application (*)
User (1) ─────< Certificate (*)
```

- Jeden użytkownik może mieć wiele aplikacji
- Jeden użytkownik może mieć wiele certyfikatów

### 12.5.8. Zapytania typowe

```dart
// Pobierz użytkownika po email (logowanie)
final user = await isar.userModels
  .filter()
  .emailEqualTo(email)
  .findFirst();

// Pobierz użytkownika po ID
final user = await isar.userModels
  .filter()
  .idEqualTo(userId)
  .findFirst();

// Pobierz wszystkich wolontariuszy
final volunteers = await isar.userModels
  .filter()
  .roleEqualTo('volunteer')
  .findAll();

// Sprawdź, czy email już istnieje
final existingUser = await isar.userModels
  .filter()
  .emailEqualTo(email)
  .findFirst();
final emailExists = existingUser != null;
```

---

## 12.6. Związki między kolekcjami

### 12.6.1. Diagram relacji

```
┌─────────────────┐
│     Users       │
│  (userModels)   │
└────────┬────────┘
         │ 1
         │
    ┌────┴─────────────────┐
    │                      │
  * │                    * │
┌───┴──────────────┐  ┌───┴──────────────┐
│  Applications    │  │  Certificates    │
│(applicationModels)│  │(certificateModels)│
└───┬──────────────┘  └──────────────────┘
  * │
    │
    │ 1
┌───┴──────────────┐
│     Events       │
│  (eventModels)   │
└──────────────────┘
```

### 12.6.2. Opis relacji

| Relacja | Kardynalność | Opis |
|---------|--------------|------|
| User → Application | 1:N | Użytkownik może mieć wiele aplikacji |
| Event → Application | 1:N | Wydarzenie może mieć wiele aplikacji |
| User → Certificate | 1:N | Użytkownik może mieć wiele certyfikatów |

**Uwaga:** Isar nie używa tradycyjnych kluczy obcych (Foreign Keys). Relacje są implementowane przez przechowywanie ID w polach i manualne join'y w kodzie.

### 12.6.3. Implementacja relacji w kodzie

```dart
// Pobierz użytkownika i jego certyfikaty
final user = await isar.userModels.filter().idEqualTo(userId).findFirst();
final certificates = await isar.certificateModels
  .filter()
  .userIdEqualTo(user.id)
  .findAll();

// Pobierz wydarzenie i jego aplikacje
final event = await isar.eventModels.filter().idEqualTo(eventId).findFirst();
final applications = await isar.applicationModels
  .filter()
  .eventIdEqualTo(event.id)
  .findAll();

// Pobierz aplikację z pełnymi danymi użytkownika i wydarzenia
final application = await isar.applicationModels.filter().idEqualTo(appId).findFirst();
final user = await isar.userModels.filter().idEqualTo(application.userId).findFirst();
final event = await isar.eventModels.filter().idEqualTo(application.eventId).findFirst();
```

---

## 12.7. Transakcje i spójność danych

### 12.7.1. Transakcje zapisu

```dart
// Transakcja zapisu (ACID)
await isar.writeTxn(() async {
  await isar.eventModels.put(newEvent);
  await isar.applicationModels.put(newApplication);
});
```

### 12.7.2. Transakcje odczytu

```dart
// Transakcje odczytu są automatyczne (nie wymagają wrappera)
final events = await isar.eventModels.where().findAll();
```

### 12.7.3. Rollback

Isar automatycznie wykonuje rollback jeśli transakcja rzuci wyjątek:

```dart
try {
  await isar.writeTxn(() async {
    await isar.eventModels.put(event1);
    throw Exception('Error!'); // Rollback automatyczny
    await isar.eventModels.put(event2); // Nigdy nie zostanie wykonane
  });
} catch (e) {
  print('Transaction failed: $e');
}
```

---

## 12.8. Migracje schematu

### 12.8.1. Automatyczne migracje

Isar obsługuje automatyczne migracje dla:
- Dodawania nowych pól (z default values)
- Usuwania pól (dane tracone)
- Zmiany typu pola (z konwersją jeśli możliwa)

### 12.8.2. Przykład dodania pola

```dart
// PRZED
@collection
class EventModel {
  Id? isarId;
  late String id;
  late String title;
}

// PO (dodano pole description)
@collection
class EventModel {
  Id? isarId;
  late String id;
  late String title;
  late String description; // NOWE POLE
}

// Isar automatycznie doda pole z default value dla istniejących rekordów
```

### 12.8.3. Manualne migracje

Dla złożonych migracji (np. splitting fields, merging):

```dart
// 1. Odczytaj stare dane
final oldEvents = await isar.eventModels.where().findAll();

// 2. Przekształć dane
final newEvents = oldEvents.map((e) => EventModel(
  // ... transformacja
)).toList();

// 3. Usuń stare, zapisz nowe
await isar.writeTxn(() async {
  await isar.eventModels.clear();
  await isar.eventModels.putAll(newEvents);
});
```

---

## 12.9. Wydajność i optymalizacja

### 12.9.1. Zalecenia

| Operacja | Zalecenie |
|----------|-----------|
| **Indeksy** | Dodaj indeks na pola często wyszukiwane |
| **Batch operations** | Używaj `putAll()` zamiast wielokrotnego `put()` |
| **Transactions** | Grupuj operacje w transakcje |
| **Pagination** | Używaj `.limit()` i `.offset()` dla dużych list |
| **Lazy loading** | Nie ładuj wszystkich danych naraz |

### 12.9.2. Przykłady optymalizacji

```dart
// ❌ ZŁE (wiele pojedynczych zapisów)
for (final event in events) {
  await isar.writeTxn(() async {
    await isar.eventModels.put(event);
  });
}

// ✅ DOBRE (batch write w jednej transakcji)
await isar.writeTxn(() async {
  await isar.eventModels.putAll(events);
});

// ❌ ZŁE (załaduj wszystko)
final allEvents = await isar.eventModels.where().findAll();

// ✅ DOBRE (paginacja)
final page1 = await isar.eventModels.where().limit(20).findAll();
final page2 = await isar.eventModels.where().offset(20).limit(20).findAll();
```

### 12.9.3. Statystyki

```dart
// Rozmiar bazy danych
final dbSize = await isar.getSize();
print('Database size: ${dbSize / 1024 / 1024} MB');

// Liczba rekordów
final eventsCount = await isar.eventModels.count();
final usersCount = await isar.userModels.count();
print('Events: $eventsCount, Users: $usersCount');
```

---

## 12.10. Backup i restore

### 12.10.1. Export danych

```dart
// Export do JSON
final events = await isar.eventModels.where().findAll();
final json = jsonEncode(events.map((e) => e.toJson()).toList());
await File('backup_events.json').writeAsString(json);
```

### 12.10.2. Import danych

```dart
// Import z JSON
final jsonString = await File('backup_events.json').readAsString();
final List<dynamic> jsonList = jsonDecode(jsonString);
final events = jsonList.map((json) => EventModel.fromJson(json)).toList();

await isar.writeTxn(() async {
  await isar.eventModels.putAll(events);
});
```

### 12.10.3. Backup całej bazy

```dart
// Skopiuj plik .isar
final isarPath = isar.path;
final backupPath = '$isarPath.backup';
await File(isarPath).copy(backupPath);
```

---

## 12.11. Monitoring i diagnostyka

### 12.11.1. Isar Inspector

```bash
# Uruchom aplikację w trybie debug
flutter run --debug

# Otwórz Isar Inspector w przeglądarce
# URL wyświetli się w konsoli (zwykle http://localhost:40015)
```

### 12.11.2. Logi zapytań

```dart
// Włącz debug logging
Isar.initializeIsarCore(download: true);
```

---

## 12.12. Bezpieczeństwo

### 12.12.1. Obecne zabezpieczenia

- ✅ Dane przechowywane lokalnie (brak przesyłania przez sieć)
- ✅ Brak dostępu dla innych aplikacji (sandboxing Android)
- ❌ Brak szyfrowania bazy danych

### 12.12.2. Planowane ulepszenia

- 🔄 Szyfrowanie bazy danych (Isar Encryption)
- 🔄 Hashowanie haseł (bcrypt)
- 🔄 Backup zaszyfrowany w chmurze

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
