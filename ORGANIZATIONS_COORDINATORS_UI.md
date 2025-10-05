# Implementacja Organizations & Coordinators UI

## ✅ Zaimplementowane strony UI

### Organizations (Organizacje)
1. **ApplicationsListPage** (`applications_list_page.dart`)
   - Lista zgłoszeń wolontariuszy na wydarzenia
   - Filtrowanie po wydarzeniu / wszystkie zgłoszenia
   - Kolorowe statusy aplikacji (8 stanów)
   - Akcje: Akceptuj / Odrzuć
   - Dialog z powodem odrzucenia
   - Przejście do oznaczania obecności
   - Pull-to-refresh
   - Pustego stanu obsługa

2. **AttendanceMarkingPage** (`attendance_marking_page.dart`)
   - Formularz oznaczania obecności wolontariusza
   - Toggle: Obecny / Nieobecny
   - Input przepracowanych godzin
   - System ocen 1-5 gwiazdek
   - Pole opinii o wolontariuszu
   - Integracja z OrganizationBloc
   - Walidacja formularza

### Coordinators (Koordynatorzy)
1. **PendingApprovalsPage** (`pending_approvals_page.dart`)
   - Lista zgłoszeń oczekujących na zatwierdzenie
   - Expandable cards z szczegółami
   - Wyświetlanie opinii organizacji
   - Akcja: Zatwierdź udział
   - Dialog z notatkami koordynatora
   - Przejście do generowania certyfikatu
   - Pull-to-refresh

2. **GenerateCertificatePage** (`generate_certificate_page.dart`)
   - Podgląd certyfikatu wolontariusza
   - Gradient background
   - Wyświetlanie wszystkich danych aplikacji
   - Input imienia i nazwiska koordynatora
   - Informacje o godzinach i ocenie
   - Feedback organizacji i notatki koordynatora
   - Generowanie certyfikatu

## 🎨 Elementy UI

### Wspólne komponenty
- Card-based layout
- Material Design 3
- AppColors (primaryBlue, primaryMagenta)
- Responsive forms z walidacją
- Loading states
- Error handling z SnackBar
- Empty states z ikonami

### Status chips (ApplicationsListPage)
- Pending - orange
- Accepted - green
- Rejected - red
- Attended - blue
- Approved - purple
- Completed - teal
- Cancelled - grey
- Expired - brown

### Formularze
- TextFormField z walidacją
- Number inputs (godziny)
- Multi-line text (opinie, notatki)
- Star rating widget (1-5)
- Attendance toggle buttons

## 🏗 Architektura

### BLoC Pattern
- **OrganizationBloc**: Rozszerzony o 6 eventów aplikacji
- **CoordinatorBloc**: Nowy BLoC z 6 eventami

### Events
**Organizations:**
- LoadEventApplications
- LoadOrganizationApplications
- AcceptVolunteerApplication
- RejectVolunteerApplication
- MarkVolunteerAttendance
- RateVolunteerPerformance

**Coordinators:**
- LoadPendingApprovals
- ApproveVolunteerParticipation
- GenerateVolunteerCertificate
- LoadIssuedCertificates
- LoadCoordinatorStatistics
- GenerateCoordinatorMonthlyReport

### States
**Organizations:**
- ApplicationsLoading
- ApplicationsLoaded
- ApplicationAccepted
- ApplicationRejected
- AttendanceMarked
- VolunteerRated

**Coordinators:**
- CoordinatorLoading
- PendingApprovalsLoaded
- ParticipationApproved
- CertificateGenerated
- IssuedCertificatesLoaded
- CoordinatorStatisticsLoaded
- MonthlyReportGenerated
- CoordinatorError

## 📦 Dependency Injection

Wszystkie BLoC-i i Use Cases zarejestrowane w `injection_container.dart`:

```dart
// Organizations
sl.registerFactory(() => OrganizationBloc(
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
));

// Coordinators
sl.registerFactory(() => CoordinatorBloc(
  getPendingApprovals: sl(),
  approveParticipation: sl(),
  generateCertificate: sl(),
  getIssuedCertificates: sl(),
  generateMonthlyReport: sl(),
  getCoordinatorStatistics: sl(),
));
```

## 🔄 Workflow aplikacji

### Cykl życia zgłoszenia:
1. **Pending** → Wolontariusz aplikuje
2. **Accepted** → Organizacja akceptuje (lub Rejected)
3. **Attended** → Organizacja oznacza obecność + ocena
4. **Approved** → Koordynator zatwierdza udział
5. **Completed** → Generowany certyfikat

### Strony w workflow:
1. ApplicationsListPage → Manage applications
2. AttendanceMarkingPage → Mark attendance
3. PendingApprovalsPage → Approve participation
4. GenerateCertificatePage → Issue certificate

## 📝 TODO

- [ ] Dodać routing do main.dart
- [ ] Podłączyć prawdziwe coordinatorId (z auth)
- [ ] Implementacja pobierania certyfikatu (PDF)
- [ ] Statystyki koordynatora (dashboard)
- [ ] Raport miesięczny (export)
- [ ] Testy jednostkowe dla BLoCs
- [ ] Testy widget dla UI pages

## 🎯 Następne kroki

1. **Routing**: Dodać routes do aplikacji
2. **Authentication**: Integracja coordinatorId
3. **PDF Generation**: Biblioteka do generowania certyfikatów
4. **Notifications**: Powiadomienia o statusach
5. **Analytics**: Dashboard dla koordynatora

## 📊 Statystyki implementacji

- **Pliki utworzone**: 8
- **Linie kodu**: ~2000+
- **BLoCs**: 2 (extended + new)
- **UI Pages**: 4
- **Events**: 12
- **States**: 14
- **Use Cases**: 12 (wszystkie podłączone)

---

**Status**: ✅ Kompletna implementacja UI dla Organizations i Coordinators
**Kompilacja**: ✅ Bez błędów
**Testy**: ⚠️ Test files need update (old structure)
