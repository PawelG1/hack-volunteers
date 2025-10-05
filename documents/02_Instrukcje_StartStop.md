# 2. Instrukcje Start/Stop

**Dokument:** 02_Instrukcje_StartStop.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 2.1. Wprowadzenie

Niniejszy dokument opisuje procedury uruchamiania i zatrzymywania aplikacji SmokPomaga oraz wszystkich jej zależności.

## 2.2. Wymagania wstępne

Przed uruchomieniem aplikacji upewnij się, że spełnione są następujące wymagania:

- Zainstalowany Flutter SDK (wersja 3.9.0 lub nowsza)
- Android SDK z API level 21-36
- Gradle 8.12 lub nowszy
- Java JDK 11 lub nowszy
- Urządzenie Android lub emulator

## 2.3. START - Uruchomienie środowiska deweloperskiego

### 2.3.1. Przygotowanie środowiska

```bash
# 1. Przejdź do katalogu projektu
cd /path/to/hack_volunteers

# 2. Zainstaluj zależności Flutter
flutter pub get

# 3. Sprawdź środowisko
flutter doctor

# 4. Sprawdź dostępne urządzenia
flutter devices
```

### 2.3.2. Uruchomienie w trybie DEBUG

```bash
# Uruchomienie na podłączonym urządzeniu Android
flutter run

# Uruchomienie na konkretnym urządzeniu
flutter run -d <device_id>

# Uruchomienie z hot reload
flutter run --hot
```

**Oczekiwany output:**
```
✓ Built build/app/outputs/flutter-apk/app-debug.apk
Installing build/app/outputs/flutter-apk/app-debug.apk...
Syncing files to device...
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
```

### 2.3.3. Uruchomienie w trybie RELEASE

```bash
# Build i uruchomienie release
flutter run --release

# Build APK release (bez instalacji)
flutter build apk --release

# Build App Bundle (Google Play)
flutter build appbundle --release
```

**Lokalizacja plików:**
- APK Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- APK Release: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### 2.3.4. Uruchomienie z czystym buildem

```bash
# Wyczyść poprzednie buildy
flutter clean

# Pobierz zależności
flutter pub get

# Zbuduj i uruchom
flutter run --release
```

## 2.4. START - Uruchomienie bazy danych Isar

### 2.4.1. Automatyczne uruchomienie

Baza danych Isar uruchamia się automatycznie przy starcie aplikacji.

**Lokalizacja inicjalizacji:** `lib/main.dart`

```dart
// Inicjalizacja Isar
final isar = await Isar.open([
  VolunteerEventIsarModelSchema,
  CertificateSchema,
  VolunteerApplicationSchema,
  UserIsarModelSchema,
]);
```

### 2.4.2. Weryfikacja połączenia

Po uruchomieniu aplikacji w konsoli powinien pojawić się komunikat:

```
╔══════════════════════════════════════════════════════╗
║                 ISAR CONNECT STARTED                 ║
╟──────────────────────────────────────────────────────╢
║ https://inspect.isar.dev/3.1.0+1/#/...              ║
╚══════════════════════════════════════════════════════╝
```

### 2.4.3. Isar Inspector (tryb debug)

```bash
# Uruchom aplikację w trybie debug
flutter run

# Otwórz link do Isar Inspector
# Link pojawi się w konsoli po uruchomieniu
```

## 2.5. START - Seed danych testowych

### 2.5.1. Automatyczny seed

Dane testowe są automatycznie dodawane przy pierwszym uruchomieniu.

**Lokalizacja:** `lib/core/utils/seed_data.dart`

**Seedowane dane:**
- 2 przykładowe certyfikaty
- 2 przykładowe aplikacje wolontariackie
- 17 wydarzeń wolontariackich

### 2.5.2. Logi seedowania

```
🌱 SEED: Checking if certificates need to be seeded...
🌱 SEED: Created 2 sample certificates
🌱 SEED: Checking if test applications need to be seeded...
🌱 SEED: Created 2 test applications
```

## 2.6. STOP - Zatrzymanie aplikacji

### 2.6.1. Zatrzymanie w trybie debug

**Z terminala Flutter:**
```bash
# Naciśnij 'q' w terminalu
q

# Lub użyj Ctrl+C
Ctrl+C
```

**Z urządzenia:**
- Zamknij aplikację przyciskiem Back/Home
- Usuń z listy ostatnio używanych aplikacji

### 2.6.2. Zatrzymanie w trybie release

**Z urządzenia:**
- Wyjdź z aplikacji (przycisk Back)
- Lub wymuś zamknięcie w ustawieniach systemu

**Z ADB:**
```bash
# Zatrzymaj aplikację
adb shell am force-stop com.example.hack_volunteers
```

### 2.6.3. Zatrzymanie bazy danych

Baza danych Isar zamyka się automatycznie przy zamknięciu aplikacji.

**Ręczne zamknięcie (w kodzie):**
```dart
await isar.close();
```

## 2.7. RESTART - Ponowne uruchomienie

### 2.7.1. Hot Reload (tylko debug)

```bash
# W działającej aplikacji naciśnij 'r'
r

# Pełny restart (R)
R
```

### 2.7.2. Cold Restart

```bash
# Zatrzymaj aplikację
q

# Uruchom ponownie
flutter run
```

### 2.7.3. Restart z czystym stanem

```bash
# Odinstaluj aplikację
flutter run --uninstall-first

# Lub ręcznie przez ADB
adb uninstall com.example.hack_volunteers

# Zainstaluj i uruchom ponownie
flutter run
```

## 2.8. START - Gradle Daemon

### 2.8.1. Uruchomienie Gradle

Gradle Daemon uruchamia się automatycznie podczas budowania.

**Ręczne uruchomienie:**
```bash
cd android
./gradlew
cd ..
```

### 2.8.2. STOP - Zatrzymanie Gradle Daemon

```bash
cd android
./gradlew --stop
cd ..
```

## 2.9. Czyszczenie środowiska

### 2.9.1. Flutter Clean

```bash
# Usuń pliki build
flutter clean

# Usuń również pub cache (opcjonalne)
flutter pub cache clean
```

### 2.9.2. Gradle Clean

```bash
cd android
./gradlew clean
cd ..
```

### 2.9.3. Pełne czyszczenie

```bash
# Flutter clean
flutter clean

# Gradle clean
cd android && ./gradlew clean && cd ..

# Usuń pliki konfiguracyjne (opcjonalne)
rm -rf .dart_tool
rm -rf build
rm -rf android/app/build
rm -rf android/.gradle

# Ponownie pobierz zależności
flutter pub get
```

## 2.10. Diagnostyka problemów

### 2.10.1. Sprawdzenie statusu

```bash
# Status Flutter
flutter doctor -v

# Lista urządzeń
flutter devices

# Logi z urządzenia
flutter logs

# Logi ADB
adb logcat | grep flutter
```

### 2.10.2. Restart ADB

```bash
# Zatrzymaj serwer ADB
adb kill-server

# Uruchom ponownie
adb start-server

# Sprawdź urządzenia
adb devices
```

### 2.10.3. Problemy z buildem

```bash
# Wyczyść wszystko
flutter clean
cd android && ./gradlew clean && cd ..

# Usuń lock files
rm pubspec.lock
rm android/.gradle -rf

# Ponownie pobierz i zbuduj
flutter pub get
flutter build apk
```

## 2.11. Procedury awaryjne

### 2.11.1. Awaria podczas startu

1. Sprawdź logi: `flutter logs`
2. Zweryfikuj uprawnienia w AndroidManifest.xml
3. Sprawdź czy Isar database się inicjalizuje
4. Sprawdź dostępność pamięci urządzenia

### 2.11.2. Awaria bazy danych

1. Usuń bazę danych:
```bash
adb shell run-as com.example.hack_volunteers
cd app_flutter
rm hack_volunteers.isar
```

2. Uruchom aplikację ponownie (database zostanie utworzona)

### 2.11.3. Awaria Gradle

1. Zatrzymaj Gradle Daemon: `./gradlew --stop`
2. Wyczyść cache: `./gradlew clean --no-daemon`
3. Usuń .gradle: `rm -rf android/.gradle`
4. Zbuduj ponownie: `flutter build apk`

## 2.12. Monitorowanie

### 2.12.1. Logi aplikacji

```bash
# Wszystkie logi
flutter logs

# Filtrowanie po tagu
flutter logs | grep "SEED"
flutter logs | grep "ERROR"
```

### 2.12.2. Performance monitoring

```bash
# Włącz DevTools
flutter pub global run devtools

# Lub otwórz z running app
# Link pojawi się w konsoli
```

## 2.13. Sekwencja pełnego restartu systemu

```bash
# 1. STOP wszystkich procesów
adb shell am force-stop com.example.hack_volunteers
cd android && ./gradlew --stop && cd ..

# 2. CLEAN
flutter clean
cd android && ./gradlew clean && cd ..

# 3. GET dependencies
flutter pub get

# 4. START
flutter run --release
```

## 2.14. Checklist Start/Stop

### Przed startem:
- [ ] Flutter doctor zwraca ✓
- [ ] Urządzenie jest podłączone
- [ ] Wystarczająca ilość pamięci (>500MB)
- [ ] Połączenie internetowe (dla map)

### Po starcie:
- [ ] Aplikacja się uruchomiła
- [ ] Isar Connect message pojawił się
- [ ] Seed data został załadowany
- [ ] Brak błędów w logach

### Przed stopem:
- [ ] Zapisane wszystkie zmiany
- [ ] Zamknięte wszystkie dialogi
- [ ] Brak aktywnych operacji na bazie

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
