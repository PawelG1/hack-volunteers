# 🤝 Hack Volunteers

Aplikacja mobilna do wybierania wydarzeń wolontariackich z mechaniką swipe'owania w stylu Tinder.

## ⚡ SZYBKI START

```bash
# 1. Pobierz zależności
flutter pub get

# 2. Uruchom aplikację (tryb DEBUG - szybki!)
flutter run

# 3. Po uruchomieniu - edytuj kod i naciśnij 'r' dla Hot Reload!
```

📖 **Więcej szczegółów**: [QUICK_START.md](QUICK_START.md)

## 🎯 O projekcie

Hack Volunteers to aplikacja pomagająca znaleźć idealne wydarzenia wolontariackie. Wystarczy swipe'ować:
- 👉 **W prawo** = Interesuję się!
- 👈 **W lewo** = Pomiń

## 🏗️ Architektura

Projekt zbudowany zgodnie z:
- ✅ **Clean Architecture** (Domain, Data, Presentation)
- ✅ **SOLID Principles**
- ✅ **BLoC Pattern** dla zarządzania stanem
- ✅ **Dependency Injection** (GetIt)

📖 **Szczegółowa dokumentacja**: [PROJECT_ARCHITECTURE.md](PROJECT_ARCHITECTURE.md)

## 📚 Dokumentacja

- 🚀 [**QUICK_START.md**](QUICK_START.md) - Jak najszybciej zacząć
- 🏗️ [**PROJECT_ARCHITECTURE.md**](PROJECT_ARCHITECTURE.md) - Architektura i struktura
- ⚡ [**OPTIMIZATION.md**](OPTIMIZATION.md) - Optymalizacja czasu budowania
- 💻 [**COMMANDS.md**](COMMANDS.md) - Wszystkie przydatne komendy

## 🚀 Funkcjonalności

### ✅ Zrealizowane (v0.1.0)

- [x] Mechanika swipe'owania wydarzeń
- [x] Wyświetlanie szczegółów wydarzenia
- [x] Zapisywanie zainteresowań (in-memory)
- [x] Clean Architecture z SOLID
- [x] BLoC pattern dla stanu
- [x] Responsywny design
- [x] Mock data (5 wydarzeń)

### 🔜 Planowane

- [ ] Integracja z Isar (lokalna baza danych)
- [ ] Firebase Authentication
- [ ] Cloud Firestore (zdalne wydarzenia)
- [ ] Lista moich zainteresowań
- [ ] Filtrowanie wydarzeń
- [ ] Powiadomienia
- [ ] Profil użytkownika

## 🛠️ Technologie

- **Flutter** 3.9+ - Framework UI
- **Dart** 3.9+ - Język programowania
- **flutter_bloc** - Zarządzanie stanem
- **get_it** - Dependency Injection
- **dartz** - Functional programming (Either)
- **equatable** - Porównywanie obiektów
- **intl** - Formatowanie dat

## 💡 Development Tips

### Hot Reload - Twój najlepszy przyjaciel! 🔥

```bash
# Uruchom aplikację raz
flutter run

# Potem przez cały dzień:
# 1. Edytuj kod
# 2. Zapisz (Ctrl+S)
# 3. Naciśnij 'r' w terminalu
# 4. Zmiany widoczne w 1-3 sekundy!
```

### Custom Scripts

```bash
./dev.sh      # Menu szybkiego startu
./clean.sh    # Czyszczenie cache
```

### ⚠️ WAŻNE: Nigdy nie używaj `--release` podczas developmentu!

```bash
❌ flutter run --release  # Buduje się 5-10 minut!
✅ flutter run            # Buduje się 2-4 minuty (pierwszym razem)
✅ Hot Reload (r)         # 1-3 sekundy! ⚡
```

## 🧪 Testowanie

```bash
# Analiza kodu
flutter analyze

# Formatowanie
dart format .

# Testy (gdy będą dodane)
flutter test
```

## 🐛 Znane problemy i rozwiązania

### Problem: "Aplikacja buduje się długo"
**Rozwiązanie**: 
1. Użyj `flutter run` (nie `--release`)
2. Po pierwszym buildzie używaj Hot Reload (`r`)
3. Zobacz pełny guide: [OPTIMIZATION.md](OPTIMIZATION.md)

### Problem: "Out of memory"
**Rozwiązanie**: 
1. Wyczyść cache: `./clean.sh`
2. Restartuj IDE

## 📄 Licencja

Projekt edukacyjny - Hack Volunteers

---

**Made with ❤️ for volunteers**
