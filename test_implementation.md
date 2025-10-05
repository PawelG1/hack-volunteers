# 🧪 Test Manual - Organizations & Coordinators

## ✅ Zaimplementowane (Backend)

### **A. Organizations Module**
- ✅ Repository: `OrganizationRepositoryImpl`
- ✅ Data Source: `OrganizationLocalDataSource`
- ✅ Use Cases (6):
  1. `GetApplicationsForEvent` - pobierz zgłoszenia na wydarzenie
  2. `GetOrganizationApplications` - wszystkie zgłoszenia organizacji
  3. `AcceptApplication` - zaakceptuj zgłoszenie
  4. `RejectApplication` - odrzuć zgłoszenie
  5. `MarkAttendance` - oznacz obecność (attended/notAttended)
  6. `RateVolunteer` - oceń wolontariusza
- ✅ Dependency Injection: wszystko zarejestrowane

### **B. Coordinators Module**
- ✅ Repository: `CoordinatorRepositoryImpl`
- ✅ Data Source: `CoordinatorLocalDataSource`
- ✅ Use Cases (6):
  1. `GetPendingApprovals` - zgłoszenia czekające na zatwierdzenie
  2. `ApproveParticipation` - zatwierdź uczestnictwo
  3. `GenerateCertificate` - wygeneruj certyfikat
  4. `GetIssuedCertificates` - lista certyfikatów
  5. `GenerateMonthlyReport` - raport miesięczny
  6. `GetCoordinatorStatistics` - statystyki koordynatora
- ✅ Dependency Injection: wszystko zarejestrowane

---

## 🔄 Proces (6 kroków)

```
1. ZGŁOSZENIE (volunteer → organization)
   Status: pending
   
2. AKCEPTACJA (organization)
   Organization: acceptApplication()
   Status: pending → accepted
   
3. WYDARZENIE ODBYWA SIĘ
   (volunteer uczestniczy w wydarzeniu)
   
4. OBECNOŚĆ (organization)
   Organization: markAttendance()
   Status: accepted → attended/notAttended
   
5. ZATWIERDZENIE (coordinator)
   Coordinator: approveParticipation()
   Status: attended → approved
   
6. CERTYFIKAT (coordinator)
   Coordinator: generateCertificate()
   Status: approved → completed
   + tworzy Certificate entity
```

---

## 🧪 Jak przetestować?

### **Test 1: Tworzenie zgłoszenia (manual w Isar Inspector)**
1. Otwórz Isar Inspector
2. Dodaj ręcznie `VolunteerApplicationModel`:
   ```dart
   applicationId: "test-app-1"
   eventId: "existing-event-id"
   volunteerId: "test-volunteer-1"
   organizationId: "test-org-1"
   status: ApplicationStatus.pending
   appliedAt: DateTime.now()
   ```

### **Test 2: Organization - Akceptacja zgłoszenia**
```dart
// W konsoli Dart/Flutter:
final useCase = sl<AcceptApplication>();
final result = await useCase('test-app-1');
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (application) => print('Success! Status: ${application.status}'),
);
// Oczekiwany wynik: status = accepted
```

### **Test 3: Organization - Oznaczenie obecności**
```dart
final useCase = sl<MarkAttendance>();
final params = MarkAttendanceParams(
  applicationId: 'test-app-1',
  hoursWorked: 4,
  feedback: 'Świetna robota!',
);
final result = await useCase(params);
// Oczekiwany wynik: status = attended, hoursWorked = 4
```

### **Test 4: Coordinator - Zatwierdzenie uczestnictwa**
```dart
final useCase = sl<ApproveParticipation>();
final params = ApproveParticipationParams(
  applicationId: 'test-app-1',
  coordinatorId: 'test-coordinator-1',
  notes: 'Zatwierdzone przez koordynatora',
);
final result = await useCase(params);
// Oczekiwany wynik: status = approved
```

### **Test 5: Coordinator - Generowanie certyfikatu**
```dart
final useCase = sl<GenerateCertificate>();
final params = GenerateCertificateParams(
  applicationId: 'test-app-1',
  coordinatorId: 'test-coordinator-1',
  coordinatorName: 'Jan Kowalski',
);
final result = await useCase(params);
// Oczekiwany wynik: 
// - application.status = completed
// - nowy Certificate z numerem
```

### **Test 6: Sprawdzenie w Isar**
Po każdym kroku sprawdź w Isar Inspector:
- `volunteer_application_model` collection
- `certificate_model` collection

---

## 📊 Co działa lokalnie (bez Firebase)?

### ✅ **Gotowe**
- [x] Tworzenie zgłoszeń (application)
- [x] Akceptacja/odrzucanie przez organizację
- [x] Oznaczanie obecności
- [x] Ocenianie wolontariuszy
- [x] Zatwierdzanie przez koordynatora
- [x] Generowanie certyfikatów
- [x] Statystyki organizacji
- [x] Statystyki koordynatora
- [x] Raporty miesięczne

### ⏳ **Do zrobienia (UI)**
- [ ] OrganizationBloc - rozszerzenie o aplikacje
- [ ] CoordinatorBloc - utworzenie
- [ ] ApplicationsListPage (organization)
- [ ] AttendanceMarkingPage (organization)
- [ ] PendingApprovalsPage (coordinator)
- [ ] GenerateCertificatePage (coordinator)

---

## 🔧 Troubleshooting

### Problem: "Application not found"
**Przyczyna**: Brak zgłoszenia w Isar  
**Rozwiązanie**: Dodaj ręcznie przez Isar Inspector lub stwórz przez `createApplication()`

### Problem: "Status nie zmienia się"
**Przyczyna**: Nieprawidłowy status początkowy  
**Rozwiązanie**: Sprawdź czy status pasuje do operacji:
- acceptApplication: pending → accepted
- markAttendance: accepted → attended
- approveParticipation: attended → approved
- generateCertificate: approved → completed

### Problem: "Certificate nie generuje się"
**Przyczyna**: Brak danych o wydarzeniu  
**Rozwiązanie**: Upewnij się że event istnieje w Isar

---

## 📝 Notatki developerskie

### Dependency Injection
Wszystkie klasy są dostępne przez:
```dart
import 'package:hack_volunteers/injection_container.dart';

// Organizations
final acceptApp = sl<AcceptApplication>();
final markAtt = sl<MarkAttendance>();
final rateVol = sl<RateVolunteer>();

// Coordinators
final approvePart = sl<ApproveParticipation>();
final genCert = sl<GenerateCertificate>();
final getStats = sl<GetCoordinatorStatistics>();
```

### Isar Collections
- `volunteer_application_model` - zgłoszenia
- `certificate_model` - certyfikaty
- `volunteer_event_model` - wydarzenia

### Status Flow
```
pending → accepted → attended → approved → completed
           ↓
        rejected
```

---

**Data utworzenia**: 2025-10-05  
**Status**: Backend GOTOWY ✅  
**Następny krok**: BLoCs + UI 🚀
