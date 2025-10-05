# Dokumentacja Aplikacji SmokPomaga

**Wersja:** 1.0.0  
**Data:** 5 października 2025  
**Status:** Wersja produkcyjna

## Spis treści dokumentacji

### 1. Dokumentacja Zarządzania Platformą
- [Opis Konfiguracji Systemu](./01_Konfiguracja_Systemu.md)
- [Instrukcje Start/Stop](./02_Instrukcje_StartStop.md)
- [Instrukcje Eksploatacyjne dla Administratorów](./03_Instrukcje_Administracyjne.md)
- [Instrukcje Kopii Zapasowych](./04_Kopie_Zapasowe.md)
- [Instrukcje Instalacji i Konfiguracji](./05_Instalacja_Konfiguracja.md)

### 2. Dokumentacja Użytkowania
- [Instrukcja Użytkownika - Wolontariusz](./06_Instrukcja_Uzytkownika_Wolontariusz.md)
- [Instrukcja Użytkownika - Organizacja](./07_Instrukcja_Uzytkownika_Organizacja.md)
- [Instrukcja Użytkownika - Koordynator](./08_Instrukcja_Uzytkownika_Koordynator.md)

### 3. Dokumentacja Techniczna
- [Wymagania Techniczne](./09_Wymagania_Techniczne.md)
- [Architektura Aplikacji](./10_Architektura_Aplikacji.md)
- [Diagramy](./11_Diagramy.md)
- [Struktura Bazy Danych](./12_Baza_Danych.md)
- [Słowniki Danych](./13_Slowniki_Danych.md)
- [Komunikaty i Błędy](./14_Komunikaty_Bledy.md)
- [Kody Źródłowe](./15_Kody_Zrodlowe.md)

### 4. Dokumentacja Integracji
- [API i Integracje](./16_API_Integracje.md)

### 5. Załączniki
- [Lista Kont Technicznych](./17_Konta_Techniczne.md)
- [Changelog](./18_Changelog.md)
- [Licencje](./19_Licencje.md)

## O aplikacji

**SmokPomaga** to aplikacja mobilna wspierająca działania wolontariackie w Krakowie, stworzona w ramach programu "Młody Kraków". Aplikacja łączy wolontariuszy z organizacjami pozarządowymi oraz szkołami w procesie zarządzania akcjami wolontariackimi i wydawania certyfikatów potwierdzających zaangażowanie.

## Charakterystyka

- **Platforma:** Android (minimum SDK 21, target SDK 36)
- **Technologia:** Flutter 3.9.0+, Dart 3.0+
- **Baza danych:** Isar 3.1.0+1 (lokalna baza NoSQL)
- **Architektura:** Clean Architecture z BLoC pattern
- **Typ wdrożenia:** Aplikacja mobilna standalone

## Wsparcie

Aplikacja jest wspierana przez program **Młody Kraków**.

## Status dokumentacji

| Dokument | Status | Data aktualizacji |
|----------|--------|-------------------|
| Wszystkie dokumenty | ✅ Kompletna | 5.10.2025 |

## Zarządzający dokumentacją

**Referat ds. Zarządzania Infrastrukturą Teleinformatyczną**  
Urząd Miasta Krakowa

---

## ⚠️ WYŁĄCZENIE ODPOWIEDZIALNOŚCI

**WAŻNE INFORMACJE PRAWNE:**

Niniejsza aplikacja oraz dokumentacja są udostępniane **"TAK JAK JEST" (AS IS)** bez jakichkolwiek gwarancji.

### Wyłączenie gwarancji

Autorzy, programiści, kontrybutorzy oraz właściciele (program Młody Kraków, Urząd Miasta Krakowa) **NIE UDZIELAJĄ ŻADNYCH GWARANCJI**, wyraźnych ani domniemanych, w tym między innymi:
- Gwarancji przydatności handlowej
- Gwarancji przydatności do określonego celu
- Gwarancji nienaruszania praw osób trzecich
- Gwarancji poprawności, dokładności lub kompletności
- Gwarancji bezpieczeństwa lub braku błędów

### Ograniczenie odpowiedzialności

W **MAKSYMALNYM ZAKRESIE DOZWOLONYM PRZEZ PRAWO**, autorzy i właściciele **NIE PONOSZĄ ODPOWIEDZIALNOŚCI** za:

**Szkody materialne:**
- Utratę danych osobowych lub służbowych
- Przerwę w działalności gospodarczej
- Utratę zysków lub przychodów
- Koszty zastępczych produktów lub usług

**Szkody techniczne:**
- Błędy, awarie lub nieprawidłowe działanie aplikacji
- Problemy z kompatybilnością urządzeń
- Utratę połączenia internetowego lub problemy z mapą
- Wirusy, malware lub inne szkodliwe komponenty
- Uszkodzenie urządzenia użytkownika

**Szkody prawne:**
- Naruszenie przepisów RODO lub innych regulacji
- Problemy wynikające z nieautoryzowanego dostępu do danych
- Nieprawidłowe zarządzanie danymi wolontariuszy
- Błędy w certyfikatach lub dokumentach generowanych przez aplikację

**Szkody biznesowe:**
- Niepowodzenie akcji wolontariackiej
- Konflikty między wolontariuszami a organizacjami
- Niedokładności w liczeniu godzin wolontariatu
- Problemy z weryfikacją certyfikatów

### Ryzyko użytkownika

**UŻYTKOWNIK PRZYJMUJE NA SIEBIE CAŁKOWITE RYZYKO** związane z:
- Instalacją i użytkowaniem aplikacji
- Jakością, wydajnością i dokładnością aplikacji
- Wykorzystaniem danych z aplikacji do celów formalnych
- Zgodnością z lokalnymi przepisami prawa

### Ograniczenie kwotowe

W maksymalnym zakresie dozwolonym przez prawo, **CAŁKOWITA ODPOWIEDZIALNOŚĆ** autorów, kontrybutorów i właścicieli jest **OGRANICZONA DO KWOTY 0 PLN** (zero złotych).

### Brak profesjonalnego wsparcia

Aplikacja i dokumentacja są dostarczane **BEZ ZOBOWIĄZANIA** do:
- Wsparcia technicznego
- Naprawy błędów
- Aktualizacji lub rozwoju
- Odpowiedzi na zapytania
- Szkoleń użytkowników

### Akceptacja warunków

**KORZYSTAJĄC Z APLIKACJI LUB DOKUMENTACJI, UŻYTKOWNIK POTWIERDZA**, że:
- Przeczytał i zrozumiał powyższe wyłączenia odpowiedzialności
- Akceptuje wszystkie ryzyka związane z użytkowaniem
- Zrzeka się prawa do roszczeń wobec autorów i właścicieli
- Będzie samodzielnie odpowiadał za zgodność z przepisami prawa

### Konsultacja prawna

**ZALECAMY SKONSULTOWANIE** wykorzystania aplikacji z:
- Prawnikiem specjalizującym się w IT/RODO
- Inspektorem ochrony danych (IOD)
- Audytorem bezpieczeństwa IT

---

*Dokumentacja jest aktualna na dzień: 5 października 2025*
