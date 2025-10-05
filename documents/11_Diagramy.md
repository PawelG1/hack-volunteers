# 11. Diagramy Architektury Systemu

**Dokument:** 11_Diagramy.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 11.1. Przegląd diagramów

Niniejszy dokument zawiera diagramy architektury systemu SmokPomaga zgodnie z wymaganiami UMK (Urząd Miasta Krakowa):

- **DARWA** - Diagram Architektury Wewnętrznej
- **DARSD** - Diagram Architektury Struktury Danych
- **DARPK** - Diagram Architektury Przepływu Komunikacji
- **DAPB** - Diagram Architektury Procesów Biznesowych

---

## 11.2. DARWA - Diagram Architektury Wewnętrznej

### 11.2.1. Architektura modułowa aplikacji

```
┌────────────────────────────────────────────────────────────────────┐
│                     APLIKACJA MOBILNA SMOKPOMAGA                    │
│                          (Flutter/Dart)                             │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌────────────────── PRESENTATION LAYER ──────────────────────┐   │
│  │                                                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │   │
│  │  │   PAGES      │  │   WIDGETS    │  │   BLoC STATES    │ │   │
│  │  │  (Ekrany)    │  │  (Komponenty)│  │ (State Mgmt)     │ │   │
│  │  ├──────────────┤  ├──────────────┤  ├──────────────────┤ │   │
│  │  │ LoginPage    │  │ EventCard    │  │ EventsBloc       │ │   │
│  │  │ RegisterPage │  │ CertCard     │  │ AuthBloc         │ │   │
│  │  │ Dashboard    │  │ AppBar       │  │ CertificatesBloc │ │   │
│  │  │ EventDetails │  │ Footer       │  │ ApplicationsBloc │ │   │
│  │  │ MapPage      │  │ Button       │  │ MapBloc          │ │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘ │   │
│  │                                                              │   │
│  │  ┌────────────────────────────────────────────────────────┐ │   │
│  │  │                    ROUTING (GoRouter)                   │ │   │
│  │  │  /login, /register, /volunteer-dashboard, /map, etc.   │ │   │
│  │  └────────────────────────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ↕ ↕ ↕                                  │
│  ┌────────────────── BUSINESS LOGIC LAYER ────────────────────┐   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │                    USE CASES                          │  │   │
│  │  │  (Przypadki użycia - logika biznesowa)               │  │   │
│  │  ├──────────────────────────────────────────────────────┤  │   │
│  │  │ GetEvents                                            │  │   │
│  │  │ GetEventDetails                                      │  │   │
│  │  │ ApplyToEvent                                         │  │   │
│  │  │ Login                                                │  │   │
│  │  │ Register                                             │  │   │
│  │  │ GetCertificates                                      │  │   │
│  │  │ GetApplications                                      │  │   │
│  │  │ ApproveApplication                                   │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │                    ENTITIES                           │  │   │
│  │  │  (Modele domenowe - czyste obiekty)                  │  │   │
│  │  ├──────────────────────────────────────────────────────┤  │   │
│  │  │ Event                                                │  │   │
│  │  │ Certificate                                          │  │   │
│  │  │ Application                                          │  │   │
│  │  │ User                                                 │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │         REPOSITORY INTERFACES (abstrakcje)            │  │   │
│  │  │ EventsRepository, AuthRepository, etc.               │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ↕ ↕ ↕                                  │
│  ┌────────────────────── DATA LAYER ──────────────────────────┐   │
│  │                                                              │   │
│  │  ┌────────────────────────────────────────────────────────┐ │   │
│  │  │          REPOSITORY IMPLEMENTATIONS                     │ │   │
│  │  │  (Implementacje repozytoriów)                          │ │   │
│  │  ├────────────────────────────────────────────────────────┤ │   │
│  │  │ EventsRepositoryImpl                                   │ │   │
│  │  │ AuthRepositoryImpl                                     │ │   │
│  │  │ CertificatesRepositoryImpl                             │ │   │
│  │  │ ApplicationsRepositoryImpl                             │ │   │
│  │  └────────────────────────────────────────────────────────┘ │   │
│  │                                                              │   │
│  │  ┌───────────────┐              ┌──────────────────────┐   │   │
│  │  │ LOCAL DATA    │              │  REMOTE DATA         │   │   │
│  │  │ SOURCE        │              │  SOURCE              │   │   │
│  │  │ (Isar DB)     │              │  (Mock/Future API)   │   │   │
│  │  ├───────────────┤              ├──────────────────────┤   │   │
│  │  │ EventsLocal   │              │ EventsRemote         │   │   │
│  │  │ CertsLocal    │              │ CertsRemote          │   │   │
│  │  │ AppsLocal     │              │ AppsRemote           │   │   │
│  │  │ UsersLocal    │              │ UsersRemote          │   │   │
│  │  └───────────────┘              └──────────────────────┘   │   │
│  │         ↓                                  ↓                │   │
│  │  ┌───────────────┐              ┌──────────────────────┐   │   │
│  │  │  DATA MODELS  │              │  DTO / JSON          │   │   │
│  │  │  (Isar @coll.)│              │  (Serialization)     │   │   │
│  │  └───────────────┘              └──────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              ↕ ↕ ↕                                  │
│  ┌──────────────────────── CORE LAYER ────────────────────────┐   │
│  │                                                              │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────────────┐   │   │
│  │  │  THEME     │  │   ERRORS   │  │   UTILS/HELPERS    │   │   │
│  │  │  (Colors,  │  │ (Failures, │  │  (Formatters,      │   │   │
│  │  │  Styles)   │  │ Exceptions)│  │   Converters)      │   │   │
│  │  └────────────┘  └────────────┘  └────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌──────────────────────────────────────────────────────┐  │   │
│  │  │       DEPENDENCY INJECTION (GetIt)                    │  │   │
│  │  │  Rejestracja wszystkich zależności                   │  │   │
│  │  └──────────────────────────────────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
├────────────────────────────────────────────────────────────────────┤
│                      WARSTWA PLATFORMOWA                            │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  ┌────────────┐  ┌────────────┐  ┌──────────────────────┐   │  │
│  │  │ Isar DB    │  │ OpenStreet │  │  Android Platform    │   │  │
│  │  │ (SQLite)   │  │ Map Tiles  │  │  (Permissions, etc.) │   │  │
│  │  └────────────┘  └────────────┘  └──────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

### 11.2.2. Moduły funkcjonalne

| Moduł | Odpowiedzialność | Komponenty kluczowe |
|-------|------------------|---------------------|
| **Auth** | Autoryzacja i rejestracja | LoginPage, RegisterPage, AuthBloc, AuthRepository |
| **Events** | Zarządzanie wydarzeniami | EventsListPage, EventDetailsPage, EventsBloc, EventsRepository |
| **Volunteers** | Panel wolontariusza | VolunteerDashboard, MyCertificatesPage, VolunteerBloc |
| **Organizations** | Panel organizacji | OrganizationDashboard, CreateEventPage, OrganizationBloc |
| **Coordinators** | Panel koordynatora UEK | CoordinatorDashboard, ApprovalPage, CoordinatorBloc |
| **Map** | Mapa wydarzeń | EventsMapPage, MapBloc, flutter_map integration |
| **Certificates** | Certyfikaty wolontariackie | CertificatesPage, CertificateCard, CertificatesBloc |
| **Applications** | Aplikacje na wydarzenia | ApplicationsList, ApplicationCard, ApplicationsBloc |

---

## 11.3. DARSD - Diagram Architektury Struktury Danych

### 11.3.1. Model logiczny bazy danych

```
┌─────────────────────────────────────────────────────────────────┐
│                         ISAR DATABASE                            │
│                      (Local NoSQL Storage)                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                        Collection: Users                          │
├──────────────────────────────────────────────────────────────────┤
│ PK: isarId (Id, auto)                                            │
│ UK: id (String, indexed)                                         │
│ UK: email (String, indexed)                                      │
├──────────────────────────────────────────────────────────────────┤
│ + name: String                                                   │
│ + role: String (enum: volunteer, organization, coordinator)      │
│ + hashedPassword: String                                         │
│ + phoneNumber: String?                                           │
│ + createdAt: DateTime                                            │
└──────────────────────────────────────────────────────────────────┘
                                   ↓ 1
                                   │
                         ┌─────────┴──────────┐
                         │                    │
                       * ↓                  * ↓
┌────────────────────────────────┐  ┌────────────────────────────────┐
│   Collection: Certificates     │  │   Collection: Applications     │
├────────────────────────────────┤  ├────────────────────────────────┤
│ PK: isarId (Id, auto)          │  │ PK: isarId (Id, auto)          │
│ UK: id (String, indexed)       │  │ UK: id (String, indexed)       │
│ FK: userId (String, indexed)   │  │ FK: userId (String, indexed)   │
├────────────────────────────────┤  │ FK: eventId (String, indexed)  │
│ + eventTitle: String           │  ├────────────────────────────────┤
│ + hoursCompleted: int          │  │ + status: String (enum)        │
│ + issueDate: DateTime          │  │   - pending                    │
│ + certificateUrl: String?      │  │   - approved                   │
│ + description: String          │  │   - rejected                   │
└────────────────────────────────┘  │ + appliedAt: DateTime          │
                                    │ + motivation: String           │
                                    └────────────────────────────────┘
                                                  ↑ *
                                                  │
                                                  │ 1
┌──────────────────────────────────────────────────────────────────┐
│                       Collection: Events                          │
├──────────────────────────────────────────────────────────────────┤
│ PK: isarId (Id, auto)                                            │
│ UK: id (String, indexed)                                         │
│ FK: organizationId (String, indexed)                             │
├──────────────────────────────────────────────────────────────────┤
│ + title: String                                                  │
│ + description: String                                            │
│ + date: DateTime (indexed)                                       │
│ + location: String                                               │
│ + latitude: double                                               │
│ + longitude: double                                              │
│ + volunteersNeeded: int                                          │
│ + volunteersApplied: int                                         │
│ + category: String                                               │
│ + imageUrl: String?                                              │
│ + requirements: String                                           │
│ + status: String (enum: upcoming, ongoing, completed, cancelled) │
│ + createdAt: DateTime                                            │
└──────────────────────────────────────────────────────────────────┘
```

### 11.3.2. Relacje między kolekcjami

```
Users (1) ──────< Applications (*)
   │
   └──────────────< Certificates (*)

Events (1) ─────< Applications (*)
```

### 11.3.3. Indeksy i optymalizacja

| Kolekcja | Pole | Typ indeksu | Cel |
|----------|------|-------------|-----|
| **Users** | `id` | Unique | Szybkie wyszukiwanie po ID |
| **Users** | `email` | Unique | Logowanie, walidacja unikalności |
| **Events** | `id` | Unique | Szybkie wyszukiwanie po ID |
| **Events** | `date` | Regular | Sortowanie, filtrowanie po dacie |
| **Events** | `organizationId` | Regular | Filtrowanie wydarzeń organizacji |
| **Certificates** | `userId` | Regular | Pobieranie certyfikatów użytkownika |
| **Applications** | `userId` | Regular | Pobieranie aplikacji użytkownika |
| **Applications** | `eventId` | Regular | Pobieranie aplikacji na wydarzenie |

### 11.3.4. Struktura danych w pamięci (Runtime)

```
┌──────────────────────────────────────────────────────────────┐
│                    BLoC STATE OBJECTS                         │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  EventsState                                                 │
│    ├─ EventsInitial                                          │
│    ├─ EventsLoading                                          │
│    ├─ EventsLoaded(events: List<Event>)                      │
│    └─ EventsError(message: String)                           │
│                                                               │
│  AuthState                                                   │
│    ├─ Unauthenticated                                        │
│    ├─ Authenticating                                         │
│    ├─ Authenticated(user: User)                              │
│    └─ AuthError(message: String)                             │
│                                                               │
│  CertificatesState                                           │
│    ├─ CertificatesLoading                                    │
│    ├─ CertificatesLoaded(certificates: List<Certificate>)    │
│    └─ CertificatesError(message: String)                     │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## 11.4. DARPK - Diagram Architektury Przepływu Komunikacji

### 11.4.1. Sekwencja: Logowanie użytkownika

```
┌────────┐   ┌──────────┐   ┌──────────┐   ┌────────────┐   ┌──────────┐   ┌──────────┐
│ User   │   │LoginPage │   │ AuthBloc │   │  Login     │   │   Auth   │   │  Local   │
│        │   │  (UI)    │   │ (State)  │   │  UseCase   │   │Repository│   │DataSource│
└────┬───┘   └────┬─────┘   └────┬─────┘   └─────┬──────┘   └────┬─────┘   └────┬─────┘
     │            │               │               │               │              │
     │ 1. Wpisuje│               │               │               │              │
     │ login i   │               │               │               │              │
     │ hasło     │               │               │               │              │
     ├──────────>│               │               │               │              │
     │            │               │               │               │              │
     │            │ 2. add(      │               │               │              │
     │            │    LoginEvent)│               │               │              │
     │            ├──────────────>│               │               │              │
     │            │               │               │               │              │
     │            │               │ 3. call()     │               │              │
     │            │               ├──────────────>│               │              │
     │            │               │               │               │              │
     │            │               │               │ 4. login()    │              │
     │            │               │               ├──────────────>│              │
     │            │               │               │               │              │
     │            │               │               │               │ 5. getUser() │
     │            │               │               │               ├─────────────>│
     │            │               │               │               │              │
     │            │               │               │               │ 6. User data │
     │            │               │               │               │<─────────────┤
     │            │               │               │               │              │
     │            │               │               │ 7. Right(User)│              │
     │            │               │               │<──────────────┤              │
     │            │               │               │               │              │
     │            │               │ 8. Right(User)│               │              │
     │            │               │<──────────────┤               │              │
     │            │               │               │               │              │
     │            │               │ 9. emit(      │               │              │
     │            │               │ Authenticated)│               │              │
     │            │               │               │               │              │
     │            │ 10. build()   │               │               │              │
     │            │   (new state) │               │               │              │
     │            │<──────────────┤               │               │              │
     │            │               │               │               │              │
     │ 11. Przekierowanie         │               │               │              │
     │     na dashboard           │               │               │              │
     │<───────────┤               │               │               │              │
     │            │               │               │               │              │
```

### 11.4.2. Sekwencja: Aplikowanie na wydarzenie

```
┌────────┐   ┌───────────┐   ┌──────────┐   ┌────────────┐   ┌──────────┐   ┌──────────┐
│ User   │   │EventDetail│   │ EventsBloc│  │ApplyToEvent│   │  Events  │   │  Local   │
│        │   │Page (UI)  │   │  (State)  │   │  UseCase   │   │Repository│   │DataSource│
└────┬───┘   └────┬──────┘   └────┬──────┘   └─────┬──────┘   └────┬─────┘   └────┬─────┘
     │            │               │                │               │              │
     │ 1. Klika  │               │                │               │              │
     │ "Aplikuj" │               │                │               │              │
     ├──────────>│               │                │               │              │
     │            │               │                │               │              │
     │            │ 2. add(       │                │               │              │
     │            │ ApplyToEvent) │                │               │              │
     │            ├──────────────>│                │               │              │
     │            │               │                │               │              │
     │            │               │ 3. call()      │               │              │
     │            │               ├───────────────>│               │              │
     │            │               │                │               │              │
     │            │               │                │ 4. apply()    │              │
     │            │               │                ├──────────────>│              │
     │            │               │                │               │              │
     │            │               │                │               │ 5. Create    │
     │            │               │                │               │ Application  │
     │            │               │                │               ├─────────────>│
     │            │               │                │               │              │
     │            │               │                │               │ 6. Success   │
     │            │               │                │               │<─────────────┤
     │            │               │                │               │              │
     │            │               │                │ 7. Right(void)│              │
     │            │               │                │<──────────────┤              │
     │            │               │                │               │              │
     │            │               │ 8. Right(void) │               │              │
     │            │               │<───────────────┤               │              │
     │            │               │                │               │              │
     │            │               │ 9. emit(       │               │              │
     │            │               │ ApplicationSuccess)            │              │
     │            │               │                │               │              │
     │            │ 10. Pokazuje  │                │               │              │
     │            │  SnackBar     │                │               │              │
     │            │  "Aplikowano!"│                │               │              │
     │<───────────┤               │                │               │              │
     │            │               │                │               │              │
```

### 11.4.3. Sekwencja: Ładowanie mapy wydarzeń

```
┌────────┐   ┌───────────┐   ┌──────────┐   ┌────────────┐   ┌──────────┐
│ User   │   │EventsMap  │   │ EventsBloc│  │ GetEvents  │   │  Events  │
│        │   │Page (UI)  │   │  (State)  │   │  UseCase   │   │Repository│
└────┬───┘   └────┬──────┘   └────┬──────┘   └─────┬──────┘   └────┬─────┘
     │            │               │                │               │
     │ 1. Otwiera│               │                │               │
     │ mapę      │               │                │               │
     ├──────────>│               │                │               │
     │            │               │                │               │
     │            │ 2. initState  │                │               │
     │            │ + LoadEvents  │                │               │
     │            ├──────────────>│                │               │
     │            │               │                │               │
     │            │               │ 3. call()      │               │
     │            │               ├───────────────>│               │
     │            │               │                │               │
     │            │               │                │ 4. getEvents()│
     │            │               │                ├──────────────>│
     │            │               │                │               │
     │            │               │                │ 5. List<Event>│
     │            │               │                │<──────────────┤
     │            │               │                │               │
     │            │               │ 6. Right(      │               │
     │            │               │    List<Event>)│               │
     │            │               │<───────────────┤               │
     │            │               │                │               │
     │            │               │ 7. emit(       │               │
     │            │               │ EventsLoaded)  │               │
     │            │               │                │               │
     │            │ 8. build()    │                │               │
     │            │ (Renderuje    │                │               │
     │            │  markery)     │                │               │
     │            │<──────────────┤                │               │
     │            │               │                │               │
     │ 9. Widzi   │               │                │               │
     │ wydarzenia │               │                │               │
     │ na mapie   │               │                │               │
     │<───────────┤               │                │               │
     │            │               │                │               │
```

---

## 11.5. DAPB - Diagram Architektury Procesów Biznesowych

### 11.5.1. Proces: Rejestracja i pierwsza aplikacja wolontariusza

```
START
  │
  ├─> [Wolontariusz otwiera aplikację]
  │
  ├─> [Wybiera "Zarejestruj się"]
  │
  ├─> [Wypełnia formularz:]
  │     • Imię i nazwisko
  │     • Email
  │     • Hasło
  │     • Rola: Wolontariusz
  │
  ├─> [Walidacja danych]
  │     │
  │     ├─> [Błąd?] ──> [Pokazuje komunikat] ──> [Powrót do formularza]
  │     │
  │     └─> [OK] ──> [Zapisuje użytkownika w bazie]
  │
  ├─> [Automatyczne logowanie]
  │
  ├─> [Przekierowanie na Volunteer Dashboard]
  │
  ├─> [Wolontariusz przegląda wydarzenia]
  │     • Lista wydarzeń
  │     • Filtrowanie po kategorii/dacie
  │     • Mapa wydarzeń
  │
  ├─> [Wybiera interesujące wydarzenie]
  │
  ├─> [Przegląda szczegóły:]
  │     • Opis
  │     • Data i lokalizacja
  │     • Wymagania
  │     • Liczba miejsc
  │
  ├─> [Klika "Aplikuj"]
  │
  ├─> [Wypełnia formularz aplikacyjny:]
  │     • Motywacja (opcjonalnie)
  │
  ├─> [Zapisuje aplikację]
  │     • Status: "pending"
  │     • Data aplikacji: now()
  │
  ├─> [Potwierdzenie: "Aplikowano pomyślnie!"]
  │
  ├─> [Wolontariusz czeka na zatwierdzenie]
  │
END
```

### 11.5.2. Proces: Zarządzanie wydarzeniem przez organizację

```
START
  │
  ├─> [Organizacja loguje się]
  │
  ├─> [Otwiera Organization Dashboard]
  │
  ├─> [Wybiera "Stwórz nowe wydarzenie"]
  │
  ├─> [Wypełnia formularz wydarzenia:]
  │     • Tytuł
  │     • Opis
  │     • Data i godzina
  │     • Lokalizacja (adres + mapa)
  │     • Liczba wolontariuszy
  │     • Kategoria
  │     • Wymagania
  │     • Zdjęcie (opcjonalnie)
  │
  ├─> [Walidacja]
  │     │
  │     ├─> [Błąd?] ──> [Pokazuje komunikat] ──> [Powrót do formularza]
  │     │
  │     └─> [OK] ──> [Zapisuje wydarzenie w bazie]
  │                    • Status: "upcoming"
  │
  ├─> [Wydarzenie widoczne dla wolontariuszy]
  │
  ├─> [Wolontariusze aplikują] ──> [Aplikacje w bazie]
  │
  ├─> [Organizacja przegląda aplikacje]
  │     • Lista aplikantów
  │     • Profile wolontariuszy
  │     • Motywacja
  │
  ├─> [Dla każdej aplikacji:]
  │     │
  │     ├─> [Akceptuje] ──> [Status: "approved"]
  │     │                   [Email/powiadomienie do wolontariusza]
  │     │
  │     └─> [Odrzuca] ──> [Status: "rejected"]
  │                       [Email/powiadomienie do wolontariusza]
  │
  ├─> [Wydarzenie odbywa się]
  │
  ├─> [Organizacja zmienia status na "completed"]
  │
  ├─> [System generuje certyfikaty dla zatwierdzonych wolontariuszy]
  │     • Tytuł wydarzenia
  │     • Data
  │     • Liczba godzin
  │
  ├─> [Certyfikaty dostępne w profilu wolontariusza]
  │
END
```

### 11.5.3. Proces: Zatwierdzanie certyfikatów przez koordynatora UEK

```
START
  │
  ├─> [Koordynator UEK loguje się]
  │
  ├─> [Otwiera Coordinator Dashboard]
  │
  ├─> [Widzi listę studentów UEK]
  │     • Imię i nazwisko
  │     • Email
  │     • Liczba godzin wolontariatu
  │     • Status weryfikacji
  │
  ├─> [Wybiera studenta do weryfikacji]
  │
  ├─> [Przegląda certyfikaty studenta:]
  │     • Wydarzenia, w których uczestniczył
  │     • Daty
  │     • Liczba godzin każdego wydarzenia
  │     • PDF certyfikatów (jeśli dostępne)
  │
  ├─> [Weryfikuje autentyczność]
  │     │
  │     ├─> [Potwierdza] ──> [Status: "verified"]
  │     │                    [Student może używać certyfikatu oficjalnie]
  │     │
  │     └─> [Odrzuca] ──> [Status: "unverified"]
  │                       [Powiadomienie do studenta z powodem]
  │
  ├─> [Eksportuje raporty:]
  │     • Studenci z X+ godzinami
  │     • Studenci zweryfikowani
  │     • Statystyki miesięczne/roczne
  │
  ├─> [Przesyła raporty do dziekanatu UEK]
  │
END
```

### 11.5.4. Przepływ danych w systemie (High-Level)

```
┌────────────────────────────────────────────────────────────────────┐
│                    PRZEPŁYW DANYCH W SYSTEMIE                       │
└────────────────────────────────────────────────────────────────────┘

   WOLONTARIUSZ                ORGANIZACJA              KOORDYNATOR
        │                           │                         │
        │ 1. Rejestracja            │                         │
        ├─────────────────────────> │                         │
        │    (User created)         │                         │
        │                           │                         │
        │ 2. Przegląda wydarzenia   │                         │
        │ <─────────────────────────┤                         │
        │    (List<Event>)          │                         │
        │                           │                         │
        │ 3. Aplikuje               │                         │
        ├─────────────────────────> │                         │
        │    (Application created)  │                         │
        │                           │                         │
        │                           │ 4. Przegląda aplikacje  │
        │                           │ <───────────────────────┤
        │                           │    (List<Application>)  │
        │                           │                         │
        │                           │ 5. Zatwierdza           │
        │                           ├────────────────────────>│
        │                           │    (status: approved)   │
        │                           │                         │
        │ 6. Otrzymuje certyfikat   │                         │
        │ <─────────────────────────┤                         │
        │    (Certificate created)  │                         │
        │                           │                         │
        │ 7. Prosi o weryfikację    │                         │
        ├───────────────────────────┼────────────────────────>│
        │                           │    (Student UEK)        │
        │                           │                         │
        │                           │                         │ 8. Weryfikuje
        │                           │                         │    certyfikaty
        │                           │                         │
        │ 9. Certyfikat zweryfikowany                         │
        │ <───────────────────────────────────────────────────┤
        │    (status: verified)                               │
        │                           │                         │
```

### 11.5.5. Stany obiektów biznesowych

**Event Status Flow:**
```
created → upcoming → ongoing → completed → archived
                        │
                        └──> cancelled
```

**Application Status Flow:**
```
pending → approved → attended → certified
   │
   └──> rejected
```

**Certificate Status Flow:**
```
issued → unverified → verified
```

**User States:**
```
registered → active → inactive → archived
```

---

## 11.6. Diagram komunikacji z zewnętrznymi serwisami

### 11.6.1. Integracje zewnętrzne

```
┌──────────────────────────────────────────────────────────────┐
│                    APLIKACJA SMOKPOMAGA                       │
└────────────────────────┬─────────────────────────────────────┘
                         │
           ┌─────────────┼─────────────┐
           │             │             │
           ↓             ↓             ↓
    ┌────────────┐ ┌────────────┐ ┌────────────┐
    │ OpenStreet │ │   Future   │ │  Future    │
    │ Map Tiles  │ │   Backend  │ │  Email     │
    │   (HTTP)   │ │   API      │ │  Service   │
    └────────────┘ └────────────┘ └────────────┘
         │              │              │
         │              │              │
         ↓              ↓              ↓
    [Kafelki mapy] [CRUD API]    [Notifications]
```

### 11.6.2. Przyszłe integracje (planowane)

- **Firebase Cloud Messaging** - Push notifications
- **Firebase Authentication** - OAuth (Google, Facebook)
- **Cloudinary / AWS S3** - Przechowywanie zdjęć
- **SendGrid / Mailgun** - Email notifications
- **Analytics (Firebase/Mixpanel)** - Tracking user behavior

---

## 11.7. Diagram bezpieczeństwa

### 11.7.1. Warstwy bezpieczeństwa

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Warstwa UI                                                │
│    • Input validation (forms)                               │
│    • XSS prevention (Flutter safe by design)                │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Warstwa BLoC                                              │
│    • Business logic validation                              │
│    • State immutability (Equatable)                         │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Warstwa Repository                                        │
│    • Data sanitization                                      │
│    • Error handling (Either<Failure, T>)                    │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Warstwa Data Source                                       │
│    • Password hashing (obecnie mock, future: bcrypt)        │
│    • Secure storage (Isar local, future: encrypted)         │
│    • HTTPS only (dla remote API)                            │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. Warstwa platformowa                                       │
│    • Android permissions                                    │
│    • Secure APK signing (Release)                           │
│    • ProGuard/R8 obfuscation (opcjonalne)                   │
└─────────────────────────────────────────────────────────────┘
```

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga  
**Norma:** Wymagania UMK dla dokumentacji systemów IT
