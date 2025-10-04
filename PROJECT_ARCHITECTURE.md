# Hack Volunteers

Aplikacja mobilna do wybierania wydarzeń wolontariackich z mechaniką swipe'owania (jak Tinder).

## 🏗️ Architektura

Projekt został zbudowany w oparciu o **Clean Architecture** i zasady **SOLID**, co gwarantuje:
- ✅ Łatwość w utrzymaniu kodu
- ✅ Testowalność
- ✅ Skalowalność
- ✅ Separację odpowiedzialności

### Struktura projektu

```
lib/
├── core/                          # Rdzeń aplikacji
│   ├── error/
│   │   └── failures.dart         # Definicje błędów
│   ├── network/
│   │   └── network_info.dart     # Sprawdzanie połączenia
│   └── usecases/
│       └── usecase.dart          # Bazowa klasa dla use cases
│
├── features/                      # Funkcjonalności aplikacji
│   └── events/                   # Feature: Wydarzenia
│       ├── data/                 # Warstwa danych
│       │   ├── datasources/
│       │   │   ├── events_local_data_source.dart
│       │   │   └── events_remote_data_source.dart
│       │   ├── models/
│       │   │   └── volunteer_event_model.dart
│       │   └── repositories/
│       │       └── events_repository_impl.dart
│       │
│       ├── domain/               # Warstwa logiki biznesowej
│       │   ├── entities/
│       │   │   └── volunteer_event.dart
│       │   ├── repositories/
│       │   │   └── events_repository.dart
│       │   └── usecases/
│       │       ├── get_events.dart
│       │       ├── save_interested_event.dart
│       │       └── save_skipped_event.dart
│       │
│       └── presentation/         # Warstwa prezentacji
│           ├── bloc/
│           │   ├── events_bloc.dart
│           │   ├── events_event.dart
│           │   └── events_state.dart
│           ├── pages/
│           │   └── events_swipe_screen.dart
│           └── widgets/
│               └── event_card.dart
│
├── injection_container.dart      # Dependency Injection (GetIt)
└── main.dart                     # Punkt wejścia aplikacji
```

## 🎯 Zasady Clean Architecture

### 1. **Domain Layer** (Najważniejsza warstwa)
- Zawiera logikę biznesową
- Nie zależy od innych warstw
- Definiuje interfejsy (abstrakcje)
- Zawiera encje i use cases

### 2. **Data Layer**
- Implementuje repozytoria z warstwy domain
- Zarządza źródłami danych (lokalne i zdalne)
- Przekształca dane (modele ↔ encje)

### 3. **Presentation Layer**
- Zarządza UI i stanem aplikacji
- Używa BLoC do zarządzania stanem
- Reaguje na akcje użytkownika

## 🔧 Zasady SOLID

### Single Responsibility Principle (SRP)
Każda klasa ma tylko jedną odpowiedzialność:
- `GetEvents` - tylko pobieranie wydarzeń
- `SaveInterestedEvent` - tylko zapisywanie zainteresowania
- `EventsBloc` - tylko zarządzanie stanem wydarzeń

### Open/Closed Principle (OCP)
Klasy są otwarte na rozszerzenia, zamknięte na modyfikacje:
- Łatwo dodać nowe use cases
- Łatwo dodać nowe źródła danych

### Liskov Substitution Principle (LSP)
Możemy podmienić implementacje bez wpływu na działanie:
- `EventsRemoteDataSourceImpl` można zastąpić inną implementacją
- Repository może używać różnych źródeł danych

### Interface Segregation Principle (ISP)
Interfejsy są małe i specyficzne:
- `EventsRepository` ma tylko metody związane z wydarzeniami
- `EventsLocalDataSource` ma tylko metody dla lokalnych danych

### Dependency Inversion Principle (DIP)
Zależności wskazują do abstrakcji, nie implementacji:
- `EventsBloc` zależy od `UseCase`, nie konkretnej implementacji
- `EventsRepositoryImpl` implementuje interfejs `EventsRepository`

## 📦 Zależności

```yaml
dependencies:
  flutter_bloc: ^8.1.6        # Zarządzanie stanem
  equatable: ^2.0.5           # Porównywanie obiektów
  get_it: ^7.7.0              # Dependency Injection
  dartz: ^0.10.1              # Programowanie funkcyjne (Either)
  intl: ^0.19.0               # Formatowanie dat
```

## 🚀 Aktualny stan projektu

### ✅ Zrealizowane

1. **Pełna struktura Clean Architecture**
   - Domain layer z encjami i use cases
   - Data layer z repozytoriami i źródłami danych
   - Presentation layer z BLoC i UI

2. **Mechanika swipe'owania**
   - Swipe w lewo = pomiń wydarzenie
   - Swipe w prawo = zainteresowanie wydarzeniem
   - Przyciski akcji (❤️ / ✖️)

3. **UI/UX**
   - Czytelne karty wydarzeń
   - Wskaźnik postępu
   - Responsywny design
   - Animacje i gestykulacja

4. **Zarządzanie stanem**
   - BLoC pattern
   - Czyste separacje odpowiedzialności
   - Error handling

5. **Mock data**
   - 5 przykładowych wydarzeń
   - Różne kategorie wolontariatu

### 🔜 Następne kroki

1. **Integracja z Isar** (lokalna baza danych)
   ```bash
   # Dodaj do pubspec.yaml:
   isar: ^3.1.0
   isar_flutter_libs: ^3.1.0
   ```

2. **Integracja z Firebase**
   - Firebase Authentication
   - Cloud Firestore dla wydarzeń
   - Firebase Storage dla zdjęć

3. **Dodatkowe funkcjonalności**
   - Lista zainteresowań użytkownika
   - Filtrowanie wydarzeń
   - Szczegóły wydarzenia
   - Powiadomienia

## 🏃 Uruchomienie projektu

```bash
# Pobranie zależności
flutter pub get

# Uruchomienie aplikacji
flutter run

# Testy (gdy będą dodane)
flutter test
```

## 📱 Jak działa swipe?

1. Użytkownik widzi kartę z wydarzeniem
2. Może:
   - Przeciągnąć w prawo → zapisz jako "zainteresowany"
   - Przeciągnąć w lewo → pomiń wydarzenie
   - Kliknąć przycisk ❤️ → zapisz jako "zainteresowany"
   - Kliknąć przycisk ✖️ → pomiń wydarzenie
3. Po akcji wyświetlana jest następna karta
4. Po przejrzeniu wszystkich - możliwość odświeżenia

## 🎨 Technologie

- **Flutter** - Framework UI
- **Dart** - Język programowania
- **BLoC** - Zarządzanie stanem
- **GetIt** - Dependency Injection
- **Dartz** - Functional programming
- **Isar** (planowane) - Lokalna baza danych
- **Firebase** (planowane) - Backend

## 📝 Licencja

Projekt edukacyjny - Hack Volunteers
