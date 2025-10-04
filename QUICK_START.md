# ⚡ SZYBKI START - Hack Volunteers

## 🎯 Najszybsza ścieżka do działającej aplikacji

### 1. Pierwsze uruchomienie (jednorazowo)

```bash
# Wyczyść i pobierz zależności
flutter clean
flutter pub get

# Uruchom w trybie DEBUG (szybki!)
flutter run --debug
```

### 2. Codzienny development (najszybsza metoda)

```bash
# Uruchom raz aplikację
flutter run

# Potem w aplikacji:
# - Edytuj kod
# - Naciśnij 'r' w terminalu → Hot Reload (1-3 sekundy!)
# - Naciśnij 'R' w terminalu → Hot Restart (gdy dodajesz nowe pliki)
```

### 3. Używanie skryptów pomocniczych

```bash
# Szybki start z menu wyboru
./dev.sh

# Czyszczenie cache (gdy coś nie działa)
./clean.sh
```

## 💡 WAŻNE: Tryby budowania

| Tryb | Czas buildu | Kiedy używać |
|------|-------------|--------------|
| **Debug** | 2-4 min | ✅ Cały czas podczas developmentu |
| Profile | 5-8 min | Testowanie wydajności |
| Release | 5-10 min | ❌ NIGDY podczas developmentu! |

## ⚡ Hot Reload = Magia Flutter

Po pierwszym uruchomieniu:

1. Zmieniasz kod w VS Code
2. Zapisujesz (Ctrl+S)
3. Naciskasz `r` w terminalu Flutter
4. **Zmiany widoczne w 1-3 sekundy!** 🚀

**Nie trzeba restartować aplikacji!**

## 🚨 Typowe błędy

### ❌ BŁĄD: Używanie `flutter run --release`
**TO ZABIERA 5-10 MINUT!**

✅ **PRAWIDŁOWO**: `flutter run` (domyślnie debug)

### ❌ BŁĄD: Rebuild całej aplikacji po każdej zmianie
**NIE TRZEBA!**

✅ **PRAWIDŁOWO**: Użyj Hot Reload (`r`)

### ❌ BŁĄD: Zamykanie aplikacji po każdej zmianie
**TO zabiera czas!**

✅ **PRAWIDŁOWO**: Zostaw uruchomioną, używaj `r` / `R`

## 📊 Co zoptymalizowaliśmy

1. ✅ Usunięto nieużywane pakiety (5 pakietów mniej!)
2. ✅ Zoptymalizowano Gradle (parallel builds, caching)
3. ✅ Dodano skrypty pomocnicze
4. ✅ Zmniejszono alokację pamięci (8G → 4G)

## 🎓 Workflow eksperta

```bash
# 1. Rano - uruchom raz
flutter run

# 2. Cały dzień - tylko hot reload
# Edytujesz → Ctrl+S → 'r' → Gotowe!

# 3. Nowy plik/duże zmiany - hot restart
# 'R' w terminalu

# 4. Wieczorem - commit
flutter analyze
dart format .
git add .
git commit -m "Feature: ..."
```

## 🚀 Następne kroki

Po opanowaniu Hot Reload, możesz:
1. Dodać Isar (lokalna baza)
2. Dodać Firebase (remote data)
3. Dodać więcej ekranów
4. Dodać testy

Wszystko z Hot Reload będzie **super szybkie!** ⚡

---

**Zapamiętaj**: Flutter + Hot Reload = Najszybszy development na świecie! 🔥
