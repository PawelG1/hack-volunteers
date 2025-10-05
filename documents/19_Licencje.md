# 19. Licencje

**Dokument:** 19_Licencje.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 19.1. Przegląd

Niniejszy dokument zawiera informacje o licencjach wykorzystanych w projekcie SmokPomaga, w tym licencję główną aplikacji oraz wszystkie licencje bibliotek zewnętrznych.

---

## 19.2. Licencja aplikacji SmokPomaga

### 19.2.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Nazwa aplikacji** | SmokPomaga |
| **Właściciel** | Młody Kraków / Urząd Miasta Krakowa |
| **Licencja** | Proprietary (własnościowa) |
| **Rok** | 2025 |

### 19.2.2. Treść licencji

```
Copyright © 2025 Młody Kraków / Urząd Miasta Krakowa

Wszelkie prawa zastrzeżone.

Niniejsza aplikacja oraz jej kod źródłowy są własnością
programu Młody Kraków oraz Urzędu Miasta Krakowa.

Bez pisemnej zgody właścicieli zabronione jest:
- Kopiowanie kodu źródłowego
- Modyfikowanie aplikacji
- Dystrybucja aplikacji lub jej części
- Tworzenie dzieł pochodnych
- Komercyjne wykorzystanie

WYŁĄCZENIE ODPOWIEDZIALNOŚCI:

Aplikacja oraz dokumentacja są udostępniane "TAK JAK JEST" (AS IS),
bez jakichkolwiek gwarancji, wyraźnych lub domniemanych, w tym między
innymi gwarancji przydatności handlowej, przydatności do określonego
celu oraz nienaruszania praw osób trzecich.

Autorzy, kontrybutorzy oraz właściciele (Młody Kraków / Urząd Miasta
Krakowa) nie ponoszą odpowiedzialności za:
- Jakiekolwiek szkody bezpośrednie, pośrednie, przypadkowe, specjalne,
  exemplary lub wynikowe (w tym między innymi utratę danych, przerwę
  w działalności, utratę zysków) wynikające z użytkowania lub
  niemożności użytkowania aplikacji
- Błędy, pomyłki lub niedokładności w treści aplikacji lub dokumentacji
- Szkody wynikające z nieautoryzowanego dostępu do danych użytkowników
- Wirusy lub inne szkodliwe komponenty
- Problemy techniczne, awarie systemu lub utratę danych
- Naruszenie przepisów prawnych wynikające z użytkowania aplikacji

Użytkownik przyjmuje na siebie całkowite ryzyko związane z
użytkowaniem aplikacji i jej dokumentacji.

W maksymalnym zakresie dozwolonym przez prawo, całkowita
odpowiedzialność autorów i właścicieli ograniczona jest do kwoty 0 PLN.
```

### 19.2.3. Pozwolenia

Użytkownicy końcowi mogą:
- ✅ Instalować aplikację na swoich urządzeniach Android
- ✅ Używać aplikacji do celów wolontariackich
- ✅ Udostępniać link do aplikacji w Google Play
- ❌ Dekompilować lub reverse-engineerować aplikację
- ❌ Używać do celów komercyjnych

---

## 19.3. Licencje bibliotek zewnętrznych

### 19.3.1. Flutter Framework

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Flutter |
| **Wersja** | 3.9.0 |
| **Licencja** | BSD 3-Clause License |
| **URL** | https://flutter.dev |
| **Copyright** | Copyright 2014 The Flutter Authors |

**Treść BSD 3-Clause:**
```
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES ARE DISCLAIMED.
```

**✅ Kompatybilność:** Dozwolone użycie komercyjne i non-commercial.

---

### 19.3.2. Dart SDK

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Dart SDK |
| **Wersja** | 3.0.0+ |
| **Licencja** | BSD 3-Clause License |
| **Copyright** | Copyright 2012, the Dart project authors |

**✅ Kompatybilność:** Identyczna jak Flutter (BSD 3-Clause).

---

### 19.3.3. Isar Database

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Isar Database |
| **Wersja** | 3.1.0+1 |
| **Licencja** | Apache License 2.0 |
| **URL** | https://isar.dev |
| **Copyright** | Copyright 2022 Simon Leier |

**Treść Apache 2.0 (skrócona):**
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
```

**✅ Kompatybilność:** Dozwolone użycie komercyjne, modyfikacje, dystrybucja.

**📋 Wymagania:**
- Zachowanie informacji o licencji w pliku NOTICE
- Informacja o modyfikacjach (jeśli były)

---

### 19.3.4. flutter_bloc

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | flutter_bloc |
| **Wersja** | 8.1.6 |
| **Licencja** | MIT License |
| **URL** | https://bloclibrary.dev |
| **Copyright** | Copyright (c) 2018 Felix Angelov |

**Treść MIT:**
```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.
```

**✅ Kompatybilność:** Bardzo permisywna, dozwolone prawie wszystko.

---

### 19.3.5. go_router

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | go_router |
| **Wersja** | 14.8.1 |
| **Licencja** | BSD 3-Clause License |
| **Copyright** | Copyright 2021 The Flutter Authors |

**✅ Kompatybilność:** BSD 3-Clause (jak Flutter).

---

### 19.3.6. get_it

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | get_it |
| **Wersja** | 7.7.0 |
| **Licencja** | MIT License |
| **Copyright** | Copyright (c) 2018 Thomas Burkharts |

**✅ Kompatybilność:** MIT (bardzo permisywna).

---

### 19.3.7. flutter_map

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | flutter_map |
| **Wersja** | 7.0.2 |
| **Licencja** | BSD 3-Clause License |
| **URL** | https://pub.dev/packages/flutter_map |
| **Copyright** | Copyright (c) 2015-2023 flutter_map Authors |

**✅ Kompatybilność:** BSD 3-Clause.

---

### 19.3.8. dartz

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | dartz |
| **Wersja** | 0.10.1 |
| **Licencja** | MIT License |
| **Copyright** | Copyright (c) 2016 Björn Sperber |

**✅ Kompatybilność:** MIT.

---

### 19.3.9. equatable

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | equatable |
| **Wersja** | 2.0.8 |
| **Licencja** | MIT License |
| **Copyright** | Copyright (c) 2018 Felix Angelov |

**✅ Kompatybilność:** MIT.

---

### 19.3.10. image_picker

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | image_picker |
| **Wersja** | 1.1.2 |
| **Licencja** | Apache License 2.0 |
| **Copyright** | Copyright 2013 The Flutter Authors |

**✅ Kompatybilność:** Apache 2.0.

---

### 19.3.11. path_provider

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | path_provider |
| **Wersja** | 2.1.5 |
| **Licencja** | BSD 3-Clause License |
| **Copyright** | Copyright 2017 The Flutter Authors |

**✅ Kompatybilność:** BSD 3-Clause.

---

### 19.3.12. shared_preferences

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | shared_preferences |
| **Wersja** | 2.3.3 |
| **Licencja** | BSD 3-Clause License |
| **Copyright** | Copyright 2017 The Flutter Authors |

**✅ Kompatybilność:** BSD 3-Clause.

---

### 19.3.13. intl

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | intl |
| **Wersja** | 0.19.0 |
| **Licencja** | BSD 3-Clause License |
| **Copyright** | Copyright 2013, the Dart project authors |

**✅ Kompatybilność:** BSD 3-Clause.

---

### 19.3.14. latlong2

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | latlong2 |
| **Wersja** | 0.9.1 |
| **Licencja** | Apache License 2.0 |
| **Copyright** | Copyright (c) 2015 Michael Mitterer |

**✅ Kompatybilność:** Apache 2.0.

---

## 19.4. Biblioteki deweloperskie (devDependencies)

### 19.4.1. flutter_test

| Parametr | Wartość |
|----------|---------|
| **Licencja** | BSD 3-Clause License (część Flutter SDK) |

### 19.4.2. flutter_lints

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 5.0.0 |
| **Licencja** | BSD 3-Clause License |

### 19.4.3. mocktail

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 1.0.4 |
| **Licencja** | MIT License |

### 19.4.4. bloc_test

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 9.1.7 |
| **Licencja** | MIT License |

### 19.4.5. build_runner

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 2.4.13 |
| **Licencja** | BSD 3-Clause License |

### 19.4.6. isar_generator

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 3.1.0+1 |
| **Licencja** | Apache License 2.0 |

---

## 19.5. Zasoby zewnętrzne

### 19.5.1. OpenStreetMap

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | OpenStreetMap |
| **Licencja** | Open Database License (ODbL) |
| **URL** | https://www.openstreetmap.org/copyright |
| **Wymagana atrybucja** | "© OpenStreetMap contributors" |

**Treść ODbL (skrócona):**
```
You are free to:
- Share: copy and redistribute the data
- Adapt: produce works from the database
- Use the data for any purpose

Under the following conditions:
- Attribution: You must attribute OpenStreetMap and its contributors
- Share-Alike: If you alter or build upon the data, you must distribute
  under the same license
```

**📋 Wymagania:**
- Widoczna atrybucja w aplikacji: "© OpenStreetMap contributors"
- Link do https://www.openstreetmap.org/copyright

**✅ Implementacja w aplikacji:**
```dart
// W flutter_map tile layer
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: const ['a', 'b', 'c'],
  userAgentPackageName: 'com.mlodykrakow.hack_volunteers',
  // Atrybucja wyświetlana na mapie
)
```

---

### 19.5.2. Obrazy i ikony

#### Material Design Icons

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Material Design Icons |
| **Licencja** | Apache License 2.0 |
| **Copyright** | Copyright Google Inc. |

**✅ Kompatybilność:** Apache 2.0 (dozwolone użycie).

#### Młody Kraków Logo

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Logo Młody Kraków |
| **Właściciel** | Urząd Miasta Krakowa |
| **Licencja** | Proprietary (zgoda na użycie w projekcie) |
| **Pliki** | `assets/images/mlody_krakow_horizontal.png`, `mlody_krakow_vertical.png` |

**⚠️ Ograniczenia:**
- Tylko do użytku w aplikacji SmokPomaga
- Zakaz modyfikacji logo
- Zakaz użycia w innych projektach bez zgody

---

## 19.6. Fonty

### 19.6.1. Roboto Font

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Roboto |
| **Licencja** | Apache License 2.0 |
| **Copyright** | Copyright Christian Robertson |

**✅ Kompatybilność:** Apache 2.0 (domyślny font w Material Design).

---

## 19.7. Narzędzia budowania

### 19.7.1. Gradle

| Parametr | Wartość |
|----------|---------|
| **Nazwa** | Gradle Build Tool |
| **Wersja** | 8.12 |
| **Licencja** | Apache License 2.0 |

### 19.7.2. Android Gradle Plugin

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 8.9.1 |
| **Licencja** | Apache License 2.0 |

### 19.7.3. Kotlin

| Parametr | Wartość |
|----------|---------|
| **Wersja** | 2.1.0 |
| **Licencja** | Apache License 2.0 |

---

## 19.8. Podsumowanie licencji

### 19.8.1. Typy licencji w projekcie

| Typ licencji | Liczba bibliotek | Kompatybilność | Wymagania |
|--------------|------------------|----------------|-----------|
| **MIT** | 5 | ✅ Bardzo permisywna | Zachowanie copyright notice |
| **BSD 3-Clause** | 10 | ✅ Permisywna | Zachowanie copyright notice |
| **Apache 2.0** | 8 | ✅ Permisywna | Zachowanie NOTICE, informacja o zmianach |
| **ODbL** | 1 (OSM) | ✅ Share-alike | Atrybucja, share-alike dla danych |
| **Proprietary** | 2 (app, logo) | ⚠️ Ograniczona | Brak redystrybucji |

### 19.8.2. Zgodność licencji

Wszystkie licencje open-source używane w projekcie są **kompatybilne** ze sobą i pozwalają na:
- ✅ Użycie komercyjne (gdyby aplikacja była komercyjna)
- ✅ Modyfikacje
- ✅ Dystrybucję
- ✅ Sublicencjonowanie (w ramach zgodności z licencjami)

**⚠️ Jedyne ograniczenia:**
- Logo Młody Kraków - proprietary (zgoda na użycie tylko w tym projekcie)
- Kod aplikacji SmokPomaga - proprietary (właściciel: Młody Kraków/UMK)

---

## 19.9. Atrybucje w aplikacji

### 19.9.1. Ekran "O aplikacji"

W aplikacji znajduje się ekran z pełnymi atrybucjami dostępny w:

**Menu → Ustawienia → O aplikacji → Licencje**

Wyświetla:
```
SmokPomaga v1.0.0
Copyright © 2025 Młody Kraków

Built with:
- Flutter 3.9.0 (BSD 3-Clause)
- Isar Database 3.1.0 (Apache 2.0)
- flutter_bloc 8.1.6 (MIT)
[... więcej bibliotek ...]

Map data:
© OpenStreetMap contributors
Licensed under ODbL

Logo:
Młody Kraków - Urząd Miasta Krakowa

[Przycisk: "Pokaż pełne licencje"]
```

### 19.9.2. Atrybucja na mapie

Na dole mapy widoczny jest tekst:
```
© OpenStreetMap contributors
```

Z linkiem do: https://www.openstreetmap.org/copyright

---

## 19.10. Generowanie listy licencji

### 19.10.1. Automatyczne generowanie

Flutter zawiera wbudowaną funkcję wyświetlania licencji:

```dart
// W aplikacji
showLicensePage(
  context: context,
  applicationName: 'SmokPomaga',
  applicationVersion: '1.0.0',
  applicationLegalese: '© 2025 Młody Kraków',
);
```

### 19.10.2. Export do pliku

```bash
# Generuj licenses.json
flutter pub deps --json > licenses.json

# Lub użyj flutter_oss_licenses
flutter pub global activate flutter_oss_licenses
flutter pub global run flutter_oss_licenses:generate.dart
```

---

## 19.11. Compliance checklist

### 19.11.1. Przed wydaniem aplikacji

- [x] Dodany ekran "O aplikacji" z licencjami
- [x] Atrybucja OpenStreetMap na mapie
- [x] Copyright notice w kodzie źródłowym
- [x] Plik LICENSE w repozytorium
- [x] Plik NOTICE z listą bibliotek
- [x] Logo Młody Kraków z zgodą właściciela
- [x] Wszystkie licencje sprawdzone pod kątem kompatybilności

### 19.11.2. Dokumentacja

- [x] Dokument 19_Licencje.md (ten plik)
- [x] README.md z informacją o licencji
- [x] NOTICE file z atrybucjami
- [x] Licencje w komentarzach kodu (tam gdzie wymagane)

---

## 19.12. Kontakt w sprawie licencji

Jeśli masz pytania dotyczące licencji lub chcesz uzyskać pozwolenie na użycie kodu aplikacji SmokPomaga, skontaktuj się:

**Email:** legal@mlodykrakow.pl  
**Adres:** Urząd Miasta Krakowa, Plac Wszystkich Świętych 3-4, 31-004 Kraków

---

## 19.13. Pełne teksty licencji

### 19.13.1. MIT License (pełny tekst)

```
MIT License

Copyright (c) [year] [copyright holders]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 19.13.2. BSD 3-Clause License (pełny tekst)

```
BSD 3-Clause License

Copyright (c) [year], [copyright holder]

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

### 19.13.3. Apache License 2.0 (URL)

Pełny tekst dostępny pod adresem:  
https://www.apache.org/licenses/LICENSE-2.0.txt

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół prawny / deweloperski SmokPomaga  
**Wersja dokumentu:** 1.0.0

**⚠️ WAŻNE:** Niniejszy dokument służy celom informacyjnym. W przypadku wątpliwości prawnych skonsultuj się z prawnikiem.
