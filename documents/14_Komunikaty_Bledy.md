# 14. Komunikaty i Błędy

**Dokument:** 14_Komunikaty_Bledy.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 14.1. Przegląd

Niniejszy dokument zawiera kompletny katalog wszystkich komunikatów systemowych, błędów oraz instrukcji ich obsługi w aplikacji SmokPomaga.

---

## 14.2. Poziomy komunikatów

| Poziom | Kolor | Ikona | Cel |
|--------|-------|-------|-----|
| **SUCCESS** | Zielony | ✓ | Potwierdzenie pomyślnej operacji |
| **INFO** | Niebieski | ℹ | Informacja neutralna |
| **WARNING** | Pomarańczowy | ⚠ | Ostrzeżenie, wymaga uwagi |
| **ERROR** | Czerwony | ✗ | Błąd, operacja nie powiodła się |

---

## 14.3. Komunikaty sukcesu (SUCCESS)

### 14.3.1. Autoryzacja

| ID | Akcja | Komunikat | Czas wyświetlania |
|----|-------|-----------|-------------------|
| SUC-001 | Rejestracja | "Konto utworzone pomyślnie! Witaj w SmokPomaga! 🎉" | 3s |
| SUC-002 | Logowanie | "Witaj z powrotem, [Imię]!" | 2s |
| SUC-003 | Wylogowanie | "Wylogowano pomyślnie. Do zobaczenia!" | 2s |
| SUC-004 | Zmiana hasła | "Hasło zostało zmienione." | 3s |
| SUC-005 | Aktualizacja profilu | "Profil zaktualizowany pomyślnie!" | 3s |

### 14.3.2. Wydarzenia

| ID | Akcja | Komunikat | Czas wyświetlania |
|----|-------|-----------|-------------------|
| SUC-010 | Utworzenie wydarzenia | "Wydarzenie '[Tytuł]' zostało utworzone!" | 3s |
| SUC-011 | Edycja wydarzenia | "Wydarzenie zaktualizowane pomyślnie!" | 3s |
| SUC-012 | Usunięcie wydarzenia | "Wydarzenie zostało usunięte." | 3s |
| SUC-013 | Anulowanie wydarzenia | "Wydarzenie zostało anulowane. Uczestnicy zostaną powiadomieni." | 4s |
| SUC-014 | Zakończenie wydarzenia | "Wydarzenie oznaczone jako zakończone!" | 3s |

### 14.3.3. Aplikacje

| ID | Akcja | Komunikat | Czas wyświetlania |
|----|-------|-----------|-------------------|
| SUC-020 | Złożenie aplikacji | "Aplikacja wysłana pomyślnie! Otrzymasz powiadomienie o decyzji organizacji." | 4s |
| SUC-021 | Akceptacja aplikacji | "Aplikacja zaakceptowana! Wolontariusz otrzymał powiadomienie." | 3s |
| SUC-022 | Odrzucenie aplikacji | "Aplikacja odrzucona. Wolontariusz otrzymał powiadomienie." | 3s |
| SUC-023 | Wycofanie aplikacji | "Aplikacja wycofana." | 2s |

### 14.3.4. Certyfikaty

| ID | Akcja | Komunikat | Czas wyświetlania |
|----|-------|-----------|-------------------|
| SUC-030 | Wygenerowanie certyfikatu | "Certyfikat wygenerowany i dodany do Twojego profilu!" | 3s |
| SUC-031 | Eksport certyfikatu | "Certyfikat wyeksportowany do PDF!" | 3s |
| SUC-032 | Weryfikacja certyfikatu | "Certyfikat zweryfikowany pomyślnie!" | 3s |

---

## 14.4. Komunikaty informacyjne (INFO)

### 14.4.1. Stan systemu

| ID | Sytuacja | Komunikat | Akcja |
|----|----------|-----------|-------|
| INF-001 | Tryb offline | "Brak połączenia z internetem. Dane mogą być nieaktualne." | Automatyczne odświeżenie po przywróceniu sieci |
| INF-002 | Synchronizacja | "Synchronizacja danych..." | Automatyczne zamknięcie po zakończeniu |
| INF-003 | Ładowanie danych | "Ładowanie wydarzeń..." | Automatyczne zamknięcie po załadowaniu |
| INF-004 | Pusty wynik | "Nie znaleziono wydarzeń. Spróbuj zmienić filtry." | Sugestia zmiany filtrów |

### 14.4.2. Limity i ograniczenia

| ID | Sytuacja | Komunikat | Akcja |
|----|----------|-----------|-------|
| INF-010 | Brak wolnych miejsc | "Brak wolnych miejsc na to wydarzenie." | Pokaż pełne wydarzenie jako disabled |
| INF-011 | Wydarzenie zakończone | "To wydarzenie już się zakończyło." | Disable przycisk "Aplikuj" |
| INF-012 | Już zaaplikowano | "Aplikowałeś już na to wydarzenie." | Pokaż status aplikacji |
| INF-013 | Termin minął | "Termin zapisów minął." | Disable przycisk "Aplikuj" |

### 14.4.3. Puste stany

| ID | Sytuacja | Komunikat | Sugestia akcji |
|----|----------|-----------|----------------|
| INF-020 | Brak wydarzeń | "Nie znaleziono wydarzeń w Twojej okolicy." | "Przeglądaj wszystkie wydarzenia" (button) |
| INF-021 | Brak certyfikatów | "Nie masz jeszcze żadnych certyfikatów." | "Przeglądaj wydarzenia" (button) |
| INF-022 | Brak aplikacji | "Nie masz jeszcze żadnych aplikacji." | "Znajdź wydarzenie" (button) |
| INF-023 | Brak wyników wyszukiwania | "Brak wyników dla '[query]'." | "Wyczyść filtry" (button) |

---

## 14.5. Ostrzeżenia (WARNING)

### 14.5.1. Potwierdzenia akcji

| ID | Akcja | Komunikat | Przyciski |
|----|-------|-----------|-----------|
| WAR-001 | Usunięcie wydarzenia | "Czy na pewno chcesz usunąć to wydarzenie? Tej operacji nie można cofnąć." | Anuluj / Usuń |
| WAR-002 | Anulowanie wydarzenia | "Czy na pewno chcesz anulować to wydarzenie? Wszyscy uczestnicy zostaną powiadomieni." | Anuluj / Potwierdź |
| WAR-003 | Odrzucenie aplikacji | "Czy na pewno chcesz odrzucić aplikację [Imię]?" | Anuluj / Odrzuć |
| WAR-004 | Wylogowanie | "Czy na pewno chcesz się wylogować?" | Anuluj / Wyloguj |
| WAR-005 | Wycofanie aplikacji | "Czy na pewno chcesz wycofać swoją aplikację?" | Anuluj / Wycofaj |

### 14.5.2. Walidacja danych

| ID | Problem | Komunikat | Jak naprawić |
|----|---------|-----------|--------------|
| WAR-010 | Słabe hasło | "Hasło jest słabe. Zalecamy użycie liter, cyfr i znaków specjalnych." | Sugestia silniejszego hasła |
| WAR-011 | Brak numeru telefonu | "Nie podałeś numeru telefonu. Organizacje mogą mieć problem ze skontaktowaniem się z Tobą." | Opcja dodania w ustawieniach |
| WAR-012 | Brak zdjęcia profilowego | "Dodaj zdjęcie profilowe, aby Twój profil wyglądał bardziej profesjonalnie." | Link do ustawień |
| WAR-013 | Niekompletny profil | "Twój profil jest niekompletny (60%). Uzupełnij go, aby zwiększyć szanse na akceptację." | Link do edycji profilu |

### 14.5.3. Limity

| ID | Problem | Komunikat | Akcja |
|----|---------|-----------|-------|
| WAR-020 | Przekroczenie limitu znaków | "Opis jest zbyt długi. Pozostało [X] znaków." | Automatyczny licznik |
| WAR-021 | Za mało wolontariuszy | "Liczba wolontariuszy jest bardzo niska (< 5). Rozważ zwiększenie limitu." | Sugestia |
| WAR-022 | Zbyt dużo wolontariuszy | "Liczba wolontariuszy jest bardzo wysoka (> 100). Czy na pewno?" | Potwierdzenie |

---

## 14.6. Błędy (ERROR)

### 14.6.1. Błędy autoryzacji (AUTH)

| Kod | Nazwa | Komunikat | Rozwiązanie użytkownika | Rozwiązanie techniczne |
|-----|-------|-----------|------------------------|------------------------|
| AUTH-001 | InvalidCredentials | "Nieprawidłowy email lub hasło. Spróbuj ponownie." | Sprawdź dane logowania | Weryfikacja w bazie danych |
| AUTH-002 | UserNotFound | "Użytkownik z tym adresem email nie istnieje." | Zarejestruj nowe konto | Query do userModels |
| AUTH-003 | EmailAlreadyExists | "Ten adres email jest już zajęty. Użyj innego." | Użyj innego emaila lub zaloguj się | Sprawdzenie unikalności emaila |
| AUTH-004 | SessionExpired | "Twoja sesja wygasła. Zaloguj się ponownie." | Zaloguj się | Odśwież token sesji |
| AUTH-005 | InsufficientPermissions | "Nie masz uprawnień do wykonania tej operacji." | Skontaktuj się z administratorem | Sprawdzenie roli użytkownika |

### 14.6.2. Błędy walidacji (VAL)

| Kod | Nazwa | Komunikat | Pole | Rozwiązanie |
|-----|-------|-----------|------|-------------|
| VAL-001 | InvalidEmail | "Nieprawidłowy format adresu email." | email | Wpisz poprawny email (user@domain.com) |
| VAL-002 | PasswordTooShort | "Hasło musi mieć minimum 8 znaków." | password | Użyj dłuższego hasła |
| VAL-003 | RequiredFieldEmpty | "To pole jest wymagane." | * | Wypełnij pole |
| VAL-004 | InvalidDate | "Data musi być w przyszłości." | date | Wybierz przyszłą datę |
| VAL-005 | InvalidNumber | "Wpisz poprawną liczbę (większą od 0)." | volunteersNeeded | Wpisz liczbę > 0 |
| VAL-006 | InvalidPhoneNumber | "Nieprawidłowy numer telefonu. Format: +48 123 456 789" | phoneNumber | Użyj formatu +48XXXXXXXXX |
| VAL-007 | TextTooLong | "Tekst zbyt długi (max [X] znaków)." | description | Skróć tekst |
| VAL-008 | TextTooShort | "Tekst zbyt krótki (min [X] znaków)." | description | Wydłuż tekst |
| VAL-009 | InvalidCoordinates | "Nieprawidłowe koordynaty GPS." | lat/lng | Wybierz lokalizację na mapie |

### 14.6.3. Błędy bazy danych (DB)

| Kod | Nazwa | Komunikat | Przyczyna | Rozwiązanie |
|-----|-------|-----------|-----------|-------------|
| DB-001 | DatabaseNotInitialized | "Błąd inicjalizacji bazy danych. Uruchom aplikację ponownie." | Isar nie został otwarty | Restart aplikacji |
| DB-002 | RecordNotFound | "Nie znaleziono rekordu. Może został usunięty." | Brak rekordu w bazie | Odśwież listę |
| DB-003 | DuplicateKey | "Rekord z tym identyfikatorem już istnieje." | Duplikat UUID | Regeneruj UUID |
| DB-004 | TransactionFailed | "Operacja nie powiodła się. Spróbuj ponownie." | Błąd transakcji Isar | Retry transakcji |
| DB-005 | DatabaseCorrupted | "Baza danych jest uszkodzona. Skontaktuj się z supportem." | Plik .isar uszkodzony | Przywróć backup lub reinstalacja |
| DB-006 | StorageFull | "Brak miejsca na urządzeniu. Zwolnij miejsce i spróbuj ponownie." | Pełny dysk | Usuń pliki z urządzenia |

### 14.6.4. Błędy sieciowe (NET)

| Kod | Nazwa | Komunikat | Przyczyna | Rozwiązanie |
|-----|-------|-----------|-----------|-------------|
| NET-001 | NoInternetConnection | "Brak połączenia z internetem. Sprawdź swoje połączenie." | Brak Wi-Fi/dane mobilne | Włącz Wi-Fi lub dane |
| NET-002 | RequestTimeout | "Przekroczono limit czasu żądania. Spróbuj ponownie." | Wolne połączenie | Retry z timeout |
| NET-003 | ServerError | "Błąd serwera (500). Spróbuj ponownie później." | Błąd backend API | Skontaktuj się z supportem |
| NET-004 | ClientError | "Nieprawidłowe żądanie (400). Sprawdź poprawność danych." | Błąd w request | Walidacja przed wysłaniem |
| NET-005 | MapTilesNotLoaded | "Nie można załadować mapy. Sprawdź połączenie z internetem." | Brak dostępu do tile.openstreetmap.org | Sprawdź internet, spróbuj ponownie |
| NET-006 | ResourceNotFound | "Zasób nie został znaleziony (404)." | URL nie istnieje | Sprawdź URL |

### 14.6.5. Błędy systemowe (SYS)

| Kod | Nazwa | Komunikat | Przyczyna | Rozwiązanie |
|-----|-------|-----------|-----------|-------------|
| SYS-001 | UnknownError | "Wystąpił nieoczekiwany błąd. Skontaktuj się z supportem." | Niezłapany wyjątek | Wyślij logi do supportu |
| SYS-002 | PermissionDenied | "Brak uprawnień. Nadaj uprawnienia w ustawieniach urządzenia." | Brak INTERNET permission | Ustawienia → Uprawnienia |
| SYS-003 | StorageFull | "Brak miejsca na dysku. Zwolnij minimum 100 MB." | Pełna pamięć | Usuń pliki/aplikacje |
| SYS-004 | OutOfMemory | "Brak pamięci RAM. Zamknij inne aplikacje." | Za dużo otwartych apps | Zamknij aplikacje |
| SYS-005 | UnsupportedVersion | "Ta wersja Android nie jest wspierana (min. Android 5.0)." | Android < 5.0 | Zaktualizuj system |

### 14.6.6. Błędy biznesowe (BIZ)

| Kod | Nazwa | Komunikat | Przyczyna | Rozwiązanie |
|-----|-------|-----------|-----------|-------------|
| BIZ-001 | EventFull | "To wydarzenie jest pełne. Nie można już aplikować." | volunteersApplied >= volunteersNeeded | Wybierz inne wydarzenie |
| BIZ-002 | AlreadyApplied | "Już aplikowałeś na to wydarzenie." | Duplikat aplikacji | Poczekaj na decyzję |
| BIZ-003 | EventCancelled | "To wydarzenie zostało anulowane." | status = cancelled | - |
| BIZ-004 | EventPassed | "To wydarzenie już się odbyło." | date < now | Przeglądaj aktualne wydarzenia |
| BIZ-005 | InvalidRole | "Twoja rola użytkownika nie pozwala na tę operację." | Niewłaściwa rola | Zaloguj się na właściwe konto |
| BIZ-006 | CertificateAlreadyExists | "Certyfikat dla tego wydarzenia już istnieje." | Duplikat certyfikatu | - |

---

## 14.7. Obsługa błędów w kodzie

### 14.7.1. Struktura błędów

```dart
class AppException implements Exception {
  final String code;
  final String message;
  final String? technicalDetails;
  
  AppException(this.code, this.message, [this.technicalDetails]);
  
  @override
  String toString() => 'AppException($code): $message';
}
```

### 14.7.2. Typy wyjątków

```dart
// Błędy autoryzacji
class AuthException extends AppException {
  AuthException(String code, String message) 
      : super(code, message);
}

// Błędy walidacji
class ValidationException extends AppException {
  final String fieldName;
  ValidationException(String code, String message, this.fieldName) 
      : super(code, message);
}

// Błędy bazy danych
class DatabaseException extends AppException {
  DatabaseException(String code, String message) 
      : super(code, message);
}

// Błędy sieciowe
class NetworkException extends AppException {
  NetworkException(String code, String message) 
      : super(code, message);
}
```

### 14.7.3. Przykład użycia

```dart
// Rzucanie wyjątku
if (user == null) {
  throw AuthException('AUTH-002', 'Użytkownik nie został znaleziony');
}

// Łapanie wyjątku
try {
  await loginUseCase(email, password);
} on AuthException catch (e) {
  // Pokaż komunikat użytkownikowi
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.message),
      backgroundColor: Colors.red,
    ),
  );
} on NetworkException catch (e) {
  // Pokaż komunikat o błędzie sieci
  showErrorDialog(context, e.message);
} catch (e) {
  // Nieoczekiwany błąd
  showErrorDialog(context, 'Wystąpił nieoczekiwany błąd: ${e.toString()}');
}
```

### 14.7.4. Mapowanie Failure na Exception

```dart
String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return 'NET-003: Błąd serwera. Spróbuj ponownie później.';
    case CacheFailure:
      return 'DB-002: Nie znaleziono danych lokalnych.';
    case NetworkFailure:
      return 'NET-001: Brak połączenia z internetem.';
    case ValidationFailure:
      return 'VAL-003: ${(failure as ValidationFailure).message}';
    default:
      return 'SYS-001: Nieoczekiwany błąd.';
  }
}
```

---

## 14.8. UI dla błędów

### 14.8.1. SnackBar (krótkie komunikaty)

```dart
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}
```

### 14.8.2. Dialog (szczegółowe błędy)

```dart
void showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
```

### 14.8.3. Inline error (formularze)

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    errorText: emailError, // "VAL-001: Nieprawidłowy format email"
    errorStyle: TextStyle(color: Colors.red),
  ),
)
```

---

## 14.9. Logowanie błędów

### 14.9.1. Debug logging

```dart
void logError(String code, String message, [dynamic error, StackTrace? stackTrace]) {
  if (kDebugMode) {
    print('ERROR [$code]: $message');
    if (error != null) print('Details: $error');
    if (stackTrace != null) print('StackTrace: $stackTrace');
  }
}

// Użycie
try {
  await riskyOperation();
} catch (e, stackTrace) {
  logError('DB-004', 'Transaction failed', e, stackTrace);
  rethrow;
}
```

### 14.9.2. Production logging (future)

```dart
// Integracja z Firebase Crashlytics
void reportError(String code, String message, dynamic error, StackTrace stackTrace) {
  FirebaseCrashlytics.instance.recordError(
    error,
    stackTrace,
    reason: '[$code] $message',
  );
}
```

---

## 14.10. Testy obsługi błędów

### 14.10.1. Unit test

```dart
test('should throw AuthException when credentials are invalid', () async {
  // arrange
  when(() => mockAuthRepository.login(any(), any()))
      .thenThrow(AuthException('AUTH-001', 'Invalid credentials'));
  
  // act & assert
  expect(
    () => loginUseCase('wrong@email.com', 'wrongpass'),
    throwsA(isA<AuthException>()),
  );
});
```

### 14.10.2. Widget test

```dart
testWidgets('should show error SnackBar when login fails', (tester) async {
  // arrange
  when(() => mockAuthBloc.state).thenReturn(AuthError('AUTH-001'));
  
  // act
  await tester.pumpWidget(MyApp());
  await tester.pump();
  
  // assert
  expect(find.text('AUTH-001: Nieprawidłowy email lub hasło'), findsOneWidget);
  expect(find.byType(SnackBar), findsOneWidget);
});
```

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
