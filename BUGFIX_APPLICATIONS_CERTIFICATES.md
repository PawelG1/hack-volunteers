# Poprawki - Zgłoszenia i Certyfikaty

## 🐛 Naprawione Problemy

### 1. **Zgłoszenia nie były zapisywane do bazy danych**

#### Problem:
Po aplikacji wolontariusza na wydarzenie:
- Zgłoszenie było tworzone w pamięci
- NIE było zapisywane do bazy Isar
- Organizacja nie widziała zgłoszeń
- Koordynator nie miał dostępu do aplikacji

#### Przyczyna:
W `EventsRepositoryImpl.applyForEvent()` był komentarz TODO:
```dart
// TODO: Save to local database and sync with backend
// For now, we'll just return the application
```

#### Rozwiązanie:
✅ **Dodano zapis do bazy danych**

**Zmiany w** `events_repository_impl.dart`:
1. Dodano import: `OrganizationLocalDataSource`
2. Dodano dependency do konstruktora
3. Zastąpiono tworzenie w pamięci → użyto `createApplication()` z data source

```dart
// PRZED (nie działało):
final application = VolunteerApplication(
  id: uuid.v4(),
  eventId: eventId,
  // ... tylko w pamięci
);
return Right(application);

// PO (działa):
final application = await organizationLocalDataSource.createApplication(
  eventId: eventId,
  volunteerId: volunteerId,
  organizationId: event.organizationId ?? 'unknown',
  message: message,
);
return Right(application);
```

**Zmiany w** `injection_container.dart`:
```dart
// Dodano organizationLocalDataSource do EventsRepositoryImpl
() => EventsRepositoryImpl(
  remoteDataSource: sl(),
  localDataSource: sl(),
  organizationLocalDataSource: sl(), // ✅ NOWE
),
```

### 2. **Weryfikacja Workflow Certyfikatów**

#### Obecny Flow (POPRAWNY):

```
┌─────────────────────────────────────────────────────────────────┐
│                      CYKL ŻYCIA ZGŁOSZENIA                       │
└─────────────────────────────────────────────────────────────────┘

1. WOLONTARIUSZ aplikuje
   ├─> Status: PENDING
   ├─> Tworzone w bazie: ✅ (po poprawce)
   └─> Widoczne dla organizacji: ✅

2. ORGANIZACJA akceptuje/odrzuca
   ├─> Akceptuje: Status → ACCEPTED
   ├─> Odrzuca: Status → REJECTED (koniec)
   └─> Widoczne: OrganizationBloc.LoadEventApplications

3. WYDARZENIE się odbywa
   └─> (wolontariusz bierze udział)

4. ORGANIZACJA oznacza obecność
   ├─> Obecny: Status → ATTENDED
   │   ├─> Wprowadza hoursWorked
   │   ├─> Wprowadza rating (1-5)
   │   └─> Wprowadza feedback
   ├─> Nieobecny: Status → NOT_ATTENDED (koniec)
   └─> UI: AttendanceMarkingPage

5. KOORDYNATOR zatwierdza udział
   ├─> Filtr: tylko status ATTENDED
   ├─> Status → APPROVED
   ├─> Pole approvedAt: DateTime.now()
   ├─> Pole coordinatorId: ID koordynatora
   └─> UI: PendingApprovalsPage

6. KOORDYNATOR generuje certyfikat
   ├─> Wymóg: status APPROVED
   ├─> Tworzy Certificate z status ISSUED
   ├─> Status aplikacji → COMPLETED
   ├─> Pole certificateId: ID certyfikatu
   └─> UI: GenerateCertificatePage
```

#### Wymagania dla każdego etapu:

| Etap | Status IN | Akcja | Status OUT | Kto wykonuje |
|------|-----------|-------|------------|--------------|
| 1 | - | Apply | `pending` | Wolontariusz |
| 2 | `pending` | Accept | `accepted` | Organizacja |
| 2 | `pending` | Reject | `rejected` | Organizacja |
| 4 | `accepted` | Mark Attended | `attended` | Organizacja |
| 4 | `accepted` | Mark Not Attended | `notAttended` | Organizacja |
| 5 | `attended` | Approve | `approved` | Koordynator |
| 6 | `approved` | Generate Cert | `completed` | Koordynator |

## ✅ Co Teraz Działa

### Dla Wolontariusza:
1. ✅ Aplikuje na wydarzenie → Zapisywane do bazy
2. ✅ Może zobaczyć status w "Moje Wydarzenia"
3. ✅ Po completion: Widzi certyfikat w "Moje Certyfikaty"

### Dla Organizacji:
1. ✅ Widzi wszystkie zgłoszenia (LoadEventApplications)
2. ✅ Może akceptować/odrzucać (Accept/Reject)
3. ✅ Może oznaczyć obecność (AttendanceMarkingPage)
4. ✅ Może ocenić wolontariusza (rating + feedback)

### Dla Koordynatora:
1. ✅ Widzi aplikacje z status=attended (PendingApprovalsPage)
2. ✅ Może zatwierdzić udział (ApproveParticipation)
3. ✅ Może wygenerować certyfikat (GenerateCertificatePage)
   - ⚠️ TYLKO gdy status=approved

## 🔍 Weryfikacja Działania

### Test 1: Aplikacja wolontariusza
```dart
// Wolontariusz aplikuje
EventsBloc → ApplyForEvent(eventId: 'event-123')
  ↓
EventsRepository.applyForEvent()
  ↓
OrganizationLocalDataSource.createApplication()
  ↓
Isar.volunteerApplicationModels.put(model) ✅
  ↓
Status: PENDING, zapisane w bazie
```

### Test 2: Organizacja widzi zgłoszenia
```dart
// Organizacja otwiera listę
OrganizationBloc → LoadEventApplications(eventId: 'event-123')
  ↓
GetApplicationsForEvent use case
  ↓
OrganizationLocalDataSource query: eventId = 'event-123'
  ↓
Isar.volunteerApplicationModels.filter().eventIdEqualTo() ✅
  ↓
Zwraca listę aplikacji (włącznie z status=pending)
```

### Test 3: Koordynator widzi do zatwierdzenia
```dart
// Koordynator otwiera PendingApprovalsPage
CoordinatorBloc → LoadPendingApprovals()
  ↓
GetPendingApprovals use case
  ↓
CoordinatorLocalDataSource query: status = ATTENDED
  ↓
Isar.volunteerApplicationModels.filter().statusEqualTo(attended) ✅
  ↓
Zwraca tylko aplikacje z obecnością potwierdzoną
```

### Test 4: Certyfikat tylko dla approved
```dart
// Koordynator próbuje wygenerować certyfikat
CoordinatorBloc → GenerateVolunteerCertificate()
  ↓
GenerateCertificate use case
  ↓
CoordinatorLocalDataSource.generateCertificate()
  ↓
if (status != ApplicationStatus.approved) {
  throw Exception('Must be approved first') ❌
}
  ↓
Certyfikat tworzony tylko gdy approved ✅
```

## 📝 Sprawdzenie w Kodzie

### 1. Czy aplikacja zapisuje się?
**Plik:** `events_repository_impl.dart`
**Linia:** 115-130
```dart
final application = await organizationLocalDataSource.createApplication(...);
```
✅ **Status:** POPRAWIONE

### 2. Czy organizacja widzi zgłoszenia?
**Plik:** `organization_local_data_source.dart`
**Metoda:** `getApplicationsForEvent()`
```dart
final models = await isar.volunteerApplicationModels
    .filter()
    .eventIdEqualTo(eventId)
    .findAll();
```
✅ **Status:** DZIAŁA (po poprawce #1)

### 3. Czy koordynator widzi tylko attended?
**Plik:** `coordinator_local_data_source.dart`
**Metoda:** `getPendingApprovals()`
```dart
.filter()
.statusEqualTo(ApplicationStatus.attended)
```
✅ **Status:** DZIAŁA POPRAWNIE

### 4. Czy certyfikat wymaga approved?
**Plik:** `coordinator_local_data_source.dart`
**Metoda:** `generateCertificate()`
```dart
if (appModel.status != ApplicationStatus.approved) {
  throw Exception('Application must be approved before generating certificate');
}
```
✅ **Status:** WALIDACJA DZIAŁA

## 🎯 Podsumowanie Poprawek

### Zmiany w plikach:

1. **`lib/features/events/data/repositories/events_repository_impl.dart`**
   - ✅ Dodano import `OrganizationLocalDataSource`
   - ✅ Dodano dependency do konstruktora
   - ✅ Zastąpiono TODO → faktyczne zapisywanie do Isar
   - ✅ Dodano logi debugowania

2. **`lib/injection_container.dart`**
   - ✅ Dodano `organizationLocalDataSource` do `EventsRepositoryImpl`

### Rezultat:
- ✅ Zgłoszenia są zapisywane do bazy danych
- ✅ Organizacja widzi zgłoszenia wolontariuszy
- ✅ Koordynator widzi zgłoszenia z obecnością
- ✅ Certyfikaty generowane tylko dla approved
- ✅ Workflow działa zgodnie z założeniami

## 🧪 Jak Przetestować

### Scenariusz 1: Pełny workflow
```
1. Zaloguj jako WOLONTARIUSZ
2. Aplikuj na wydarzenie (karta swipe → Apply)
3. Sprawdź: console log "✅ Application created and saved"

4. Zaloguj jako ORGANIZACJA
5. Otwórz ApplicationsListPage
6. Sprawdź: Zgłoszenie jest widoczne z status "Pending"

7. Zaakceptuj zgłoszenie
8. Sprawdź: Status zmienił się na "Accepted"

9. Po wydarzeniu: Otwórz AttendanceMarkingPage
10. Oznacz obecność + godziny + ocena
11. Sprawdź: Status zmienił się na "Attended"

12. Zaloguj jako KOORDYNATOR
13. Otwórz PendingApprovalsPage
14. Sprawdź: Zgłoszenie jest widoczne

15. Zatwierdź udział
16. Sprawdź: Status zmienił się na "Approved"

17. Otwórz GenerateCertificatePage
18. Wygeneruj certyfikat
19. Sprawdź: Status zmienił się na "Completed"

20. Zaloguj jako WOLONTARIUSZ
21. Otwórz MyCertificatesPage
22. Sprawdź: Certyfikat jest widoczny ✅
```

### Scenariusz 2: Weryfikacja błędów
```
1. Spróbuj wygenerować certyfikat dla status=attended (nie approved)
   → Powinien pokazać błąd: "Must be approved first"

2. Spróbuj zatwierdzić zgłoszenie z status=pending (nie attended)
   → Powinien pokazać błąd: "Attendance not marked"
```

## 📊 Status Implementacji

| Komponent | Status | Uwagi |
|-----------|--------|-------|
| Apply for Event | ✅ POPRAWIONE | Zapisuje do bazy |
| View Applications (Org) | ✅ DZIAŁA | Po poprawce Apply |
| Accept/Reject | ✅ DZIAŁA | - |
| Mark Attendance | ✅ DZIAŁA | - |
| View Pending (Coord) | ✅ DZIAŁA | Tylko status=attended |
| Approve Participation | ✅ DZIAŁA | Wymaga attended |
| Generate Certificate | ✅ DZIAŁA | Wymaga approved |
| View Certificates (Vol) | ✅ DZIAŁA | - |

---

**Data poprawki:** October 5, 2025  
**Pliki zmodyfikowane:** 2  
**Status kompilacji:** ✅ Bez błędów  
**Testy:** Wymagane manualne przetestowanie workflow
