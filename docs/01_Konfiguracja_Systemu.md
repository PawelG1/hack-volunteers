# 1. Opis Konfiguracji Systemu

**Dokument:** 01_Konfiguracja_Systemu.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 1.1. Wprowadzenie

Niniejszy dokument opisuje konfigurację aplikacji SmokPomaga, wykaz wdrożonych elementów, powiązania między nimi oraz implementację w środowisku docelowym.

## 1.2. Wykaz wdrożonych elementów

### 1.2.1. Aplikacja mobilna

| Element | Szczegóły |
|---------|-----------|
| **Nazwa** | SmokPomaga |
| **Identyfikator pakietu** | com.example.hack_volunteers |
| **Platforma** | Android |
| **Wersja docelowa SDK** | 36 (Android 16) |
| **Minimalna wersja SDK** | 21 (Android 5.0 Lollipop) |
| **Architektura** | ARM64-v8a, ARMv7, x86, x86_64 |
| **Rozmiar APK** | ~30.5 MB (release) |

### 1.2.2. Komponenty aplikacji

#### Frontend
- **Framework:** Flutter 3.9.0+
- **Język programowania:** Dart 3.0+
- **UI Framework:** Material Design 3
- **Routing:** go_router 14.8.1
- **State Management:** flutter_bloc 8.1.6

#### Baza danych lokalna
- **Silnik:** Isar 3.1.0+1
- **Typ:** NoSQL (obiektowa baza danych)
- **Lokalizacja:** Pamięć wewnętrzna urządzenia
- **Szyfrowanie:** Brak (dane lokalne)

#### Biblioteki zewnętrzne
- **Mapy:** flutter_map 7.0.2 + OpenStreetMap
- **Lokalizacja:** latlong2 0.9.1
- **Wybór zdjęć:** image_picker 1.1.2
- **Formatowanie dat:** intl 0.19.0
- **Dependency Injection:** get_it 7.7.0

## 1.3. Struktura katalogów

```
hack_volunteers/
├── android/                      # Konfiguracja Android
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── kotlin/
│   │   └── build.gradle.kts
│   ├── build.gradle.kts
│   └── gradle.properties
│
├── assets/                       # Zasoby statyczne
│   └── images/
│       ├── logo.png
│       ├── mlody_krakow_horizontal.png
│       ├── mlody_krakow_vertical.png
│       └── events/               # Zdjęcia przykładowych wydarzeń
│
├── lib/                          # Kod źródłowy Dart
│   ├── main.dart                 # Punkt wejścia aplikacji
│   ├── injection_container.dart  # Dependency Injection
│   ├── core/                     # Funkcjonalności wspólne
│   │   ├── navigation/           # Routing
│   │   ├── theme/                # Motywy i kolory
│   │   ├── utils/                # Narzędzia pomocnicze
│   │   └── widgets/              # Wspólne widgety
│   │
│   └── features/                 # Moduły funkcjonalne
│       ├── auth/                 # Autoryzacja
│       ├── volunteers/           # Moduł wolontariuszy
│       ├── organizations/        # Moduł organizacji
│       ├── coordinators/         # Moduł koordynatorów
│       ├── events/               # Zarządzanie wydarzeniami
│       ├── map/                  # Mapa wydarzeń
│       ├── search/               # Wyszukiwanie
│       ├── calendar/             # Kalendarz
│       └── local_storage/        # Przechowywanie lokalne
│
├── test/                         # Testy jednostkowe
│
└── docs/                         # Dokumentacja
```

## 1.4. Powiązania między komponentami

### 1.4.1. Diagram powiązań

```
┌─────────────────────────────────────────────────────┐
│              Warstwa Prezentacji                    │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐        │
│  │Wolontariusz  │Organizacja│ │Koordynator│        │
│  │ Dashboard│  │ Dashboard│  │ Dashboard │        │
│  └─────┬────┘  └─────┬────┘  └─────┬─────┘        │
└────────┼─────────────┼─────────────┼──────────────┘
         │             │             │
         └─────────────┴─────────────┘
                       │
         ┌─────────────▼─────────────┐
         │      Warstwa BLoC         │
         │  (State Management)       │
         │  - EventsBloc            │
         │  - OrganizationBloc      │
         │  - CoordinatorBloc       │
         │  - VolunteerCertBloc     │
         └─────────────┬─────────────┘
                       │
         ┌─────────────▼─────────────┐
         │    Warstwa Biznesowa      │
         │      (Use Cases)          │
         │  - GetEvents              │
         │  - ApplyToEvent           │
         │  - IssueCertificate       │
         └─────────────┬─────────────┘
                       │
         ┌─────────────▼─────────────┐
         │   Warstwa Repozytoriów    │
         │    (Repositories)         │
         └─────────────┬─────────────┘
                       │
         ┌─────────────▼─────────────┐
         │   Warstwa Danych          │
         │  ┌──────────┬──────────┐  │
         │  │  Isar DB │ Remote   │  │
         │  │  (Local) │ (Mock)   │  │
         │  └──────────┴──────────┘  │
         └───────────────────────────┘
```

## 1.5. Konfiguracja środowiska Android

### 1.5.1. AndroidManifest.xml

**Lokalizacja:** `android/app/src/main/AndroidManifest.xml`

**Uprawnienia:**
- `INTERNET` - Dostęp do internetu (mapy, API)
- `ACCESS_NETWORK_STATE` - Sprawdzanie stanu sieci
- `READ_EXTERNAL_STORAGE` - Odczyt zdjęć (SDK ≤32)
- `READ_MEDIA_IMAGES` - Odczyt zdjęć (SDK ≥33)

**Ustawienia aplikacji:**
- `usesCleartextTraffic="true"` - Dozwolony HTTP (OpenStreetMap)
- `hardwareAccelerated="true"` - Akceleracja sprzętowa
- `largeHeap="true"` - Większy heap pamięci

### 1.5.2. build.gradle.kts (app)

**Lokalizacja:** `android/app/build.gradle.kts`

**Konfiguracja:**
```kotlin
compileSdk = 36
targetSdk = 36
minSdk = 21
multiDexEnabled = true
```

**Pluginy:**
- com.android.application
- kotlin-android
- dev.flutter.flutter-gradle-plugin

### 1.5.3. gradle.properties

**Lokalizacja:** `android/gradle.properties`

**Optymalizacje:**
- JVM args: -Xmx4G -XX:MaxMetaspaceSize=2G
- AndroidX: enabled
- Gradle daemon: enabled
- Parallel execution: enabled
- Build cache: enabled

## 1.6. Konfiguracja Isar Database

### 1.6.1. Parametry bazy danych

| Parametr | Wartość |
|----------|---------|
| **Nazwa bazy** | hack_volunteers.isar |
| **Lokalizacja** | ApplicationDocumentsDirectory |
| **Schemat** | Wersja 1 |
| **Inspector** | Włączony (debug mode) |
| **Kompresja** | Włączona |

### 1.6.2. Kolekcje (Collections)

1. **VolunteerEventIsarModel** - Wydarzenia wolontariackie
2. **Certificate** - Certyfikaty
3. **VolunteerApplication** - Aplikacje wolontariuszy
4. **UserIsarModel** - Dane użytkowników

## 1.7. Konfiguracja nawigacji

### 1.7.1. Router (go_router)

**Lokalizacja:** `lib/core/navigation/app_router.dart`

**Główne trasy:**
- `/` - Ekran powitalny
- `/login` - Logowanie
- `/register` - Rejestracja
- `/volunteer` - Dashboard wolontariusza
- `/organization` - Dashboard organizacji
- `/coordinator` - Dashboard koordynatora

### 1.7.2. Role użytkowników

- **volunteer** - Wolontariusz
- **organization** - Organizacja pozarządowa
- **schoolCoordynator** - Koordynator szkolny

## 1.8. Konfiguracja map

### 1.8.1. Provider kafelków

| Parametr | Wartość |
|----------|---------|
| **Provider** | OpenStreetMap |
| **URL Template** | https://tile.openstreetmap.org/{z}/{x}/{y}.png |
| **Max Zoom** | 19 |
| **User-Agent** | SmokPomaga/1.0 |

### 1.8.2. Domyślna lokalizacja

- **Miasto:** Kraków
- **Współrzędne:** 50.0647°N, 19.9450°E
- **Zoom** początkowy: 13

## 1.9. Integracja z systemem operacyjnym

### 1.9.1. Android Intents

- **ACTION_MAIN** - Uruchomienie aplikacji
- **ACTION_PROCESS_TEXT** - Przetwarzanie tekstu

### 1.9.2. Notifications

- Obecnie nieaktywne (zaplanowane w przyszłości)

## 1.10. Bezpieczeństwo

### 1.10.1. Signing Config

**Typ:** Debug signing (deweloperski)
**Uwaga:** W wersji produkcyjnej wymagany jest właściwy keystore

### 1.10.2. Obfuskacja

**Release build:**
- minifyEnabled: false
- shrinkResources: false

**Uwaga:** Można włączyć dla dodatkowego bezpieczeństwa

## 1.11. Dependency Injection

**Framework:** GetIt 7.7.0

**Zarejestrowane serwisy:**
- EventsRepository
- OrganizationRepository
- CoordinatorRepository
- VolunteerRepository
- IsarDataSource
- EventsBloc
- OrganizationBloc
- CoordinatorBloc

**Lokalizacja:** `lib/injection_container.dart`

## 1.12. Parametry wydajności

| Parametr | Wartość |
|----------|---------|
| **Rendering engine** | Impeller (Vulkan) |
| **Frame rate** | 60 FPS |
| **Heap size** | 4GB (Gradle) |
| **MultiDex** | Włączony |

## 1.13. Wersjonowanie

| Właściwość | Wartość |
|------------|---------|
| **Version name** | 1.0.0 |
| **Version code** | 1 |
| **Build mode** | Release |

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
