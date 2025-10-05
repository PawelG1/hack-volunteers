# 9. Wymagania Techniczne

**Dokument:** 09_Wymagania_Techniczne.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 9.1. Wymagania sprzętowe - Urządzenie użytkownika

### 9.1.1. Minimalne wymagania

| Komponent | Wymaganie minimalne |
|-----------|---------------------|
| **System operacyjny** | Android 5.0 (Lollipop, API 21) |
| **Procesor** | Dual-core 1.0 GHz |
| **RAM** | 1 GB |
| **Pamięć wewnętrzna** | 100 MB wolnej przestrzeni |
| **Rozdzielczość ekranu** | 480x800 px (WVGA) |
| **Połączenie internetowe** | Wi-Fi lub 3G (dla map i synchronizacji) |
| **GPS** | Opcjonalnie (dla lokalizacji na mapie) |

### 9.1.2. Zalecane wymagania

| Komponent | Wymaganie zalecane |
|-----------|-------------------|
| **System operacyjny** | Android 10.0 lub nowszy (API 29+) |
| **Procesor** | Quad-core 1.5 GHz lub lepszy |
| **RAM** | 2 GB lub więcej |
| **Pamięć wewnętrzna** | 500 MB wolnej przestrzeni |
| **Rozdzielczość ekranu** | 1080x1920 px (Full HD) lub wyższa |
| **Połączenie internetowe** | Wi-Fi lub 4G/5G |
| **GPS** | Tak (dla pełnej funkcjonalności map) |

## 9.2. Wymagania programowe - Środowisko deweloperskie

### 9.2.1. Flutter SDK

| Komponent | Wersja |
|-----------|--------|
| **Flutter** | 3.9.0 lub nowsza |
| **Dart** | 3.0.0 lub nowsza |
| **Flutter Channel** | Stable |

### 9.2.2. Android SDK

| Komponent | Wersja |
|-----------|--------|
| **Android SDK Platform** | API 21 - API 36 |
| **Android SDK Build-Tools** | 34.0.0 |
| **Android SDK Command-line Tools** | Najnowsza |
| **Android SDK Platform-Tools** | Najnowsza |

### 9.2.3. Narzędzia deweloperskie

| Narzędzie | Wersja |
|-----------|--------|
| **Gradle** | 8.12 |
| **Kotlin** | 2.1.0 |
| **Java JDK** | 11 lub 17 |
| **Android Gradle Plugin** | 8.9.1 |
| **Git** | 2.x lub nowszy |

### 9.2.4. IDE (opcjonalnie)

| IDE | Wersja |
|-----|--------|
| **Android Studio** | Hedgehog 2023.1.1 lub nowszy |
| **Visual Studio Code** | 1.85.0 lub nowszy + Flutter extension |
| **IntelliJ IDEA** | 2023.2 lub nowszy |

## 9.3. Wymagania systemowe - Stacja deweloperska

### 9.3.1. Linux (Ubuntu/Debian)

| Komponent | Wymaganie |
|-----------|-----------|
| **System** | Ubuntu 20.04 LTS lub nowszy |
| **RAM** | Minimum 8 GB (zalecane 16 GB) |
| **Dysk** | 10 GB wolnej przestrzeni (SSD zalecany) |
| **Procesor** | Intel i5/AMD Ryzen 5 lub lepszy |

**Dodatkowe pakiety:**
```bash
sudo apt-get install curl git unzip xz-utils zip libglu1-mesa
```

### 9.3.2. Windows

| Komponent | Wymaganie |
|-----------|-----------|
| **System** | Windows 10 64-bit lub nowszy |
| **RAM** | Minimum 8 GB (zalecane 16 GB) |
| **Dysk** | 10 GB wolnej przestrzeni (SSD zalecany) |
| **Procesor** | Intel i5 lub lepszy |

### 9.3.3. macOS

| Komponent | Wymaganie |
|-----------|-----------|
| **System** | macOS 10.15 Catalina lub nowszy |
| **RAM** | Minimum 8 GB (zalecane 16 GB) |
| **Dysk** | 10 GB wolnej przestrzeni (SSD zalecany) |
| **Procesor** | Intel lub Apple Silicon |

## 9.4. Zależności Flutter (pubspec.yaml)

### 9.4.1. Dependencies (produkcyjne)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  equatable: ^2.0.8
  
  # Database
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.5
  
  # Routing
  go_router: ^14.8.1
  
  # Dependency Injection
  get_it: ^7.7.0
  
  # Network
  dartz: ^0.10.1
  
  # UI
  intl: ^0.19.0
  image_picker: ^1.1.2
  shared_preferences: ^2.3.3
  
  # Maps
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
```

### 9.4.2. Dev Dependencies (deweloperskie)

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  
  # Code generation
  build_runner: ^2.4.13
  isar_generator: ^3.1.0+1
  
  # Testing
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
```

## 9.5. Wymagania sieciowe

### 9.5.1. Porty i protokoły

| Usługa | Protokół | Port | Cel |
|--------|----------|------|-----|
| **OpenStreetMap** | HTTPS | 443 | Pobieranie kafelków mapy |
| **Isar Inspector** | HTTP | 40015 | Debugowanie bazy danych (dev) |
| **Flutter DevTools** | HTTP | 9101 | Narzędzia deweloperskie (dev) |

### 9.5.2. Domeny zewnętrzne

- `tile.openstreetmap.org` - Kafelki mapy
- `pub.dev` - Repozytorium pakietów Dart/Flutter
- `github.com` - Repozytorium kodu (opcjonalnie)

## 9.6. Uprawnienia aplikacji (Android)

### 9.6.1. Wymagane uprawnienia

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 9.6.2. Uprawnienia opcjonalne

```xml
<!-- Dla zdjęć (Android <= 12) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />

<!-- Dla zdjęć (Android >= 13) -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

## 9.7. Wymagania dotyczące bazy danych

### 9.7.1. Isar Database

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 3.1.0+1 |
| **Typ** | NoSQL (obiektowa) |
| **Rozmiar maksymalny** | Ograniczony pamięcią urządzenia |
| **Szyfrowanie** | Brak (dane lokalne) |
| **Indeksy** | Tak (na ID i innych polach) |

### 9.7.2. Wymagania pamięci

- Minimalna wolna przestrzeń: 50 MB
- Zalecana wolna przestrzeń: 200 MB
- Maksymalny rozmiar bazy: ~100 MB (w praktyce)

## 9.8. Wymagania wydajnościowe

### 9.8.1. Czas odpowiedzi

| Operacja | Maksymalny czas |
|----------|----------------|
| **Uruchomienie aplikacji** | < 3 sekundy |
| **Przełączanie ekranów** | < 500 ms |
| **Ładowanie listy wydarzeń** | < 1 sekunda |
| **Zapisywanie danych** | < 500 ms |
| **Ładowanie mapy** | < 2 sekundy |

### 9.8.2. Płynność UI

- **Frame rate:** Minimum 30 FPS, zalecane 60 FPS
- **Brak jankingu:** Scrollowanie list płynne
- **Animacje:** Płynne przejścia między ekranami

## 9.9. Kompatybilność

### 9.9.1. Wersje Android

| Wersja Android | API Level | Status wsparcia |
|----------------|-----------|-----------------|
| Android 5.0 (Lollipop) | 21 | ✅ Wspierane (minimum) |
| Android 6.0 (Marshmallow) | 23 | ✅ Wspierane |
| Android 7.0 (Nougat) | 24 | ✅ Wspierane |
| Android 8.0 (Oreo) | 26 | ✅ Wspierane |
| Android 9.0 (Pie) | 28 | ✅ Wspierane |
| Android 10 | 29 | ✅ Wspierane (zalecane) |
| Android 11 | 30 | ✅ Wspierane |
| Android 12 | 31 | ✅ Wspierane |
| Android 13 | 33 | ✅ Wspierane |
| Android 14 | 34 | ✅ Wspierane |
| Android 15 | 35 | ✅ Wspierane |
| Android 16 (beta) | 36 | ✅ Wspierane (target) |

### 9.9.2. Architektury procesora

- ✅ ARM64-v8a (64-bit ARM)
- ✅ ARMv7 (32-bit ARM)
- ✅ x86 (32-bit Intel)
- ✅ x86_64 (64-bit Intel)

### 9.9.3. Rozdzielczości ekranu

- ✅ ldpi (120 dpi)
- ✅ mdpi (160 dpi)
- ✅ hdpi (240 dpi)
- ✅ xhdpi (320 dpi)
- ✅ xxhdpi (480 dpi)
- ✅ xxxhdpi (640 dpi)

## 9.10. Wymagania bezpieczeństwa

### 9.10.1. Signing (podpisywanie)

- **Debug:** Automatyczny klucz debug
- **Release:** Wymagany własny keystore

### 9.10.2. Obfuskacja

- **ProGuard/R8:** Opcjonalny (zalecany dla produkcji)
- **Shrinking:** Opcjonalny (zmniejsza rozmiar APK)

### 9.10.3. Permissions

- **Runtime permissions:** Obsługiwane (dla Android 6.0+)
- **Storage access:** Scoped storage (Android 10+)

## 9.11. Wymagania dla trybu offline

### 9.11.1. Funkcjonalność offline

| Funkcja | Dostępność offline |
|---------|-------------------|
| **Przeglądanie wydarzeń** | ✅ Tak (z cache) |
| **Aplikowanie na wydarzenie** | ⚠️ Wymaga synchronizacji |
| **Przeglądanie certyfikatów** | ✅ Tak |
| **Mapa** | ❌ Nie (wymaga internetu) |
| **Profil użytkownika** | ✅ Tak |

### 9.11.2. Synchronizacja

- **Strategia:** Automatyczna przy dostępności sieci
- **Częstotliwość:** On-demand lub przy starcie aplikacji
- **Obsługa konfliktów:** Ostatnia zmiana wygrywa

## 9.12. Wymagania lokalizacyjne

### 9.12.1. Język

- **Podstawowy:** Polski
- **Formatowanie dat:** pl_PL
- **Waluta:** PLN (jeśli dotyczy)

### 9.12.2. Strefa czasowa

- **Domyślna:** Europe/Warsaw (UTC+1/+2)
- **Format czasu:** 24-godzinny

## 9.13. Wymagania dostępności

### 9.13.1. Accessibility

- **TalkBack:** Wspierane (etykiety na przyciskach)
- **Kontrast:** Minimum 4.5:1 (WCAG AA)
- **Rozmiar czcionki:** Responsywny (systemowe ustawienia)

### 9.13.2. Orientacja ekranu

- **Portrait:** ✅ Pełne wsparcie
- **Landscape:** ✅ Pełne wsparcie (adaptacyjny layout)

## 9.14. Środowisko produkcyjne

### 9.14.1. Build configuration

```kotlin
buildTypes {
    release {
        minifyEnabled = false
        shrinkResources = false
        signingConfig = signingConfigs.release
    }
}
```

### 9.14.2. ProGuard rules (opcjonalne)

```proguard
# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }

# Isar
-keep class io.isar.** { *; }
```

## 9.15. Monitoring i diagnostyka

### 9.15.1. Logowanie

- **Level:** Debug, Info, Warning, Error
- **Persistence:** Tylko w pamięci (nie zapisywane)
- **Rotating:** N/A (aplikacja mobilna)

### 9.15.2. Crash reporting

- **Obecnie:** Brak (do rozważenia: Firebase Crashlytics)
- **Logi:** Flutter framework errors

## 9.16. Testowanie

### 9.16.1. Urządzenia testowe

Minimalne urządzenia do testowania:
- 1x urządzenie z Android 5.0-7.0 (stary telefon)
- 1x urządzenie z Android 10-12 (średniak)
- 1x urządzenie z Android 13+ (nowoczesny)

### 9.16.2. Emulatory

```bash
# Tworzenie emulatora AVD
flutter emulators --create

# Lista emulatorów
flutter emulators
```

## 9.17. Continuous Integration (CI)

### 9.17.1. GitHub Actions (przykład)

```yaml
name: Build APK
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v2
        with:
          java-version: '11'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.0'
      - run: flutter pub get
      - run: flutter build apk --release
```

## 9.18. Wymagania licencyjne

### 9.18.1. Licencje open-source

Wszystkie wykorzystane biblioteki mają licencje kompatybilne z dystrybucją:
- Flutter: BSD-3-Clause
- Isar: Apache 2.0
- flutter_map: BSD-3-Clause
- Pozostałe: MIT, Apache 2.0, BSD

**Szczegóły:** Zobacz `19_Licencje.md`

---

## 9.19. ⚠️ WYŁĄCZENIE ODPOWIEDZIALNOŚCI I GWARANCJI

### 9.19.1. Disclaimer techniczny

**APLIKACJA I DOKUMENTACJA SĄ DOSTARCZANE "TAK JAK JEST" (AS IS)**

Autorzy, programiści i właściciele **NIE GWARANTUJĄ**:

**Wydajność:**
- ❌ Działania bez błędów lub przerw
- ❌ Osiągnięcia określonych wyników wydajnościowych
- ❌ Kompatybilności ze wszystkimi urządzeniami Android
- ❌ Poprawnego działania na wszystkich wersjach systemu

**Bezpieczeństwo:**
- ❌ Całkowitej ochrony danych użytkowników
- ❌ Braku luk bezpieczeństwa
- ❌ Odporności na ataki hakerskie
- ❌ Zgodności z RODO w każdej konfiguracji

**Niezawodność:**
- ❌ Dostępności 24/7
- ❌ Zachowania danych w przypadku awarii
- ❌ Poprawności map (zależne od OpenStreetMap)
- ❌ Działania offline we wszystkich funkcjach

**Dokładność:**
- ❌ Precyzji liczenia godzin wolontariatu
- ❌ Poprawności generowanych certyfikatów
- ❌ Dokładności geolokalizacji
- ❌ Kompletności informacji o wydarzeniach

### 9.19.2. Ograniczenie odpowiedzialności

**AUTORZY I WŁAŚCICIELE NIE PONOSZĄ ODPOWIEDZIALNOŚCI ZA:**

1. **Szkody bezpośrednie:**
   - Utratę danych z bazy Isar
   - Nieprawidłowe działanie aplikacji
   - Błędy w certyfikatach lub raportach
   - Awarie spowodowane aktualizacjami Android

2. **Szkody pośrednie:**
   - Utracone zyski lub oszczędności
   - Przerwę w działalności organizacji
   - Szkody reputacyjne
   - Koszty zastępczych rozwiązań

3. **Problemy zewnętrzne:**
   - Niedostępność OpenStreetMap
   - Zmiany w API Google Play
   - Problemy z połączeniem internetowym użytkownika
   - Niezgodność z przyszłymi wersjami Android

4. **Decyzje użytkowników:**
   - Nieprawidłową konfigurację systemu
   - Użycie niezgodne z dokumentacją
   - Brak regularnych backupów danych
   - Instalację na niewspieranych urządzeniach

### 9.19.3. Wymagania od użytkownika

**UŻYTKOWNIK JEST ZOBOWIĄZANY DO:**

✅ **Przed wdrożeniem:**
- Przeprowadzenia własnych testów w środowisku docelowym
- Weryfikacji zgodności z lokalnymi przepisami (RODO, prawo pracy)
- Konsultacji z prawnikiem w zakresie odpowiedzialności
- Przygotowania planu backupów i disaster recovery

✅ **Podczas eksploatacji:**
- Regularnego tworzenia kopii zapasowych bazy Isar
- Monitorowania działania aplikacji
- Stosowania się do best practices bezpieczeństwa
- Szkolenia użytkowników końcowych

✅ **W zakresie prawnym:**
- Samodzielnej oceny ryzyka prawnego
- Zapewnienia zgodności z RODO (jeśli wymagane)
- Uzyskania zgód użytkowników na przetwarzanie danych
- Prowadzenia dokumentacji przetwarzania danych osobowych

### 9.19.4. Środki ostrożności

**ZALECAMY:**

⚠️ **Nie używać aplikacji jako jedynego źródła danych** o wolontariatach  
⚠️ **Nie polegać wyłącznie na certyfikatach** generowanych przez aplikację  
⚠️ **Nie przechowywać krytycznych danych** tylko lokalnie (brak cloud backup)  
⚠️ **Nie zakładać 100% dostępności** mapy (zależność od OSM)  
⚠️ **Testować aktualizacje** przed wdrożeniem produkcyjnym  
⚠️ **Mieć plan B** na wypadek awarii aplikacji

### 9.19.5. Brak wsparcia technicznego

**BRAK GWARANCJI WSPARCIA:**

❌ Autorzy nie są zobowiązani do:
- Naprawiania zgłoszonych błędów
- Udzielania pomocy technicznej
- Wydawania aktualizacji
- Dostosowywania do nowych wersji Android
- Odpowiadania na pytania użytkowników
- Szkoleń lub konsultacji

✅ Wszelkie poprawki i aktualizacje są wydawane **DOBROWOLNIE** i **BEZ GWARANCJI TERMINÓW**.

### 9.19.6. Zgoda użytkownika

**INSTALUJĄC LUB UŻYWAJĄC APLIKACJI, UŻYTKOWNIK:**

1. ✅ Potwierdza, że przeczytał niniejszy dokument
2. ✅ Akceptuje wszystkie wyłączenia odpowiedzialności
3. ✅ Przyjmuje na siebie całkowite ryzyko użytkowania
4. ✅ Zrzeka się roszczeń wobec autorów i właścicieli
5. ✅ Zobowiązuje się do samodzielnej weryfikacji zgodności prawnej

**W przypadku braku akceptacji powyższych warunków, użytkownik NIE POWINIEN instalować ani używać aplikacji.**

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga  
**Status prawny:** Wyłączenie odpowiedzialności w maksymalnym zakresie dozwolonym przez prawo
