# 🏫 Moduł Koordynator Szkolny

## 📋 Rola koordynatora

Koordynator szkolny (nauczyciel/opiekun wolontariatu) jest odpowiedzialny za:

### 1. Weryfikację i zatwierdzanie uczestnictwa
- Sprawdzanie potwierdzeń obecności od organizacji
- Weryfikacja godzin i zakresu prac
- Zatwierdzanie udziału uczniów w wydarzeniach

### 2. Generowanie zaświadczeń
- Wystawianie oficjalnych zaświadczeń o uczestnictwie
- Certyfikaty zawierają:
  - Dane ucznia (imię, nazwisko, szkoła, klasa)
  - Dane wydarzenia (nazwa, organizator, data)
  - Przepracowane godziny
  - Zakres wykonanych prac
  - Ocenę od organizacji
  - Podpis koordynatora i pieczęć szkoły

### 3. Raportowanie
- Generowanie raportów dla dyrekcji szkoły
- Generowanie raportów dla kuratorium
- Statystyki wolontariatu w szkole:
  - Liczba uczniów biorących udział
  - Suma przepracowanych godzin
  - Rozkład wydarzeń (kategorie, organizatorzy)
  - Trendy i porównania (miesięczne, semestralne, roczne)

### 4. Komunikacja
- Kontakt z organizacjami w sprawie uczniów
- Informowanie uczniów o możliwościach
- Koordynacja z rodzicami (zgody dla małoletnich)

---

## 🔄 Proces zatwierdzania (Flow)

### Krok 1: Zgłoszenie wolontariusza
**Akcja:** Uczeń zgłasza się do wydarzenia (swipe right)  
**Status:** `pending`  
**Widoczność:** Organizacja widzi zgłoszenie

### Krok 2: Akceptacja przez organizację
**Akcja:** Organizacja akceptuje lub odrzuca wolontariusza  
**Status:** `accepted` lub `rejected`  
**Widoczność:** Uczeń widzi status zgłoszenia

### Krok 3: Udział w wydarzeniu
**Akcja:** Wydarzenie się odbywa  
**Status:** Bez zmiany (nadal `accepted`)  
**Widoczność:** Uczeń uczestniczy w akcji

### Krok 4: Potwierdzenie obecności przez organizację
**Akcja:** Organizacja oznacza obecność uczestników  
**Status:** `attended` (obecny) lub `notAttended` (nieobecny)  
**Widoczność:** Koordynator widzi potwierdzenie obecności

### Krok 5: Zatwierdzenie przez koordynatora
**Akcja:** Koordynator sprawdza i zatwierdza udział  
**Status:** `approved`  
**Co weryfikuje koordynator:**
- Czy uczeń faktycznie był obecny (potwierdzenie od organizacji)
- Czy liczba godzin jest poprawna
- Czy zakres prac odpowiada wymaganiom
- Czy wydarzenie spełnia kryteria programowe szkoły

**Widoczność:** Uczeń widzi że udział został zatwierdzony

### Krok 6: Generowanie zaświadczenia
**Akcja:** Koordynator generuje oficjalne zaświadczenie (PDF)  
**Status:** `completed`  
**Co zawiera certyfikat:**
- Dane ucznia
- Dane wydarzenia
- Godziny wolontariatu
- Opis wykonanej pracy
- Ocena od organizacji
- Data wystawienia
- Podpis koordynatora
- Pieczęć szkoły

**Widoczność:** Uczeń może pobrać zaświadczenie

---

## 📊 Raporty

### Raport dla dyrekcji szkoły
**Częstotliwość:** Miesięcznie, semestralnie, rocznie  
**Zawiera:**
- Liczba uczniów aktywnych w wolontariacie
- Suma przepracowanych godzin
- Najpopularniejsze kategorie wydarzeń
- Najaktywniejsze klasy
- Top 10 wolontariuszy (wg godzin)
- Współpracujące organizacje

### Raport dla kuratorium
**Częstotliwość:** Rocznie  
**Zawiera:**
- Statystyki szkoły (uczniowie, godziny)
- Realizacja programu wolontariatu
- Kategorie działań
- Współpraca z organizacjami pozarządowymi
- Wpływ na rozwój uczniów
- Wnioski i rekomendacje

### Raport dla rodzica
**Na żądanie**  
**Zawiera:**
- Historia uczestnictwa dziecka
- Lista wydarzeń
- Przepracowane godziny
- Zaświadczenia
- Oceny od organizacji

---

## 🛠️ Funkcje do zaimplementowania

### Priorytet 1 (Kluczowe) 🔴
- [ ] Lista oczekujących na zatwierdzenie (status: `attended`)
- [ ] Zatwierdzanie udziału uczniów
- [ ] Generowanie zaświadczeń PDF
- [ ] Lista uczniów ze szkoły

### Priorytet 2 (Ważne) 🟡
- [ ] Generowanie raportów (miesięczne, semestralne, roczne)
- [ ] Eksport raportów (PDF, Excel)
- [ ] Statystyki szkoły (dashboard)
- [ ] Kalendarz wydarzeń z uczniami

### Priorytet 3 (Przydatne) 🟢
- [ ] Chat z organizacjami
- [ ] Powiadomienia o nowych zgłoszeniach
- [ ] Historia komunikacji
- [ ] Archiwum zaświadczeń

---

## 📁 Struktura plików

```
features/coordinators/
├── domain/
│   ├── entities/
│   │   ├── coordinator_profile.dart
│   │   └── school_report.dart
│   ├── repositories/
│   │   └── coordinator_repository.dart
│   └── usecases/
│       ├── approve_participation.dart
│       ├── generate_certificate.dart
│       └── generate_report.dart
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presentation/
    ├── pages/
    │   ├── coordinator_dashboard.dart
    │   ├── pending_approvals_page.dart
    │   ├── generate_certificate_page.dart
    │   └── reports_page.dart
    ├── widgets/
    └── bloc/
```

---

## 🎯 User Stories

### US-1: Jako koordynator chcę zobaczyć listę uczniów czekających na zatwierdzenie
**Kryteria akceptacji:**
- Widzę listę uczniów z statusem `attended`
- Dla każdego ucznia widzę: imię, nazwisko, wydarzenie, datę, godziny
- Mogę otworzyć szczegóły zgłoszenia
- Widzę potwierdzenie obecności od organizacji

### US-2: Jako koordynator chcę zatwierdzić udział ucznia
**Kryteria akceptacji:**
- Widzę szczegóły uczestnictwa (co robił, ile godzin)
- Widzę ocenę od organizacji
- Mogę dodać notatki
- Mogę zatwierdzić lub odrzucić
- Status zmienia się na `approved`

### US-3: Jako koordynator chcę wygenerować zaświadczenie
**Kryteria akceptacji:**
- Widzę listę zatwierdzonych uczestnictw (`approved`)
- Mogę wygenerować PDF z zaświadczeniem
- Zaświadczenie zawiera wszystkie wymagane dane
- PDF można pobrać i wydrukować
- Status zmienia się na `completed`

### US-4: Jako koordynator chcę wygenerować raport dla dyrekcji
**Kryteria akceptacji:**
- Mogę wybrać okres (miesiąc, semestr, rok)
- Raport zawiera statystyki i wykresy
- Mogę eksportować do PDF i Excel
- Raport jest czytelny i profesjonalny

---

## 🔐 Uprawnienia

Koordynator ma dostęp do:
- ✅ Zgłoszeń uczniów ze swojej szkoły
- ✅ Danych uczniów ze swojej szkoły
- ✅ Wydarzeń, w których uczestniczą jego uczniowie
- ❌ Danych uczniów z innych szkół
- ❌ Wewnętrznych danych organizacji

---

## 📝 Notatki implementacyjne

### Bezpieczeństwo
- Koordynator widzi tylko uczniów ze swojej szkoły
- Weryfikacja szkoły przy rejestracji (kod szkoły)
- Szyfrowanie danych wrażliwych (PESEL, adresy)
- Logi zmian (kto, kiedy zatwierdził)

### Wydajność
- Cache listy uczniów
- Lazy loading dla historii wydarzeń
- Kompresja PDF dla zaświadczeń
- Optymalizacja raportów (pre-kalkulacja statystyk)

### UX
- Przejrzyste statusy (ikony, kolory)
- Szybkie akcje (swipe to approve)
- Podgląd zaświadczenia przed wygenerowaniem
- Tooltips i pomoc kontekstowa
