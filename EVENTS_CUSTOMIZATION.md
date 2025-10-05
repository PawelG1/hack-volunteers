# 📝 Jak dostosować wydarzenia wolontarskie

## 🎯 Gdzie znajdują się predefiniowane wydarzenia?

**Plik:** `lib/features/events/data/datasources/events_remote_data_source.dart`

To miejsce, gdzie obecnie przechowywane są mockowe wydarzenia. W przyszłości zostanie to zastąpione przez Firebase/backend.

## 🖼️ Jak dodać zdjęcia do wydarzeń?

### Opcja 1: Użyj zdjęć z internetu (URL)

Najszybsza metoda - użyj darmowych zdjęć z Unsplash lub innej platformy:

```dart
VolunteerEventModel(
  id: '1',
  title: 'Twoje wydarzenie',
  description: 'Opis...',
  organization: 'Nazwa organizacji',
  location: 'Lokalizacja',
  date: DateTime.now().add(const Duration(days: 7)),
  requiredVolunteers: 15,
  categories: ['Środowisko'],
  imageUrl: 'https://images.unsplash.com/photo-XXXXXX?w=800', // ← Dodaj URL
  createdAt: DateTime.now(),
),
```

**Darmowe źródła zdjęć:**
- [Unsplash](https://unsplash.com/) - darmowe, wysokiej jakości zdjęcia
- [Pexels](https://pexels.com/) - darmowe zdjęcia stockowe
- [Pixabay](https://pixabay.com/) - darmowe obrazy

### Opcja 2: Użyj lokalnych zdjęć (assets)

Jeśli chcesz użyć własnych zdjęć:

#### Krok 1: Dodaj zdjęcia do projektu

1. Utwórz folder: `assets/images/events/`
2. Dodaj swoje zdjęcia (np. `park.jpg`, `schronisko.jpg`)

```
assets/
  images/
    events/
      park.jpg
      schronisko.jpg
      dzieci.jpg
      ...
```

#### Krok 2: Zaktualizuj `pubspec.yaml`

```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/logo.png
    - assets/images/mlody_krakow_vertical.png
    - assets/images/mlody_krakow_horizontal.png
    - assets/images/events/  # ← Dodaj tę linię
```

#### Krok 3: Użyj w kodzie

```dart
VolunteerEventModel(
  id: '1',
  title: 'Sprzątanie parku',
  // ... inne pola ...
  imageUrl: 'assets/images/events/park.jpg', // ← Ścieżka do lokalnego pliku
  createdAt: DateTime.now(),
),
```

## ✏️ Jak edytować istniejące wydarzenia?

Otwórz plik `lib/features/events/data/datasources/events_remote_data_source.dart` i zmodyfikuj listę:

```dart
@override
Future<List<VolunteerEventModel>> getEvents() async {
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    VolunteerEventModel(
      id: '1',
      title: 'Nowy tytuł wydarzenia',           // ← Edytuj
      description: 'Nowy opis...',              // ← Edytuj
      organization: 'Twoja organizacja',        // ← Edytuj
      location: 'Adres w Krakowie',             // ← Edytuj
      date: DateTime.now().add(const Duration(days: 7)), // ← Data
      requiredVolunteers: 15,                   // ← Liczba wolontariuszy
      categories: ['Środowisko', 'Sport'],      // ← Kategorie
      imageUrl: 'https://example.com/img.jpg',  // ← Zdjęcie
      createdAt: DateTime.now(),
    ),
    // Dodaj kolejne wydarzenia...
  ];
}
```

## 📅 Jak ustawić daty wydarzeń?

```dart
// Za 7 dni od teraz
date: DateTime.now().add(const Duration(days: 7)),

// Konkretna data i godzina
date: DateTime(2025, 10, 15, 14, 30), // 15 października 2025, 14:30

// Za 2 tygodnie
date: DateTime.now().add(const Duration(days: 14)),

// Jutro o 10:00
date: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 10, minute: 0),
```

## 🏷️ Dostępne kategorie

```dart
categories: [
  'Środowisko',
  'Zwierzęta',
  'Edukacja',
  'Kultura',
  'Pomoc społeczna',
  'Zdrowie',
  'Sport',
  'Technologia',
  'Renowacja',
  'Przyroda',
  'Społeczność lokalna',
  'Opieka',
]
```

## 🆕 Jak dodać nowe wydarzenie?

Dodaj nowy element do listy w metodzie `getEvents()`:

```dart
VolunteerEventModel(
  id: '99',  // Unikalny ID
  title: 'Twoje nowe wydarzenie',
  description: 'Szczegółowy opis tego co będzie się działo...',
  organization: 'Nazwa organizacji',
  location: 'Dokładny adres',
  date: DateTime(2025, 10, 20, 15, 0), // 20 października, 15:00
  requiredVolunteers: 10,
  categories: ['Kategoria1', 'Kategoria2'],
  imageUrl: 'https://images.unsplash.com/photo-XXXXXX?w=800',
  createdAt: DateTime.now(),
),
```

## 🔄 Jak zastosować zmiany?

1. **Wyczyść bazę danych** (aby załadować nowe wydarzenia):
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Usuń aplikację** z telefonu/emulatora

3. **Uruchom ponownie:**
   ```bash
   flutter run
   ```

## 💡 Wskazówki

### Rozmiar zdjęć
- Zalecana szerokość: **800-1200px**
- Format: **JPG** lub **PNG**
- Kompresja: używaj zoptymalizowanych zdjęć (nie za duże pliki)

### Przykładowe URL z Unsplash
```dart
// Wolontariat środowiskowy
'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=800'

// Zwierzęta/Schronisko
'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=800'

// Dzieci/Edukacja
'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800'

// Pomoc społeczna/Jedzenie
'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800'

// Seniorzy
'https://images.unsplash.com/photo-1581579438747-1dc8d17bbce4?w=800'
```

### Szukanie zdjęć na Unsplash
1. Wejdź na [unsplash.com](https://unsplash.com/)
2. Wyszukaj słowo kluczowe (np. "volunteer", "park", "children")
3. Kliknij zdjęcie
4. Kliknij prawym na zdjęcie → "Kopiuj adres obrazu"
5. Użyj skopiowanego URL w `imageUrl`

## 🚀 Przykład kompletnego wydarzenia

```dart
VolunteerEventModel(
  id: 'hackathon-2025',
  title: 'Hackathon dla Dobra',
  description: '''
    Organizujemy 24-godzinny hackathon, podczas którego programiści,
    designerzy i entuzjaści technologii będą tworzyć rozwiązania
    dla organizacji charytatywnych.
    
    Co zapewniamy:
    - Jedzenie i napoje przez całą dobę
    - Mentorów z branży IT
    - Nagrody dla zwycięzców
    - Networking z profesjonalistami
  ''',
  organization: 'Code for Kraków',
  location: 'AGH, al. Mickiewicza 30, Kraków',
  date: DateTime(2025, 11, 15, 9, 0),  // 15 listopada, 9:00
  endDate: DateTime(2025, 11, 16, 9, 0),  // Koniec: 16 listopada, 9:00
  requiredVolunteers: 50,
  currentVolunteers: 12,  // Już zapisanych
  categories: ['Technologia', 'Edukacja', 'Społeczność lokalna'],
  imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800',
  contactEmail: 'hackathon@codefor.krakow.pl',
  contactPhone: '+48 123 456 789',
  createdAt: DateTime.now(),
),
```

## ❓ Pytania?

Jeśli masz pytania lub problemy, sprawdź:
- `README.md` - podstawowe informacje o projekcie
- `PROJECT_ARCHITECTURE.md` - architektura aplikacji
- GitHub Issues - zgłoś problem lub zadaj pytanie

---

**Ważne:** Po dodaniu nowych wydarzeń pamiętaj o przeinstalowaniu aplikacji,
aby zmiany były widoczne (baza danych Isar jest persystentna).
