# Mapa Wydarzeń - Dokumentacja

## Opis funkcjonalności

Aplikacja HackVolunteers zawiera interaktywną mapę OpenStreetMap pokazującą lokalizacje wydarzeń wolontariackich w Krakowie.

## Funkcje mapy

### 1. **Mapa interaktywna**
- Używa OpenStreetMap jako źródła map
- Możliwość przybliżania/oddalania (pinch to zoom)
- Przesuwanie mapy (pan)
- Zoom od 10x do 18x
- Domyślnie wycentrowana na Kraków (50.0647°N, 19.9450°E)

### 2. **Markery wydarzeń**
- Kolorowe ikony na mapie reprezentują różne kategorie wydarzeń:
  - 🔵 **Niebieski** - Edukacja
  - 🟢 **Zielony** - Środowisko
  - 🟠 **Pomarańczowy** - Pomoc społeczna
  - 🟣 **Fioletowy** - Technologia
  - 🔴 **Różowy** - Kultura/Muzyka
  - 🟤 **Brązowy** - Zwierzęta
  - 🟣 **Magenta** - Inne

### 3. **Widoki**
- **Widok mapy** (domyślny) - interaktywna mapa z markerami
- **Widok listy** - lista wszystkich wydarzeń z kartami
- Przełączanie widoków przyciskiem w AppBar

### 4. **Szczegóły wydarzeń**
- Kliknięcie na marker otwiera bottom sheet z:
  - Nazwą wydarzenia
  - Organizacją
  - Lokalizacją
  - Kategorią
  - Liczbą wolontariuszy
  - Datą wydarzenia
  - Pełnym opisem
  - Przyciskami akcji (Pokaż/Zapisz)

### 5. **Funkcje nawigacyjne**
- Przycisk **"Moja lokalizacja"** - centruje mapę na Kraków
- Przycisk **"Pokaż"** w szczegółach - centruje mapę na wydarzeniu
- Górny pasek informacyjny pokazuje liczbę wydarzeń

## Implementacja techniczna

### Pakiety użyte
```yaml
dependencies:
  flutter_map: ^7.0.2  # Mapa OpenStreetMap
  latlong2: ^0.9.1      # Koordynaty geograficzne
```

### Struktura plików
```
lib/features/
├── map/
│   └── presentation/
│       └── pages/
│           └── events_map_page.dart  # Główna strona mapy
└── events/
    └── domain/
        └── entities/
            └── volunteer_event.dart  # Dodano latitude/longitude
```

### Model danych
Wydarzenia (`VolunteerEvent`) zawierają koordynaty geograficzne:
```dart
final double? latitude;   // Szerokość geograficzna
final double? longitude;  // Długość geograficzna
```

### Przykładowe koordynaty Kraków
- **Park Centralny**: 50.0647°N, 19.9450°E
- **Schronisko (południe)**: 50.0213°N, 19.9384°E
- **Dom Kultury Podgórze**: 50.0337°N, 19.9632°E
- **AGH**: 50.0665°N, 19.9182°E
- **Filharmonia**: 50.0640°N, 19.9464°E

## Dostęp do mapy

### W aplikacji
1. Uruchom aplikację
2. Zaloguj się jako Wolontariusz
3. W dolnej nawigacji kliknij zakładkę **"Mapa"** (trzecia ikona)

### Kod
```dart
import 'package:flutter/material.dart';
import 'features/map/presentation/pages/events_map_page.dart';

// Użycie w nawigacji
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const EventsMapPage(),
  ),
);
```

## Dodawanie nowych wydarzeń na mapie

### 1. Dodaj koordynaty w danych źródłowych
```dart
// lib/features/events/data/datasources/events_remote_data_source.dart
VolunteerEventModel(
  id: '6',
  title: 'Nowe wydarzenie',
  location: 'Rynek Główny, Kraków',
  latitude: 50.0619,  // ← DODAJ
  longitude: 19.9368, // ← DODAJ
  // ... inne pola
),
```

### 2. Przebuduj aplikację
```bash
flutter run
```

### 3. Wydarzenia bez koordynatów
Wydarzenia bez ustawionych `latitude` i `longitude` **nie będą pokazane na mapie**, ale będą widoczne w innych widokach aplikacji.

## Dostosowywanie mapy

### Zmiana centrum mapy
```dart
// W events_map_page.dart
static const LatLng _center = LatLng(50.0647, 19.9450); // Kraków
```

### Zmiana domyślnego zoomu
```dart
MapOptions(
  initialZoom: 13.0,  // Wartość domyślna: 13.0
  minZoom: 10.0,      // Minimalne przybliżenie
  maxZoom: 18.0,      // Maksymalne przybliżenie
)
```

### Zmiana koloru kategorii
```dart
Color _getCategoryColor(String category) {
  // Dodaj nową kategorię
  if (category.contains('sport')) return Colors.red;
  // ... reszta kodu
}
```

### Zmiana ikony kategorii
```dart
IconData _getCategoryIcon(String category) {
  // Dodaj nową ikonę
  if (category.contains('sport')) return Icons.sports_soccer;
  // ... reszta kodu
}
```

## Znane ograniczenia

1. **Brak geolokalizacji użytkownika** - aktualnie brak uprawnień GPS
2. **Tiles OpenStreetMap** - wymaga połączenia internetowego
3. **Tylko Kraków** - koordynaty tylko dla Krakowa
4. **Brak routingu** - brak nawigacji do wydarzenia
5. **Statyczne dane** - wydarzenia z mock data source

## Przyszłe ulepszenia

- [ ] Dodanie geolokalizacji użytkownika (GPS)
- [ ] Klasteryzacja markerów przy dużej liczbie wydarzeń
- [ ] Filtrowanie wydarzeń na mapie według kategorii
- [ ] Wyszukiwanie wydarzeń w okolicy
- [ ] Nawigacja do wydarzenia (integracja z Google Maps/Apple Maps)
- [ ] Offline cache map tiles
- [ ] Różne warstwy mapy (satelitarna, uliczna, itd.)
- [ ] Heat mapa aktywności wolontariackiej

## Wymagania systemowe

- **Android**: minSdkVersion 21 (Android 5.0)
- **iOS**: iOS 12.0+
- **Połączenie internetowe**: Wymagane dla ładowania map tiles

## Rozwiązywanie problemów

### Mapa się nie ładuje
1. Sprawdź połączenie internetowe
2. Upewnij się, że pakiet `flutter_map` jest zainstalowany: `flutter pub get`
3. Sprawdź logi czy są błędy tile downloading

### Markery się nie pokazują
1. Sprawdź czy wydarzenia mają ustawione `latitude` i `longitude`
2. Sprawdź konsolę: `print('Events with coords: ${_events.length}');`

### Błędy kompilacji
1. Uruchom: `flutter clean`
2. Uruchom: `flutter pub get`
3. Przebuduj: `flutter run`

## Kontakt

W razie pytań lub problemów, sprawdź:
- README.md głównego projektu
- TROUBLESHOOTING.md
