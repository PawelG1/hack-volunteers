# 🏢 Moduł Organizacja

## 📋 Rola organizacji

Organizacja (NGO, fundacja, stowarzyszenie, instytucja publiczna) jest odpowiedzialna za:

### 1. Zarządzanie ofertami
- Publikacja wydarzeń wolontariackich
- Edycja i usuwanie ofert
- Określanie wymagań i liczby wolontariuszy

### 2. Zarządzanie zgłoszeniami
- Przeglądanie zgłoszeń wolontariuszy
- Akceptacja lub odrzucenie zgłoszeń
- Komunikacja z wolontariuszami

### 3. Potwierdzanie obecności
- Oznaczanie obecności uczestników na wydarzeniu
- Ewidencja przepracowanych godzin
- Wystawianie opinii o wolontariuszach

### 4. Komunikacja
- Chat z wolontariuszami
- Powiadomienia o terminach
- Informacje organizacyjne

---

## 🔄 Proces z perspektywy organizacji (Flow)

### Krok 1: Publikacja wydarzenia
**Akcja:** Organizacja tworzy nowe wydarzenie  
**Wypełnia:**
- Tytuł, opis
- Lokalizacja, data
- Wymagana liczba wolontariuszy
- Kategorie, wymagania
- Zdjęcie (opcjonalnie)

**Status wydarzenia:** `published`  
**Widoczność:** Wolontariusze widzą wydarzenie w aplikacji

### Krok 2: Otrzymywanie zgłoszeń
**Akcja:** Wolontariusze zgłaszają się do wydarzenia  
**Status zgłoszenia:** `pending`  
**Organizacja widzi:**
- Imię, nazwisko wolontariusza
- Wiek, szkoła
- Zainteresowania, umiejętności
- Wiadomość od wolontariusza

### Krok 3: Akceptacja zgłoszeń
**Akcja:** Organizacja akceptuje lub odrzuca zgłoszenia  
**Status:** `accepted` lub `rejected`  
**Organizacja może:**
- Zaakceptować zgłoszenie
- Odrzucić z podaniem przyczyny
- Wysłać wiadomość do wolontariusza

**Widoczność:** Wolontariusz dostaje powiadomienie o decyzji

### Krok 4: Przypisanie do zadań
**Akcja:** Organizacja przypisuje wolontariuszy do konkretnych zadań  
**Przykłady zadań:**
- Pomoc przy obsłudze wejścia
- Przygotowanie materiałów
- Sprzątanie po akcji
- Opieka nad zwierzętami

### Krok 5: Wydarzenie się odbywa
**Akcja:** Wolontariusze uczestniczą w akcji  
**Organizacja:**
- Sprawdza obecność
- Nadzoruje wykonanie zadań
- Notuje godziny pracy

### Krok 6: Potwierdzenie obecności
**Akcja:** Po wydarzeniu organizacja oznacza obecność  
**Status:** `attended` (obecny) lub `notAttended` (nieobecny)  
**Organizacja podaje:**
- Czy wolontariusz był obecny
- Ile godzin przepracował
- Ocenę (1-5 gwiazdek)
- Opinię tekstową (opcjonalnie)

**UWAGA:** To NIE jest zatwierdzenie! To tylko potwierdzenie obecności.

**Widoczność:** Koordynator szkolny widzi potwierdzenie i może zatwierdzić udział

### Krok 7: Końcowe działania
**Akcja:** Organizacja może dodatkowo:
- Wystawić rekomendację dla wolontariusza
- Dodać wolontariusza do "ulubionych" (dla przyszłych akcji)
- Zaprosić na kolejne wydarzenia

---

## 📊 Statystyki i raporty

### Dashboard organizacji
**Statystyki:**
- Liczba opublikowanych wydarzeń
- Liczba zgłoszeń (pending/accepted/rejected)
- Liczba aktywnych wolontariuszy
- Suma przepracowanych godzin
- Średnia ocena wydarzeń

### Raporty wewnętrzne
**Do pobrania (PDF/Excel):**
- Lista wolontariuszy na wydarzeniu
- Statystyki obecności
- Godziny wolontariatu
- Oceny i opinie

---

## 🛠️ Funkcje do zaimplementowania

### Priorytet 1 (Kluczowe) 🔴
- [ ] Publikacja wydarzeń
- [ ] Zarządzanie zgłoszeniami (akceptacja/odrzucenie)
- [ ] Oznaczanie obecności uczestników
- [ ] Lista przypisanych wolontariuszy

### Priorytet 2 (Ważne) 🟡
- [ ] Chat z wolontariuszami
- [ ] Kalendarz wydarzeń
- [ ] Przypisywanie do zadań
- [ ] Wystawianie opinii

### Priorytet 3 (Przydatne) 🟢
- [ ] Statystyki i raporty
- [ ] Ulubieni wolontariusze
- [ ] Szablony wydarzeń
- [ ] Masowe wiadomości

---

## 📁 Struktura plików

```
features/organizations/
├── domain/
│   ├── entities/
│   │   ├── organization_profile.dart
│   │   ├── volunteer_application.dart ✅
│   │   └── certificate.dart ✅
│   ├── repositories/
│   │   └── organization_repository.dart
│   └── usecases/
│       ├── publish_event.dart
│       ├── manage_applications.dart
│       ├── mark_attendance.dart
│       └── rate_volunteer.dart
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presentation/
    ├── pages/
    │   ├── organization_dashboard.dart ✅
    │   ├── manage_events_page.dart ✅
    │   ├── applications_page.dart
    │   └── attendance_page.dart
    ├── widgets/
    └── bloc/
```

---

## 🎯 User Stories

### US-1: Jako organizacja chcę opublikować wydarzenie
**Kryteria akceptacji:**
- Mogę wypełnić formularz z danymi wydarzenia
- Mogę dodać zdjęcie
- Mogę wybrać kategorie
- Wydarzenie pojawia się w aplikacji dla wolontariuszy
- Mogę edytować lub usunąć wydarzenie

### US-2: Jako organizacja chcę zarządzać zgłoszeniami
**Kryteria akceptacji:**
- Widzę listę zgłoszeń (pending)
- Dla każdego zgłoszenia widzę profil wolontariusza
- Mogę zaakceptować lub odrzucić zgłoszenie
- Mogę dodać wiadomość przy odrzuceniu
- Wolontariusz dostaje powiadomienie o decyzji

### US-3: Jako organizacja chcę oznaczyć obecność uczestników
**Kryteria akceptacji:**
- Po zakończeniu wydarzenia widzę listę uczestników
- Mogę zaznaczyć kto był obecny (attended/notAttended)
- Mogę podać liczbę godzin dla każdego
- Mogę wystawić ocenę (1-5 gwiazdek)
- Mogę dodać opinię tekstową

### US-4: Jako organizacja chcę wystawić rekomendację
**Kryteria akceptacji:**
- Mogę napisać rekomendację dla wolontariusza
- Rekomendacja zawiera: opis pracy, mocne strony, ocenę
- Wolontariusz widzi rekomendację w profilu
- Rekomendacja jest dostępna dla innych organizacji (za zgodą)

---

## 🔐 Uprawnienia

Organizacja ma dostęp do:
- ✅ Swoich wydarzeń
- ✅ Zgłoszeń do swoich wydarzeń
- ✅ Danych wolontariuszy którzy się zgłosili (imię, wiek, szkoła)
- ✅ Historii uczestnictwa w swoich wydarzeniach
- ❌ Pełnych danych osobowych wolontariuszy (PESEL, adres)
- ❌ Wydarzeń innych organizacji
- ❌ Generowania zaświadczeń (to robi koordynator)

---

## 📝 Różnice: Organizacja vs Koordynator

### ✅ Organizacja MOŻE:
- Publikować wydarzenia
- Akceptować/odrzucać zgłoszenia
- **Oznaczać obecność** (attended/notAttended)
- Wystawiać oceny i opinie
- Rekomendować wolontariuszy

### ❌ Organizacja NIE MOŻE:
- **Zatwierdzać udziału** (to robi koordynator)
- **Generować zaświadczeń** (to robi koordynator)
- Widzieć pełnych danych osobowych
- Generować oficjalnych raportów szkolnych

### ✅ Koordynator MOŻE:
- **Zatwierdzać udział** (po potwierdzeniu obecności przez organizację)
- **Generować zaświadczenia**
- Generować raporty dla dyrekcji/kuratorium
- Widzieć pełne dane uczniów ze swojej szkoły

---

## 💡 Najlepsze praktyki

### Weryfikacja zgłoszeń
- Sprawdź profil wolontariusza
- Zwróć uwagę na zainteresowania i umiejętności
- Odpowiadaj szybko (w ciągu 24h)
- Podawaj konkretny powód odrzucenia

### Oznaczanie obecności
- Rób to bezpośrednio po wydarzeniu
- Bądź fair przy wystawianiu ocen
- Doceniaj zaangażowanie w opinii
- Podawaj realne godziny pracy

### Komunikacja
- Wysyłaj przypomnienia przed wydarzeniem
- Informuj o zmianach terminów
- Dziękuj za udział
- Zapraszaj na kolejne akcje

### Budowanie społeczności
- Doceniaj stałych wolontariuszy
- Organizuj spotkania integracyjne
- Dziel się historiami sukcesu
- Twórz przyjazną atmosferę
