# 🎯 Hack Volunteers - Pełna Specyfikacja Projektu

## Wizja projektu
Nowoczesna aplikacja mobilna łącząca młodzież z możliwościami wolontariatu w Krakowie.

---

## ⚠️ KLUCZOWA ZASADA - Podział odpowiedzialności

### 🏢 ORGANIZACJA:
- ✅ Publikuje wydarzenia
- ✅ Akceptuje/odrzuca zgłoszenia wolontariuszy
- ✅ **Oznacza obecność** uczestników (attended/notAttended)
- ✅ Wystawia oceny i opinie
- ❌ **NIE zatwierdza udziału** (to robi koordynator!)
- ❌ **NIE generuje zaświadczeń** (to robi koordynator!)

### 🏫 KOORDYNATOR SZKOLNY:
- ✅ **Zatwierdza udział** uczniów (po potwierdzeniu obecności przez organizację)
- ✅ **Generuje zaświadczenia** o uczestnictwie
- ✅ **Generuje raporty** dla dyrekcji i kuratorium
- ✅ Weryfikuje godziny i zakres prac
- ✅ Kontakt z organizacjami w sprawie uczniów

### 📋 PROCES (uproszczony):
1. **Wolontariusz** → zgłasza się do wydarzenia
2. **Organizacja** → akceptuje zgłoszenie
3. **Wydarzenie** → odbywa się
4. **Organizacja** → oznacza obecność + ocenia
5. **Koordynator** → zatwierdza udział
6. **Koordynator** → generuje zaświadczenie

---

## 👥 Typy użytkowników

### 1. Wolontariusze (młodzież)
- Konta dla **małoletnich** (wymagana zgoda opiekuna)
- Konta dla **pełnoletnich**

### 2. Organizacje/Instytucje
- NGO, fundacje, stowarzyszenia
- Instytucje publiczne

### 3. Szkolni Koordynatorzy Wolontariatu
- Nauczyciele/opiekunowie wolontariatu w szkołach

---

## 📱 Funkcjonalności dla WOLONTARIUSZY

### ✅ Aktualnie zrealizowane:
- [x] Mechanika swipe do przeglądania ofert
- [x] Wyświetlanie szczegółów wydarzenia (tytuł, opis, lokalizacja, data, organizacja, kategorie)
- [x] Zapisywanie zainteresowań (in-memory)

### 🔜 Do zrealizowania:

#### Przeglądanie i wyszukiwanie
- [ ] Filtry: tematyka, lokalizacja, czas trwania, wymagania
- [ ] Wyszukiwarka po nazwie organizatora
- [ ] Mapa inicjatyw (Google Maps / OpenStreetMap)
- [ ] Lista zapisanych/polubionych wydarzeń

#### Konto i profil
- [ ] Rejestracja (z rozróżnieniem: małoletni/pełnoletni)
- [ ] Logowanie (Firebase Auth)
- [ ] Profil wolontariusza
- [ ] Zgoda opiekuna (dla małoletnich)
- [ ] Historia uczestnictwa

#### Uczestnictwo
- [ ] Zgłaszanie się do projektów jednym kliknięciem
- [ ] Status zgłoszenia (oczekujące/zaakceptowane/odrzucone)
- [ ] Lista moich wydarzeń

#### Komunikacja
- [ ] Chat z organizacją
- [ ] Powiadomienia push
- [ ] Powiadomienia o terminach

#### Kalendarz
- [ ] Kalendarz wydarzeń
- [ ] Przypomnienia o nadchodzących akcjach
- [ ] Historia uczestnictwa

#### Zaświadczenia
- [ ] Generowanie zaświadczeń (po zatwierdzeniu przez organizację)
- [ ] PDF z potwierdzeniem udziału
- [ ] Liczba przepracowanych godzin

---

## 🏢 Funkcjonalności dla ORGANIZACJI

### Do zrealizowania:

#### Zarządzanie ofertami
- [ ] Publikacja ofert wolontariatu
- [ ] Edycja i usuwanie ofert
- [ ] Zarządzanie zgłoszeniami wolontariuszy
- [ ] Akceptacja/odrzucanie zgłoszeń

#### Komunikacja
- [ ] Chat z wolontariuszami
- [ ] Powiadomienia push
- [ ] Masowe wiadomości do uczestników

#### Zarządzanie wolontariuszami
- [ ] Lista przypisanych wolontariuszy
- [ ] Kalendarz i przypisywanie do zadań
- [ ] Oznaczanie obecności na wydarzeniu (potwierdzenie obecności)

#### Raportowanie
- [ ] Statystyki udziału
- [ ] Godziny pracy wolontariuszy
- [ ] Raporty podstawowe (dla własnych celów)

#### Opinie
- [ ] Wystawianie opinii i rekomendacji dla wolontariuszy
- [ ] Ocena wolontariusza (np. gwiazdki)

---

## 🏫 Funkcjonalności dla KOORDYNATORA SZKOLNEGO

### Do zrealizowania:

#### Zarządzanie uczniami
- [ ] Konto koordynatora
- [ ] Lista uczniów ze szkoły
- [ ] Przydzielanie uczniów do projektów
- [ ] Monitorowanie obecności uczniów na wydarzeniach

#### Komunikacja
- [ ] Kontakt z organizacjami
- [ ] Kalendarz wydarzeń szkolnych
- [ ] Powiadomienia dla uczniów i rodziców

#### Zatwierdzanie i certyfikacja
- [ ] **Zatwierdzanie udziału uczniów w wydarzeniach** (po potwierdzeniu obecności przez organizację)
- [ ] **Generowanie zaświadczeń o uczestnictwie w wolontariacie**
- [ ] Potwierdzanie godzin wolontariatu
- [ ] Weryfikacja spełnienia wymagań programowych

#### Raportowanie i statystyki
- [ ] **Generowanie raportów dla dyrekcji szkoły**
- [ ] **Generowanie raportów dla kuratorium**
- [ ] Statystyki wolontariatu w szkole (uczniowie, godziny, wydarzenia)
- [ ] Eksport danych (PDF/Excel)
- [ ] Raporty roczne i semestralne

---

## 🌟 Funkcjonalności WSPÓLNE

### ✅ Aktualnie zrealizowane:
- [x] Clean Architecture
- [x] SOLID Principles
- [x] BLoC Pattern
- [x] Dependency Injection

### 🔜 Do zrealizowania:

#### Mapa
- [ ] Mapa inicjatyw (Google Maps)
- [ ] Pokazywanie lokalizacji działań
- [ ] Filtrowanie na mapie

#### Bezpieczeństwo
- [ ] Zgodność z RODO
- [ ] Szyfrowanie danych wrażliwych
- [ ] Polityka prywatności
- [ ] Zgody użytkowników

#### Platforma
- [ ] Aplikacja w pełni mobilna (Android/iOS)
- [ ] Responsywny design
- [ ] Offline mode (Isar)

#### Dane testowe
- [ ] Tryb demo z danymi testowymi
- [ ] Możliwość symulacji bez rejestracji

---

## � PROCES UCZESTNICTWA W WYDARZENIU

### Krok 1: Zgłoszenie (Wolontariusz)
1. Wolontariusz przegląda wydarzenia
2. Swipe right / klik "Zainteresowany"
3. Status: **Oczekujące**

### Krok 2: Akceptacja (Organizacja)
1. Organizacja otrzymuje zgłoszenie
2. Akceptuje lub odrzuca wolontariusza
3. Status: **Zaakceptowany** lub **Odrzucony**

### Krok 3: Uczestnictwo (Wydarzenie)
1. Wydarzenie się odbywa
2. Organizacja oznacza obecność uczestników
3. Status: **Obecny** lub **Nieobecny**

### Krok 4: Zatwierdzenie (Koordynator Szkolny)
1. Koordynator sprawdza potwierdzenie obecności od organizacji
2. Zatwierdza udział ucznia (weryfikuje godziny, zakres prac)
3. Status: **Zatwierdzony**

### Krok 5: Certyfikacja (Koordynator Szkolny)
1. Koordynator generuje zaświadczenie o uczestnictwie
2. Zaświadczenie zawiera: godziny, zakres prac, ocenę organizacji
3. Wolontariusz otrzymuje certyfikat (PDF)

### Krok 6: Raportowanie (Koordynator Szkolny)
1. Koordynator generuje raporty (miesięczne, semestralne, roczne)
2. Raporty trafiają do dyrekcji szkoły i kuratorium
3. Statystyki: liczba uczniów, godziny, wydarzenia, kategorie

---

## �🗄️ Architektura danych

### Lokalna baza (Isar)
- [x] **Planowane**: Wydarzenia (cache)
- [ ] Wolontariusze
- [ ] Organizacje
- [ ] Zgłoszenia
- [ ] Zaświadczenia (offline)
- [ ] Historia synchronizacji

### Zdalna baza (Firebase)
- [ ] Cloud Firestore - wydarzenia, użytkownicy
- [ ] Firebase Auth - autoryzacja
- [ ] Cloud Storage - zdjęcia, dokumenty
- [ ] Cloud Functions - logika backendowa
- [ ] Firebase Cloud Messaging - powiadomienia

---

## 📊 Status realizacji

### v0.1.0 (Obecna) ✅
- [x] Clean Architecture
- [x] Mechanika swipe
- [x] Wyświetlanie wydarzeń
- [x] Mock data
- [x] BLoC pattern

### v0.2.0 (W trakcie) 🔄
- [x] Integracja z Isar (lokalna baza)
- [x] Cache wydarzeń
- [x] Offline mode
- [x] GDPR/RODO onboarding
- [x] **Organizations Backend** (Repository + Use Cases + Data Source)
- [x] **Coordinators Backend** (Repository + Use Cases + Data Source)
- [x] **Application Lifecycle** (pending → accepted → attended → approved → completed)
- [ ] Organizations UI (ApplicationsListPage, AttendanceMarkingPage)
- [ ] Coordinators UI (PendingApprovalsPage, GenerateCertificatePage)

### v0.3.0 (Planowana)
- [ ] Firebase Authentication
- [ ] Cloud Firestore
- [ ] Rejestracja i logowanie

### v1.0.0 (Docelowa)
- [ ] Wszystkie funkcjonalności dla wolontariuszy
- [ ] Wszystkie funkcjonalności dla organizacji
- [ ] Wszystkie funkcjonalności dla koordynatorów
- [ ] Chat
- [ ] Powiadomienia
- [ ] Zaświadczenia (PDF)
- [ ] Mapa

---

## 🎯 Cel końcowy

### Dla młodzieży
✅ Łatwy i nowoczesny dostęp do wolontariatu
✅ Intuicyjny interfejs (swipe jak Tinder)
✅ Wszystko w jednym miejscu

### Dla organizacji
✅ Uproszczone zarządzanie projektami
✅ Łatwa komunikacja z wolontariuszami
✅ Automatyzacja dokumentacji

### Dla społeczności
✅ Silniejsze powiązanie społeczności lokalnej
✅ Większe zaangażowanie młodych mieszkańców Krakowa
✅ Wzrost aktywności wolontarackiej

---

## 🚀 Technologie

### Frontend
- Flutter (mobile-first)
- BLoC (state management)
- Clean Architecture

### Backend
- Firebase (Auth, Firestore, Storage, Functions)
- Cloud Messaging (push notifications)

### Database
- Isar (lokalna baza - offline mode)
- Cloud Firestore (zdalna baza - sync)

### Dodatkowe
- Google Maps API (mapa inicjatyw)
- PDF generation (zaświadczenia)
- RODO compliance

---

**Dokument żywy - aktualizowany podczas developmentu**

Ostatnia aktualizacja: 2025-10-05
Wersja: 0.2.0-dev (Organizations + Coordinators backend READY ✅)
