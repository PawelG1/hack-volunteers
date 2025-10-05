# 18. Historia Zmian (Changelog)

**Dokument:** 18_Changelog.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 18.1. Format

Changelog zgodny ze standardem [Keep a Changelog](https://keepachangelog.com/pl/1.0.0/) i [Semantic Versioning](https://semver.org/lang/pl/).

**Typy zmian:**
- **Added** - nowe funkcjonalności
- **Changed** - zmiany w istniejących funkcjonalnościach
- **Deprecated** - funkcjonalności wycofywane w przyszłości
- **Removed** - usunięte funkcjonalności
- **Fixed** - poprawki błędów
- **Security** - poprawki bezpieczeństwa

---

## 18.2. [1.0.0] - 2025-10-05 (CURRENT)

### Added
- **Moduł autoryzacji:**
  - Rejestracja użytkowników (wolontariusz, organizacja, koordynator)
  - Logowanie z walidacją email/hasło
  - Trzy role użytkowników z różnymi uprawnieniami
  
- **Dashboard dla wolontariuszy:**
  - Przeglądanie listy wydarzeń
  - Filtrowanie wydarzeń po kategorii i statusie
  - Aplikowanie na wydarzenia
  - Przeglądanie własnych certyfikatów
  - Podgląd statusu aplikacji

- **Dashboard dla organizacji:**
  - Tworzenie nowych wydarzeń
  - Edycja istniejących wydarzeń
  - Zarządzanie aplikacjami (akceptacja/odrzucenie)
  - Generowanie certyfikatów dla uczestników
  - Statystyki wydarzeń

- **Dashboard dla koordynatora UEK:**
  - Przeglądanie studentów UEK
  - Weryfikacja certyfikatów
  - Eksport raportów (CSV/PDF)
  - Statystyki godzin wolontariatu

- **Mapa wydarzeń:**
  - Interaktywna mapa OpenStreetMap
  - Markery wydarzeń z informacjami
  - Centrowanie na Kraków (50.0647°N, 19.9450°E)
  - Zoom i nawigacja

- **System certyfikatów:**
  - Automatyczne generowanie certyfikatów po zakończeniu wydarzenia
  - Wyświetlanie liczby przepracowanych godzin
  - Historia wszystkich certyfikatów użytkownika

- **Baza danych Isar:**
  - 4 kolekcje: Events, Certificates, Applications, Users
  - Indeksy na kluczowych polach
  - Transakcje ACID
  - Seed data (17 wydarzeń, 2 certyfikaty, 2 aplikacje)

- **UI/UX:**
  - Material Design 3
  - Responsywny layout (portrait/landscape)
  - Stopka "Młody Kraków" na 7 kluczowych stronach
  - Kolorowe karty wydarzeń
  - Loading states i error handling

- **Architektura:**
  - Clean Architecture (3 warstwy)
  - BLoC pattern dla state management
  - Dependency Injection (GetIt)
  - Repository pattern
  - Use Cases dla logiki biznesowej

### Changed
- Zaktualizowano Android compileSdk z 34 do 36
- Zaktualizowano Gradle do wersji 8.12
- Zmieniono domyślną lokalizację mapy na centrum Krakowa

### Fixed
- Naprawiono błąd release build z `android:attr/lStar` (isar_flutter_libs)
- Naprawiono szare tło mapy (brak permission INTERNET)
- Naprawiono crash przy ładowaniu wydarzeń z null imageUrl
- Naprawiono problem z multiDex na starszych urządzeniach Android

### Security
- Dodano hashowanie haseł (mock, future: bcrypt)
- Dodano walidację input w formularzach
- Zabezpieczono przed SQL injection (Isar NoSQL)

---

## 18.3. [0.2.0] - 2025-09-20 (Development)

### Added
- Podstawowa struktura projektu Flutter
- Konfiguracja Clean Architecture
- Setup Isar database
- Routing z go_router
- BLoC setup dla Auth
- Mock data sources

### Changed
- Migracja z Provider na BLoC

### Fixed
- Hot reload issues w trybie debug

---

## 18.4. [0.1.0] - 2025-09-01 (Initial)

### Added
- Inicjalizacja projektu Flutter 3.9.0
- Podstawowy scaffold aplikacji
- Android i iOS setup
- Git repository initialization
- README.md z opisem projektu

---

## 18.5. Roadmap (Planowane wersje)

### [1.1.0] - Planowane Q4 2025

#### Added
- **Backend API integration:**
  - REST API dla wszystkich operacji
  - JWT authentication
  - Synchronizacja offline → online
  
- **Push notifications:**
  - Firebase Cloud Messaging
  - Powiadomienia o akceptacji aplikacji
  - Przypomnienia o wydarzeniach

- **Obrazy i media:**
  - Upload zdjęć wydarzeń (Cloudinary/S3)
  - Avatar użytkownika
  - Galeria zdjęć z wydarzeń

- **Certyfikaty PDF:**
  - Generowanie PDF z certyfikatami
  - Pobieranie i udostępnianie
  - Watermark z logo UEK/Młody Kraków

- **Wyszukiwanie:**
  - Full-text search wydarzeń
  - Filtrowanie po lokalizacji (radius)
  - Sortowanie po popularności

#### Changed
- Przeprojektowanie UI dashboardów
- Optymalizacja wydajności mapy

#### Fixed
- TBD (bugfixy z 1.0.0)

---

### [1.2.0] - Planowane Q1 2026

#### Added
- **OAuth logowanie:**
  - Google Sign-In
  - Facebook Login
  - Apple Sign-In (iOS)

- **Chat/Messaging:**
  - Komunikacja wolontariusz ↔ organizacja
  - Powiadomienia o nowych wiadomościach

- **Oceny i recenzje:**
  - Wolontariusze mogą oceniać wydarzenia (1-5 gwiazdek)
  - Organizacje mogą oceniać wolontariuszy
  - Wyświetlanie średniej oceny

- **Gamification:**
  - Badges za osiągnięcia (10 godzin, 50 godzin, 100 godzin)
  - Ranking wolontariuszy (leaderboard)
  - Challenges i questy

#### Changed
- Nowy theme (Material You dynamic colors)
- Refaktoryzacja architektury bazy danych

---

### [1.3.0] - Planowane Q2 2026

#### Added
- **iOS version:**
  - Port aplikacji na iOS
  - Publikacja w App Store
  - TestFlight beta

- **Web version:**
  - Flutter Web deployment
  - Responsive design dla desktop
  - PWA support

- **Integracje zewnętrzne:**
  - Integracja z kalendarzem Google/Apple
  - Export do LinkedIn (certyfikaty)
  - Udostępnianie na social media

- **Analytics:**
  - Google Analytics / Mixpanel
  - Tracking user behavior
  - A/B testing

---

### [2.0.0] - Planowane Q3 2026

#### Added
- **AI/ML features:**
  - Rekomendacje wydarzeń (personalizowane)
  - Auto-tagging zdjęć
  - Chatbot pomocniczy

- **Multi-language:**
  - Obsługa języka angielskiego
  - Lokalizacja dla międzynarodowych wolontariuszy

- **Enterprise features:**
  - White-label dla innych miast
  - API dla integracji z systemami UEK
  - Advanced reporting dla koordynatorów

#### Changed
- Przeprojektowanie całego UI (Design System 2.0)
- Nowa architektura mikroserwisowa (backend)

---

## 18.6. Wersje beta i testowe

### Beta Versions

| Wersja | Data | Testerzy | Feedback |
|--------|------|----------|----------|
| 1.0.0-beta.1 | 2025-09-25 | 10 osób (UEK) | Pozytywny, drobne bugi |
| 1.0.0-beta.2 | 2025-09-30 | 20 osób (UEK + organizacje) | Poprawki UI, dodano więcej wydarzeń seed |
| 1.0.0-rc.1 | 2025-10-03 | 50 osób (public beta) | Finalne testy przed release |

---

## 18.7. Known Issues (Znane problemy)

### [1.0.0] Current Issues

| ID | Priorytet | Opis | Workaround | ETA Fix |
|----|-----------|------|------------|---------|
| #001 | Low | Mapka czasem wolno ładuje kafelki | Poczekaj kilka sekund | 1.1.0 |
| #002 | Low | Brak animacji przejść między ekranami | - | 1.1.0 |
| #003 | Medium | Certyfikaty nie mają PDF (tylko widok w app) | Screenshot | 1.1.0 |
| #004 | Low | Brak dark mode | Użyj jasnego motywu | 1.2.0 |

---

## 18.8. Deprecations (Funkcjonalności wycofywane)

### Planowane do usunięcia

| Funkcja | Wersja deprecation | Wersja usunięcia | Alternatywa |
|---------|-------------------|------------------|-------------|
| Mock DataSources | 1.1.0 | 1.2.0 | Real API |
| Local-only storage | 1.1.0 | 2.0.0 | Cloud sync |

---

## 18.9. Migration Guides

### Z wersji 0.x do 1.0.0

**Nie dotyczy** - pierwsza publiczna wersja.

### Z wersji 1.0.0 do 1.1.0 (planowane)

**Kroki migracji:**

1. **Backup danych lokalnych:**
   ```bash
   # Aplikacja automatycznie zbackupuje bazę Isar
   ```

2. **Aktualizacja aplikacji:**
   - Pobierz nową wersję z Google Play
   - Przy pierwszym uruchomieniu nastąpi migracja danych

3. **Synchronizacja z backendem:**
   - Zaloguj się ponownie
   - Dane lokalne zostaną zsynchronizowane z serwerem

4. **Weryfikacja:**
   - Sprawdź czy wszystkie wydarzenia są widoczne
   - Sprawdź certyfikaty

**Uwaga:** Downgrade z 1.1.0 do 1.0.0 **nie będzie możliwy** bez utraty danych!

---

## 18.10. Contributors (Kontrybutorzy)

### Core Team

| Imię | Rola | Wkład |
|------|------|-------|
| Paweł G. | Lead Developer | Architecture, Backend, UI |
| [Developer 2] | Frontend Developer | UI/UX implementation |
| [Developer 3] | DevOps | CI/CD, Infrastructure |

### Special Thanks

- **Młody Kraków** - wsparcie i patronat
- **Uniwersytet Ekonomiczny w Krakowie** - współpraca
- **Beta testerzy** - feedback i testy

---

## 18.11. Breaking Changes

### [1.0.0]
- Brak (pierwsza wersja)

### [1.1.0] (planowane)
- **API:** Zmiana z local-only na backend API (wymaga internetu)
- **Auth:** Wprowadzenie JWT tokens (konieczne ponowne logowanie)

### [2.0.0] (planowane)
- **Database:** Migracja z Isar do Firebase Firestore (automatyczna)
- **Routing:** Zmiana struktury route'ów (breaking dla deep links)

---

## 18.12. Release Notes Szczegółowe

### 1.0.0 (2025-10-05) - "Młody Kraków Launch"

**📱 Nowa aplikacja mobilna SmokPomaga!**

Witamy w pierwszej publicznej wersji aplikacji SmokPomaga - platformy łączącej wolontariuszy z organizacjami w Krakowie.

**✨ Główne funkcje:**
- 🤝 Przeglądaj i aplikuj na wydarzenia wolontariackie
- 🗺️ Interaktywna mapa wydarzeń w Krakowie
- 🎖️ Zdobywaj certyfikaty za ukończone wydarzenia
- 📊 Śledź swoje godziny wolontariatu
- 🏢 Dla organizacji: twórz wydarzenia i zarządzaj aplikacjami
- 🎓 Dla koordynatorów UEK: weryfikuj studentów

**🛠️ Technologia:**
- Flutter 3.9.0
- Clean Architecture + BLoC pattern
- Isar NoSQL database
- OpenStreetMap integration

**📲 Wymagania:**
- Android 5.0 (API 21) lub nowszy
- 100 MB wolnej przestrzeni
- Połączenie internetowe (opcjonalnie dla mapy)

**🐛 Znane ograniczenia:**
- Brak iOS (planowane w 1.3.0)
- Brak backendu (planowane w 1.1.0)
- Certyfikaty tylko w aplikacji (PDF w 1.1.0)

**💚 Wsparcie dzięki programowi Młody Kraków**

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga  
**Wersja dokumentu:** 1.0.0
