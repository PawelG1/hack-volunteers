# 🎯 Hack Volunteers - Pełna Specyfikacja Projektu

## Wizja projektu
Nowoczesna aplikacja mobilna łącząca młodzież z możliwościami wolontariatu w Krakowie.

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
- [ ] Oznaczanie obecności

#### Raportowanie
- [ ] Statystyki udziału
- [ ] Godziny pracy wolontariuszy
- [ ] Raporty do pobrania (PDF/Excel)

#### Zaświadczenia i opinie
- [ ] Zatwierdzanie wykonanych zadań
- [ ] Generowanie zaświadczeń dla wolontariuszy
- [ ] Wystawianie opinii i rekomendacji

---

## 🏫 Funkcjonalności dla KOORDYNATORA SZKOLNEGO

### Do zrealizowania:

#### Zarządzanie uczniami
- [ ] Konto koordynatora
- [ ] Lista uczniów ze szkoły
- [ ] Przydzielanie uczniów do projektów

#### Komunikacja
- [ ] Kontakt z organizacjami
- [ ] Kalendarz wydarzeń szkolnych

#### Administracja
- [ ] Zatwierdzanie i generowanie zaświadczeń
- [ ] Generowanie raportów (dla dyrekcji, kuratorium)
- [ ] Statystyki wolontariatu w szkole

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

## 🗄️ Architektura danych

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
- [ ] Integracja z Isar (lokalna baza)
- [ ] Cache wydarzeń
- [ ] Offline mode

### v0.3.0 (Planowana)
- [ ] Firebase Authentication
- [ ] Cloud Firestore
- [ ] Rejestracja i logowanie

### v1.0.0 (Docelowa)
- [ ] Wszystkie funkcjonalności dla wolontariuszy
- [ ] Wszystkie funkcjonalności dla organizacji
- [ ] Chat
- [ ] Powiadomienia
- [ ] Zaświadczenia
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

Ostatnia aktualizacja: 2025-10-04
Wersja: 0.2.0-dev
