# 🚀 Optymalizacja czasu budowania

Jeśli aplikacja buduje się długo, spróbuj tych rozwiązań:

## ⚡ Szybkie rozwiązania

### 1. Użyj trybu Debug (nie Release!)
```bash
flutter run --debug  # Szybkie, z hot reload
```

### 2. Hot Reload podczas developmentu
Po pierwszym buildzie, używaj:
- `r` - Hot reload (sekundy)
- `R` - Hot restart (kilka sekund)
- `q` - Wyjście

### 3. Użyj skryptów pomocniczych
```bash
# Szybki start w trybie debug
./dev.sh

# Czyszczenie cache (gdy coś nie działa)
./clean.sh
```

## 🔧 Stałe optymalizacje

### 1. Gradle properties (Android)
Plik `android/gradle.properties` został zoptymalizowany:
- Parallel build
- Daemon mode
- Caching włączony
- Incremental compilation

### 2. Usunięte nieużywane zależności
- ❌ `injectable` + `injectable_generator` (nie używamy)
- ❌ `build_runner` (nie potrzebujemy)
- ❌ `appinio_swiper` (nie używamy)
- ❌ `flutter_card_swiper` (nie używamy)
- ❌ `mockito` (testy później)

### 3. Co zostało:
- ✅ `flutter_bloc` - zarządzanie stanem
- ✅ `get_it` - dependency injection (manualne)
- ✅ `equatable` - porównywanie obiektów
- ✅ `dartz` - Either dla error handling
- ✅ `intl` - formatowanie dat

## 📊 Czasy buildowania

### Pierwszy build (cold start):
- **Debug**: ~2-4 minuty
- **Release**: ~5-10 minut

### Kolejne buildy (hot reload):
- **Hot reload**: 1-3 sekundy ⚡
- **Hot restart**: 5-10 sekund
- **Full rebuild**: ~30 sekund - 2 minuty

## 💡 Pro Tips

### 1. Zawsze używaj Debug podczas developmentu
```bash
flutter run  # Domyślnie debug
```

### 2. Nigdy nie używaj Release podczas developmentu
```bash
flutter run --release  # Tylko do testowania wydajności!
```

### 3. Wykorzystuj Hot Reload
- Zmień kod
- Naciśnij `r` w terminalu
- Gotowe w sekundę! ⚡

### 4. Gdy coś nie działa - wyczyść cache
```bash
./clean.sh
# lub
flutter clean && flutter pub get
```

### 5. Sprawdź co spowalnia
```bash
# Android
flutter build apk --analyze-size

# Verbose build
flutter run -v
```

## 🐛 Typowe problemy

### Problem: "Build trwa wieki"
**Rozwiązanie:**
1. Upewnij się że używasz `--debug` nie `--release`
2. Wyczyść cache: `./clean.sh`
3. Zrestartuj VS Code / IDE

### Problem: "Out of memory podczas buildu"
**Rozwiązanie:**
1. Zwiększ pamięć w `android/gradle.properties`
2. Zamknij inne aplikacje
3. Użyj: `flutter build apk --split-per-abi`

### Problem: "Gradle daemon nie działa"
**Rozwiązanie:**
```bash
cd android
./gradlew --stop
./gradlew clean
cd ..
flutter run
```

## 🎯 Optymalne workflow developmentu

1. **Pierwszy raz**:
   ```bash
   flutter pub get
   flutter run --debug
   ```

2. **Podczas developmentu**:
   - Edytuj kod
   - Naciśnij `r` (hot reload) ⚡
   - Testuj

3. **Gdy dodajesz nowe pliki**:
   - Naciśnij `R` (hot restart)
   
4. **Przed commitem**:
   ```bash
   flutter analyze
   dart format .
   ```

5. **Testowanie wydajności** (rzadko):
   ```bash
   flutter run --profile
   ```

## 📱 Testowanie na urządzeniu vs emulator

### Emulator:
- ✅ Szybszy development
- ✅ Łatwe debugowanie
- ❌ Wolniejszy build (symulacja)

### Fizyczne urządzenie:
- ✅ Prawdziwa wydajność
- ✅ Szybsze wykonanie
- ❌ Wymaga połączenia

## 🚀 Kolejne optymalizacje

Gdy dodamy Isar/Firebase:
- Użyj lazy loading
- Cache'uj dane lokalnie
- Async operations
- Pagination dla dużych list
