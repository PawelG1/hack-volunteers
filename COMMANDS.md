# Hack Volunteers - Komendy

## 📱 Uruchamianie aplikacji

### Podstawowe
```bash
flutter run                    # Debug mode (domyślny, najszybszy)
flutter run --debug           # Debug mode (jawnie)
flutter run --profile         # Profile mode (testowanie wydajności)
flutter run --release         # Release mode (NIE używaj podczas dev!)
```

### Z dodatkowymi opcjami
```bash
flutter run -v                # Verbose (więcej logów)
flutter run --hot             # Włącz hot reload (domyślnie włączony)
flutter run --no-hot          # Wyłącz hot reload
```

## ⚡ Hot Reload Commands (w działającej aplikacji)

```
r  - Hot reload (przeładuj zmiany - 1-3 sekundy)
R  - Hot restart (restart aplikacji - kilka sekund)
h  - Lista wszystkich komend
q  - Wyjście z aplikacji
```

## 🧹 Czyszczenie

```bash
flutter clean              # Wyczyść build
flutter pub get            # Pobierz zależności
./clean.sh                 # Pełne czyszczenie (custom script)
```

## 📦 Zarządzanie pakietami

```bash
flutter pub get            # Pobierz zależności
flutter pub upgrade        # Zaktualizuj pakiety
flutter pub outdated       # Zobacz przestarzałe pakiety
flutter pub add [package]  # Dodaj nowy pakiet
```

## 🔍 Analiza kodu

```bash
flutter analyze            # Sprawdź błędy
dart format .              # Sformatuj kod
dart format --fix .        # Sformatuj i napraw
```

## 🏗️ Budowanie

### Android
```bash
flutter build apk                 # APK (wszystkie architektury)
flutter build apk --split-per-abi # APK dla każdej architektury (mniejsze)
flutter build appbundle           # AAB (Google Play)
```

### Analiza rozmiaru
```bash
flutter build apk --analyze-size  # Sprawdź co zajmuje miejsce
```

## 🔧 Narzędzia

```bash
flutter doctor             # Sprawdź środowisko
flutter devices            # Lista podłączonych urządzeń
flutter emulators          # Lista dostępnych emulatorów
flutter emulators --launch [id]  # Uruchom emulator
```

## 🐛 Debugging

```bash
flutter logs               # Zobacz logi
flutter logs -v            # Verbose logi
```

## 📊 Performance

```bash
flutter run --profile                    # Profile mode
flutter run --trace-startup             # Trace startup
flutter run --enable-software-rendering # Software rendering
```

## 🧪 Testy (gdy będą dodane)

```bash
flutter test              # Uruchom testy jednostkowe
flutter test --coverage   # Z coverage
flutter drive             # Testy integracyjne
```

## 🚀 Custom Scripts (w tym projekcie)

```bash
./dev.sh                  # Menu szybkiego startu
./clean.sh                # Pełne czyszczenie cache
```

## 💡 Pro Tips

### Najszybszy workflow:
```bash
# 1. Uruchom raz
flutter run

# 2. Cały dzień używaj tylko:
# - Edytuj kod
# - Naciśnij 'r'
# - Gotowe!
```

### Gdy coś nie działa:
```bash
./clean.sh && flutter run
```

### Przed commitem:
```bash
dart format . && flutter analyze
```

### Sprawdź wydajność:
```bash
flutter run --profile
```
