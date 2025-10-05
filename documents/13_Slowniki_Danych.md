# 13. Słowniki Danych

**Dokument:** 13_Slowniki_Danych.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 13.1. Przegląd

Niniejszy dokument zawiera słowniki danych definiujące wszystkie wartości domenowe, typy wyliczeniowe (enums), stałe, kody oraz reguły walidacji stosowane w aplikacji SmokPomaga.

---

## 13.2. Role użytkowników (UserRole)

### 13.2.1. Definicja

```dart
enum UserRole {
  volunteer,
  organization,
  coordinator,
}
```

### 13.2.2. Wartości

| Wartość | Kod | Opis | Uprawnienia |
|---------|-----|------|-------------|
| **volunteer** | `volunteer` | Wolontariusz (student lub osoba zewnętrzna) | Przeglądanie wydarzeń, aplikowanie, przeglądanie własnych certyfikatów |
| **organization** | `organization` | Organizacja (NGO, fundacja, firma) | Tworzenie wydarzeń, zarządzanie aplikacjami, wystawianie certyfikatów |
| **coordinator** | `coordinator` | Koordynator UEK (administrator) | Weryfikacja studentów UEK, zatwierdzanie certyfikatów, eksport raportów |

### 13.2.3. Użycie w systemie

```dart
// W modelu User
class UserModel {
  late String role; // "volunteer", "organization", "coordinator"
}

// Sprawdzanie roli
if (user.role == 'volunteer') {
  // Pokaż dashboard wolontariusza
}
```

---

## 13.3. Statusy wydarzeń (EventStatus)

### 13.3.1. Definicja

```dart
enum EventStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
}
```

### 13.3.2. Wartości

| Wartość | Kod | Opis | Kiedy stosować |
|---------|-----|------|----------------|
| **upcoming** | `upcoming` | Zaplanowane | Wydarzenie w przyszłości (data > teraz) |
| **ongoing** | `ongoing` | W trakcie | Wydarzenie trwa (data == dzisiaj) |
| **completed** | `completed` | Zakończone | Wydarzenie zakończone pomyślnie |
| **cancelled** | `cancelled` | Odwołane | Wydarzenie anulowane przez organizację |

### 13.3.3. Diagram stanów

```
      created
         ↓
     upcoming ──────> cancelled
         ↓
      ongoing ───────> cancelled
         ↓
     completed
```

### 13.3.4. Reguły biznesowe

- Status `upcoming` → `ongoing`: Automatycznie w dniu wydarzenia
- Status `ongoing` → `completed`: Manualnie przez organizację po zakończeniu
- Status `upcoming/ongoing` → `cancelled`: Manualnie przez organizację
- Z `cancelled` i `completed` **nie można** zmienić statusu

---

## 13.4. Statusy aplikacji (ApplicationStatus)

### 13.4.1. Definicja

```dart
enum ApplicationStatus {
  pending,
  approved,
  rejected,
}
```

### 13.4.2. Wartości

| Wartość | Kod | Opis | Kiedy stosować |
|---------|-----|------|----------------|
| **pending** | `pending` | Oczekuje | Aplikacja złożona, czeka na decyzję organizacji |
| **approved** | `approved` | Zaakceptowana | Organizacja zaakceptowała wolontariusza |
| **rejected** | `rejected` | Odrzucona | Organizacja odrzuciła aplikację (brak miejsc, niewłaściwy profil) |

### 13.4.3. Diagram stanów

```
   pending
      ↓
   ┌──┴──┐
   ↓     ↓
approved  rejected
```

### 13.4.4. Reguły biznesowe

- Nowa aplikacja: Status = `pending`
- Organizacja może zmienić `pending` → `approved` lub `pending` → `rejected`
- Z `approved` i `rejected` **nie można** zmienić statusu
- Limit miejsc: Gdy `volunteersApplied >= volunteersNeeded`, nowe aplikacje mogą być automatycznie `rejected`

---

## 13.5. Kategorie wydarzeń (EventCategory)

### 13.5.1. Definicja

```dart
enum EventCategory {
  ekologia,
  edukacja,
  sport,
  kultura,
  pomoc_spoleczna,
  inne,
}
```

### 13.5.2. Wartości

| Wartość | Kod | Nazwa PL | Ikona | Przykłady |
|---------|-----|----------|-------|-----------|
| **ekologia** | `ekologia` | Ekologia | 🌱 | Sprzątanie parków, sadzenie drzew, segregacja śmieci |
| **edukacja** | `edukacja` | Edukacja | 📚 | Korepetycje, warsztaty, mentoring |
| **sport** | `sport` | Sport | ⚽ | Organizacja zawodów, treningi dla dzieci, imprezy sportowe |
| **kultura** | `kultura` | Kultura | 🎭 | Festiwale, wystawy, koncerty, teatr |
| **pomoc_spoleczna** | `pomoc_spoleczna` | Pomoc społeczna | 🤝 | Pomoc seniorom, wsparcie dla bezdomnych, zbiórki |
| **inne** | `inne` | Inne | 📦 | Wydarzenia niewchodzące w powyższe kategorie |

### 13.5.3. Użycie w filtrach

```dart
// Filtrowanie po kategorii
final ecoEvents = await isar.eventModels
  .filter()
  .categoryEqualTo('ekologia')
  .findAll();
```

---

## 13.6. Kody błędów (ErrorCode)

### 13.6.1. Kategorie błędów

| Prefix | Kategoria | Zakres kodów | Przykład |
|--------|-----------|--------------|----------|
| **AUTH** | Autoryzacja | AUTH-001 - AUTH-099 | AUTH-001 |
| **VAL** | Walidacja | VAL-001 - VAL-099 | VAL-010 |
| **DB** | Baza danych | DB-001 - DB-099 | DB-005 |
| **NET** | Sieć | NET-001 - NET-099 | NET-001 |
| **SYS** | System | SYS-001 - SYS-099 | SYS-001 |

### 13.6.2. Błędy autoryzacji (AUTH)

| Kod | Nazwa | Komunikat | Rozwiązanie |
|-----|-------|-----------|-------------|
| **AUTH-001** | InvalidCredentials | Nieprawidłowy email lub hasło | Sprawdź dane logowania |
| **AUTH-002** | UserNotFound | Użytkownik nie istnieje | Zarejestruj nowe konto |
| **AUTH-003** | EmailAlreadyExists | Email jest już zajęty | Użyj innego adresu email |
| **AUTH-004** | SessionExpired | Sesja wygasła | Zaloguj się ponownie |
| **AUTH-005** | InsufficientPermissions | Brak uprawnień | Skontaktuj się z administratorem |

### 13.6.3. Błędy walidacji (VAL)

| Kod | Nazwa | Komunikat | Rozwiązanie |
|-----|-------|-----------|-------------|
| **VAL-001** | InvalidEmail | Nieprawidłowy format email | Wpisz poprawny adres email |
| **VAL-002** | PasswordTooShort | Hasło zbyt krótkie | Hasło musi mieć min. 8 znaków |
| **VAL-003** | RequiredFieldEmpty | Pole wymagane jest puste | Wypełnij wszystkie wymagane pola |
| **VAL-004** | InvalidDate | Nieprawidłowa data | Data musi być w przyszłości |
| **VAL-005** | InvalidNumber | Nieprawidłowa liczba | Wpisz liczbę całkowitą > 0 |
| **VAL-006** | InvalidPhoneNumber | Nieprawidłowy numer telefonu | Format: +48 123 456 789 |
| **VAL-007** | TextTooLong | Tekst zbyt długi | Maksymalnie 500 znaków |

### 13.6.4. Błędy bazy danych (DB)

| Kod | Nazwa | Komunikat | Rozwiązanie |
|-----|-------|-----------|-------------|
| **DB-001** | DatabaseNotInitialized | Baza danych nie została zainicjalizowana | Uruchom aplikację ponownie |
| **DB-002** | RecordNotFound | Rekord nie został znaleziony | Sprawdź ID rekordu |
| **DB-003** | DuplicateKey | Rekord już istnieje | Użyj unikalnej wartości |
| **DB-004** | TransactionFailed | Transakcja nie powiodła się | Spróbuj ponownie |
| **DB-005** | DatabaseCorrupted | Baza danych uszkodzona | Przywróć backup lub przeinstaluj |

### 13.6.5. Błędy sieciowe (NET)

| Kod | Nazwa | Komunikat | Rozwiązanie |
|-----|-------|-----------|-------------|
| **NET-001** | NoInternetConnection | Brak połączenia z internetem | Sprawdź połączenie Wi-Fi/dane mobilne |
| **NET-002** | RequestTimeout | Przekroczono limit czasu żądania | Spróbuj ponownie później |
| **NET-003** | ServerError | Błąd serwera (5xx) | Spróbuj ponownie później |
| **NET-004** | ClientError | Błąd klienta (4xx) | Sprawdź poprawność danych |
| **NET-005** | MapTilesNotLoaded | Nie można załadować kafelków mapy | Sprawdź połączenie z internetem |

### 13.6.6. Błędy systemowe (SYS)

| Kod | Nazwa | Komunikat | Rozwiązanie |
|-----|-------|-----------|-------------|
| **SYS-001** | UnknownError | Nieznany błąd | Skontaktuj się z supportem |
| **SYS-002** | PermissionDenied | Brak uprawnień systemowych | Nadaj uprawnienia w ustawieniach |
| **SYS-003** | StorageFull | Brak miejsca na dysku | Zwolnij miejsce na urządzeniu |
| **SYS-004** | OutOfMemory | Brak pamięci | Zamknij inne aplikacje |

---

## 13.7. Reguły walidacji

### 13.7.1. Walidacja email

```dart
bool isValidEmail(String email) {
  final regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  return regex.hasMatch(email);
}
```

**Reguły:**
- Minimum 5 znaków
- Musi zawierać `@` i `.`
- Format: `user@domain.tld`
- Przykłady poprawne: `jan@uek.krakow.pl`, `test@gmail.com`
- Przykłady błędne: `jan@`, `@uek.pl`, `jan.uek.pl`

### 13.7.2. Walidacja hasła

```dart
bool isValidPassword(String password) {
  return password.length >= 8;
}
```

**Reguły:**
- Minimum 8 znaków
- Zalecane: mix liter, cyfr i znaków specjalnych
- Maksimum: 128 znaków

### 13.7.3. Walidacja nazwy

```dart
bool isValidName(String name) {
  return name.trim().length >= 2 && name.trim().length <= 100;
}
```

**Reguły:**
- Minimum 2 znaki
- Maksimum 100 znaków
- Może zawierać litery, spacje, myślniki

### 13.7.4. Walidacja numeru telefonu

```dart
bool isValidPhoneNumber(String phone) {
  final regex = RegExp(r'^\+?[0-9]{9,15}$');
  return regex.hasMatch(phone.replaceAll(' ', ''));
}
```

**Reguły:**
- Format międzynarodowy: `+48123456789`
- Format krajowy: `123456789`
- Długość: 9-15 cyfr
- Dozwolone spacje (ignorowane)

### 13.7.5. Walidacja daty wydarzenia

```dart
bool isValidEventDate(DateTime date) {
  final now = DateTime.now();
  final minDate = now;
  final maxDate = now.add(Duration(days: 365));
  return date.isAfter(minDate) && date.isBefore(maxDate);
}
```

**Reguły:**
- Data musi być w przyszłości (> teraz)
- Maksimum 1 rok do przodu
- Format: `DateTime` (ISO 8601)

### 13.7.6. Walidacja liczby wolontariuszy

```dart
bool isValidVolunteersCount(int count) {
  return count > 0 && count <= 1000;
}
```

**Reguły:**
- Minimum: 1
- Maksimum: 1000
- Typ: int

### 13.7.7. Walidacja opisu

```dart
bool isValidDescription(String description) {
  return description.trim().length >= 10 && description.trim().length <= 5000;
}
```

**Reguły:**
- Minimum: 10 znaków
- Maksimum: 5000 znaków
- Wymagane (nie może być puste)

---

## 13.8. Stałe aplikacji (Constants)

### 13.8.1. Limity

```dart
class AppLimits {
  static const int maxEventTitleLength = 100;
  static const int maxEventDescriptionLength = 5000;
  static const int maxMotivationLength = 500;
  static const int maxVolunteersPerEvent = 1000;
  static const int minVolunteersPerEvent = 1;
  static const int maxEventDaysInFuture = 365;
  static const int maxPasswordLength = 128;
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int minNameLength = 2;
}
```

### 13.8.2. Timeouts

```dart
class AppTimeouts {
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration mapTileTimeout = Duration(seconds: 10);
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration cacheExpiration = Duration(hours: 1);
}
```

### 13.8.3. Pagination

```dart
class AppPagination {
  static const int eventsPerPage = 20;
  static const int certificatesPerPage = 10;
  static const int applicationsPerPage = 20;
  static const int maxResults = 100;
}
```

### 13.8.4. Map defaults

```dart
class MapDefaults {
  static const double krakowLat = 50.0647;
  static const double krakowLng = 19.9450;
  static const double defaultZoom = 13.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 18.0;
}
```

### 13.8.5. Colors

```dart
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFFFFC107);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Status colors
  static const Color statusPending = Color(0xFFFFC107); // Amber
  static const Color statusApproved = Color(0xFF4CAF50); // Green
  static const Color statusRejected = Color(0xFFF44336); // Red
  static const Color statusCompleted = Color(0xFF9E9E9E); // Grey
}
```

---

## 13.9. Formaty danych

### 13.9.1. Format daty i czasu

```dart
class DateFormats {
  static const String displayDate = 'dd.MM.yyyy'; // 05.10.2025
  static const String displayTime = 'HH:mm'; // 14:30
  static const String displayDateTime = 'dd.MM.yyyy HH:mm'; // 05.10.2025 14:30
  static const String isoDateTime = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"; // ISO 8601
  static const String shortDate = 'dd MMM'; // 05 paź
  static const String longDate = 'EEEE, dd MMMM yyyy'; // sobota, 05 października 2025
}
```

**Przykłady użycia:**

```dart
// Formatowanie
final formatter = DateFormat(DateFormats.displayDate, 'pl_PL');
final formattedDate = formatter.format(DateTime.now()); // "05.10.2025"

// Parsing
final date = DateFormat(DateFormats.displayDate, 'pl_PL').parse('05.10.2025');
```

### 13.9.2. Format liczb

```dart
// Liczba godzin
String formatHours(int hours) {
  if (hours == 1) return '$hours godzina';
  if (hours % 10 >= 2 && hours % 10 <= 4 && (hours < 10 || hours > 20)) {
    return '$hours godziny';
  }
  return '$hours godzin';
}

// Przykłady:
// 1 godzina
// 2 godziny
// 5 godzin
// 22 godziny
```

### 13.9.3. Format koordynatów

```dart
// Szerokość geograficzna
String formatLatitude(double lat) {
  final direction = lat >= 0 ? 'N' : 'S';
  return '${lat.abs().toStringAsFixed(6)}° $direction';
}

// Długość geograficzna
String formatLongitude(double lng) {
  final direction = lng >= 0 ? 'E' : 'W';
  return '${lng.abs().toStringAsFixed(6)}° $direction';
}

// Przykład: 50.064700° N, 19.945000° E
```

---

## 13.10. Komunikaty systemowe

### 13.10.1. Komunikaty sukcesu

| Akcja | Komunikat |
|-------|-----------|
| Rejestracja | "Konto utworzone pomyślnie!" |
| Logowanie | "Witaj z powrotem!" |
| Aplikacja na wydarzenie | "Aplikacja wysłana pomyślnie!" |
| Akceptacja aplikacji | "Aplikacja zaakceptowana!" |
| Utworzenie wydarzenia | "Wydarzenie utworzone pomyślnie!" |
| Aktualizacja profilu | "Profil zaktualizowany!" |

### 13.10.2. Komunikaty potwierdzenia

| Akcja | Komunikat | Przyciski |
|-------|-----------|-----------|
| Usunięcie wydarzenia | "Czy na pewno chcesz usunąć to wydarzenie?" | Anuluj / Usuń |
| Odrzucenie aplikacji | "Czy na pewno chcesz odrzucić tę aplikację?" | Anuluj / Odrzuć |
| Wylogowanie | "Czy na pewno chcesz się wylogować?" | Anuluj / Wyloguj |
| Anulowanie wydarzenia | "Czy na pewno chcesz anulować to wydarzenie?" | Anuluj / Potwierdź |

### 13.10.3. Komunikaty informacyjne

| Sytuacja | Komunikat |
|----------|-----------|
| Brak wydarzeń | "Nie znaleziono wydarzeń. Sprawdź filtry lub spróbuj później." |
| Brak certyfikatów | "Nie masz jeszcze żadnych certyfikatów. Weź udział w wydarzeniu!" |
| Brak aplikacji | "Nie masz jeszcze żadnych aplikacji." |
| Ładowanie | "Ładowanie danych..." |
| Brak internetu (tryb offline) | "Tryb offline - dane mogą być nieaktualne" |

---

## 13.11. Mapowanie wartości na etykiety UI

### 13.11.1. Statusy wydarzeń

```dart
String getEventStatusLabel(String status) {
  switch (status) {
    case 'upcoming': return 'Nadchodzące';
    case 'ongoing': return 'W trakcie';
    case 'completed': return 'Zakończone';
    case 'cancelled': return 'Odwołane';
    default: return 'Nieznany';
  }
}
```

### 13.11.2. Statusy aplikacji

```dart
String getApplicationStatusLabel(String status) {
  switch (status) {
    case 'pending': return 'Oczekuje';
    case 'approved': return 'Zaakceptowana';
    case 'rejected': return 'Odrzucona';
    default: return 'Nieznany';
  }
}
```

### 13.11.3. Role użytkowników

```dart
String getUserRoleLabel(String role) {
  switch (role) {
    case 'volunteer': return 'Wolontariusz';
    case 'organization': return 'Organizacja';
    case 'coordinator': return 'Koordynator';
    default: return 'Nieznany';
  }
}
```

### 13.11.4. Kategorie wydarzeń

```dart
String getEventCategoryLabel(String category) {
  switch (category) {
    case 'ekologia': return 'Ekologia';
    case 'edukacja': return 'Edukacja';
    case 'sport': return 'Sport';
    case 'kultura': return 'Kultura';
    case 'pomoc_spoleczna': return 'Pomoc społeczna';
    case 'inne': return 'Inne';
    default: return 'Nieznany';
  }
}
```

---

## 13.12. Reguły biznesowe zaawansowane

### 13.12.1. Automatyczne zmiany statusów wydarzeń

```dart
// Sprawdzenie i aktualizacja statusu wydarzenia
Future<void> updateEventStatusIfNeeded(EventModel event) async {
  final now = DateTime.now();
  final eventDate = event.date;
  
  if (event.status == 'upcoming' && 
      eventDate.year == now.year &&
      eventDate.month == now.month &&
      eventDate.day == now.day) {
    // Wydarzenie jest dzisiaj -> zmień na "ongoing"
    event.status = 'ongoing';
    await isar.writeTxn(() async {
      await isar.eventModels.put(event);
    });
  }
}
```

### 13.12.2. Automatyczne generowanie certyfikatów

```dart
// Po zakończeniu wydarzenia (status = completed)
Future<void> generateCertificatesForEvent(String eventId) async {
  final event = await isar.eventModels.filter().idEqualTo(eventId).findFirst();
  if (event?.status != 'completed') return;
  
  // Znajdź wszystkie zaakceptowane aplikacje
  final approvedApplications = await isar.applicationModels
    .filter()
    .eventIdEqualTo(eventId)
    .and()
    .statusEqualTo('approved')
    .findAll();
  
  // Generuj certyfikaty
  for (final app in approvedApplications) {
    final certificate = CertificateModel(
      id: 'cert-${event.id}-${app.userId}',
      userId: app.userId,
      eventTitle: event.title,
      hoursCompleted: calculateHours(event), // Logika wyliczania godzin
      issueDate: DateTime.now(),
      description: 'Uczestnictwo w wydarzeniu: ${event.title}',
    );
    
    await isar.writeTxn(() async {
      await isar.certificateModels.put(certificate);
    });
  }
}
```

### 13.12.3. Limit wolontariuszy

```dart
// Sprawdzenie czy można jeszcze aplikować
bool canApplyToEvent(EventModel event) {
  return event.volunteersApplied < event.volunteersNeeded &&
         event.status == 'upcoming';
}
```

---

## 13.13. Priorytetyzacja i wagi

### 13.13.1. Sortowanie wydarzeń

```dart
enum EventSortOrder {
  dateAscending,    // Najbliższe najpierw
  dateDescending,   // Najdalsze najpierw
  popularityDesc,   // Najwięcej aplikacji
  availabilityDesc, // Najwięcej wolnych miejsc
}
```

### 13.13.2. Wagi kategorii (dla algorytmów rekomendacji - future)

| Kategoria | Waga | Opis |
|-----------|------|------|
| ekologia | 1.2 | Priorytetowa kategoria |
| edukacja | 1.1 | Wysoki priorytet |
| pomoc_spoleczna | 1.1 | Wysoki priorytet |
| sport | 1.0 | Normalny priorytet |
| kultura | 1.0 | Normalny priorytet |
| inne | 0.9 | Niższy priorytet |

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
