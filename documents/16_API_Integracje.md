# 16. API i Integracje

**Dokument:** 16_API_Integracje.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 16.1. Przegląd

Aplikacja SmokPomaga obecnie działa w trybie **offline-first** z mockowymi danymi i lokalną bazą danych Isar. Niniejszy dokument opisuje obecne integracje oraz planowane API dla przyszłej wersji z backendem.

---

## 16.2. Obecne integracje

### 16.2.1. OpenStreetMap (OSM)

**Opis:** Dostawca kafelków mapy dla flutter_map.

**Endpoint:**
```
https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

**Parametry:**
- `z` - poziom zoomu (3-18)
- `x` - współrzędna X kafelka
- `y` - współrzędna Y kafelka

**Konfiguracja:**

```dart
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.mlodykrakow.hack_volunteers',
  subdomains: const ['a', 'b', 'c'],
  tileProvider: NetworkTileProvider(),
)
```

**Headers:**
```http
User-Agent: SmokPomaga/1.0
```

**Rate Limiting:**
- Dozwolone użycie: Aplikacje non-commercial
- Limit: Brak oficjalnego, zalecane caching
- Dokumentacja: https://operations.osmfoundation.org/policies/tiles/

**Fallback:**
W przypadku problemów z OSM można użyć alternatywnych dostawców:
- MapTiler: `https://api.maptiler.com/maps/basic/{z}/{x}/{y}.png?key={API_KEY}`
- Mapbox: `https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={API_KEY}`

---

## 16.3. Obecna architektura danych (Mock)

### 16.3.1. Seed Data (lib/features/*/data/datasources/)

Dane inicjalizacyjne są hardcoded w klasach DataSource:

```dart
class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  @override
  Future<List<EventModel>> getEvents() async {
    // Symulacja opóźnienia sieciowego
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Zwróć mockowe dane
    return _mockEvents;
  }
  
  static final List<EventModel> _mockEvents = [
    EventModel(
      id: '1',
      title: 'Sprzątanie Parku Jordana',
      description: '...',
      date: DateTime(2025, 10, 15, 10, 0),
      // ... więcej pól
    ),
    // ... więcej wydarzeń (łącznie 17)
  ];
}
```

### 16.3.2. Przepływ danych

```
Mock DataSource → Repository → UseCase → BLoC → UI
```

Wszystkie dane są w pamięci RAM lub w lokalnej bazie Isar. Brak rzeczywistych zapytań HTTP.

---

## 16.4. Planowane API (Future)

### 16.4.1. Base URL

**Development:**
```
https://api-dev.smokpomaga.pl/v1
```

**Production:**
```
https://api.smokpomaga.pl/v1
```

### 16.4.2. Autoryzacja

**Token-based (JWT):**

```http
POST /auth/login
Content-Type: application/json

{
  "email": "jan@uek.krakow.pl",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "...",
    "expiresIn": 86400,
    "user": {
      "id": "user-123",
      "email": "jan@uek.krakow.pl",
      "name": "Jan Kowalski",
      "role": "volunteer"
    }
  }
}
```

**Użycie tokenu:**
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 16.5. Endpoints (Planowane)

### 16.5.1. Auth Endpoints

#### POST /auth/register

**Request:**
```json
{
  "email": "jan@uek.krakow.pl",
  "password": "securepassword",
  "name": "Jan Kowalski",
  "role": "volunteer",
  "phoneNumber": "+48123456789"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "user-123",
    "email": "jan@uek.krakow.pl",
    "name": "Jan Kowalski",
    "role": "volunteer",
    "createdAt": "2025-10-05T12:00:00Z"
  }
}
```

**Errors:**
- `400 Bad Request` - Walidacja nie powiodła się (VAL-001, VAL-002)
- `409 Conflict` - Email już istnieje (AUTH-003)

---

#### POST /auth/login

**Request:**
```json
{
  "email": "jan@uek.krakow.pl",
  "password": "securepassword"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "token": "jwt_token_here",
    "refreshToken": "refresh_token_here",
    "expiresIn": 86400,
    "user": { /* user object */ }
  }
}
```

**Errors:**
- `401 Unauthorized` - Nieprawidłowe credentials (AUTH-001)
- `404 Not Found` - Użytkownik nie istnieje (AUTH-002)

---

#### POST /auth/refresh

**Request:**
```json
{
  "refreshToken": "refresh_token_here"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "token": "new_jwt_token",
    "expiresIn": 86400
  }
}
```

---

#### POST /auth/logout

**Request:**
```http
Authorization: Bearer jwt_token_here
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

### 16.5.2. Events Endpoints

#### GET /events

**Query Parameters:**
- `category` (optional) - filtruj po kategorii (ekologia, edukacja, sport, kultura, pomoc_spoleczna, inne)
- `status` (optional) - filtruj po statusie (upcoming, ongoing, completed)
- `limit` (optional) - liczba wyników (default: 20, max: 100)
- `offset` (optional) - offset paginacji (default: 0)
- `sortBy` (optional) - sortowanie (date_asc, date_desc, popularity_desc)

**Request:**
```http
GET /events?category=ekologia&status=upcoming&limit=20&offset=0
Authorization: Bearer jwt_token_here
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "events": [
      {
        "id": "evt-001",
        "title": "Sprzątanie Parku Jordana",
        "description": "Pomóż nam przywrócić czystość...",
        "date": "2025-10-15T10:00:00Z",
        "location": "Park Jordana, Kraków",
        "latitude": 50.0647,
        "longitude": 19.9450,
        "volunteersNeeded": 20,
        "volunteersApplied": 12,
        "category": "ekologia",
        "imageUrl": "https://cdn.smokpomaga.pl/events/evt-001.jpg",
        "requirements": "Rękawice robocze",
        "status": "upcoming",
        "organizationId": "org-001",
        "createdAt": "2025-09-01T12:00:00Z"
      }
      // ... więcej wydarzeń
    ],
    "pagination": {
      "total": 45,
      "limit": 20,
      "offset": 0,
      "hasMore": true
    }
  }
}
```

---

#### GET /events/:id

**Request:**
```http
GET /events/evt-001
Authorization: Bearer jwt_token_here
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "evt-001",
    "title": "Sprzątanie Parku Jordana",
    // ... wszystkie pola wydarzenia
    "organization": {
      "id": "org-001",
      "name": "Fundacja Czyste Miasto",
      "email": "kontakt@czystemasto.pl"
    }
  }
}
```

**Errors:**
- `404 Not Found` - Wydarzenie nie istnieje (DB-002)

---

#### POST /events

**Tylko dla organizacji**

**Request:**
```json
{
  "title": "Nowe wydarzenie",
  "description": "Opis...",
  "date": "2025-11-20T14:00:00Z",
  "location": "Rynek Główny, Kraków",
  "latitude": 50.0619,
  "longitude": 19.9369,
  "volunteersNeeded": 30,
  "category": "kultura",
  "requirements": "Brak szczególnych wymagań",
  "imageUrl": "https://example.com/image.jpg"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "evt-123",
    "title": "Nowe wydarzenie",
    // ... wszystkie pola
    "status": "upcoming",
    "createdAt": "2025-10-05T12:00:00Z"
  }
}
```

**Errors:**
- `401 Unauthorized` - Brak tokenu (AUTH-004)
- `403 Forbidden` - Nie jesteś organizacją (AUTH-005)
- `400 Bad Request` - Walidacja nie powiodła się

---

#### PUT /events/:id

**Tylko dla organizacji (właściciel wydarzenia)**

**Request:**
```json
{
  "title": "Zaktualizowany tytuł",
  "volunteersNeeded": 25
  // ... inne pola do aktualizacji
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": { /* zaktualizowane wydarzenie */ }
}
```

---

#### DELETE /events/:id

**Tylko dla organizacji (właściciel wydarzenia)**

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Event deleted successfully"
}
```

---

### 16.5.3. Applications Endpoints

#### POST /applications

**Request:**
```json
{
  "eventId": "evt-001",
  "motivation": "Chcę pomóc w ochronie środowiska..."
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "app-123",
    "eventId": "evt-001",
    "userId": "user-123",
    "status": "pending",
    "motivation": "Chcę pomóc...",
    "appliedAt": "2025-10-05T12:00:00Z"
  }
}
```

**Errors:**
- `409 Conflict` - Już aplikowano (BIZ-002)
- `400 Bad Request` - Wydarzenie pełne (BIZ-001)

---

#### GET /applications/me

**Query Parameters:**
- `status` (optional) - filtruj po statusie (pending, approved, rejected)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "applications": [
      {
        "id": "app-123",
        "event": { /* pełne dane wydarzenia */ },
        "status": "approved",
        "appliedAt": "2025-10-05T12:00:00Z",
        "reviewedAt": "2025-10-06T10:00:00Z"
      }
      // ... więcej aplikacji
    ]
  }
}
```

---

#### GET /events/:eventId/applications

**Tylko dla organizacji (właściciel wydarzenia)**

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "applications": [
      {
        "id": "app-456",
        "user": {
          "id": "user-789",
          "name": "Anna Nowak",
          "email": "anna@uek.krakow.pl"
        },
        "status": "pending",
        "motivation": "...",
        "appliedAt": "2025-10-05T12:00:00Z"
      }
      // ... więcej aplikacji
    ]
  }
}
```

---

#### PUT /applications/:id

**Tylko dla organizacji (akceptacja/odrzucenie)**

**Request:**
```json
{
  "status": "approved"  // lub "rejected"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": { /* zaktualizowana aplikacja */ }
}
```

---

### 16.5.4. Certificates Endpoints

#### GET /certificates/me

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "certificates": [
      {
        "id": "cert-001",
        "eventTitle": "Sprzątanie Parku Jordana",
        "hoursCompleted": 4,
        "issueDate": "2025-10-15T14:00:00Z",
        "certificateUrl": "https://cdn.smokpomaga.pl/certificates/cert-001.pdf",
        "description": "Uczestniczył w całym wydarzeniu",
        "verified": false
      }
      // ... więcej certyfikatów
    ],
    "totalHours": 42
  }
}
```

---

#### GET /certificates/:id/pdf

**Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/pdf
Content-Disposition: attachment; filename="certificate-cert-001.pdf"

[binary PDF data]
```

---

### 16.5.5. Users Endpoints

#### GET /users/me

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "user-123",
    "email": "jan@uek.krakow.pl",
    "name": "Jan Kowalski",
    "role": "volunteer",
    "phoneNumber": "+48123456789",
    "avatarUrl": "https://cdn.smokpomaga.pl/avatars/user-123.jpg",
    "createdAt": "2025-09-01T10:00:00Z",
    "stats": {
      "totalApplications": 5,
      "approvedApplications": 3,
      "totalHours": 12,
      "certificatesCount": 2
    }
  }
}
```

---

#### PUT /users/me

**Request:**
```json
{
  "name": "Jan Kowalski",
  "phoneNumber": "+48987654321"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": { /* zaktualizowany user */ }
}
```

---

#### POST /users/me/avatar

**Request:**
```http
Content-Type: multipart/form-data

avatar: [binary image data]
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "avatarUrl": "https://cdn.smokpomaga.pl/avatars/user-123.jpg"
  }
}
```

---

## 16.6. Error Responses (Standard)

### 16.6.1. Format błędu

```json
{
  "success": false,
  "error": {
    "code": "AUTH-001",
    "message": "Nieprawidłowy email lub hasło",
    "details": "Email validation failed",
    "timestamp": "2025-10-05T12:00:00Z"
  }
}
```

### 16.6.2. HTTP Status Codes

| Kod | Znaczenie | Kiedy |
|-----|-----------|-------|
| 200 | OK | Sukces (GET, PUT, DELETE) |
| 201 | Created | Sukces (POST) |
| 400 | Bad Request | Walidacja nie powiodła się |
| 401 | Unauthorized | Brak tokenu lub nieprawidłowy token |
| 403 | Forbidden | Brak uprawnień |
| 404 | Not Found | Zasób nie istnieje |
| 409 | Conflict | Konflikt (np. duplikat) |
| 429 | Too Many Requests | Rate limiting |
| 500 | Internal Server Error | Błąd serwera |
| 503 | Service Unavailable | Serwis niedostępny |

---

## 16.7. Przyszłe integracje

### 16.7.1. Firebase Cloud Messaging (Push Notifications)

**Cel:** Powiadomienia o akceptacji aplikacji, nowych wydarzeniach, przypomnieniach.

**Implementacja:**
```yaml
dependencies:
  firebase_messaging: ^14.0.0
```

**Typy powiadomień:**
- Akceptacja aplikacji
- Odrzucenie aplikacji
- Nowe wydarzenie w kategorii
- Przypomnienie o wydarzeniu (24h przed)
- Nowy certyfikat

---

### 16.7.2. Firebase Authentication (OAuth)

**Cel:** Logowanie przez Google, Facebook.

```yaml
dependencies:
  firebase_auth: ^4.0.0
  google_sign_in: ^6.0.0
```

**Flow:**
```dart
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
await FirebaseAuth.instance.signInWithCredential(credential);
```

---

### 16.7.3. Cloudinary / AWS S3 (Image Hosting)

**Cel:** Przechowywanie zdjęć wydarzeń, avatarów użytkowników.

**Upload flow:**
1. Użytkownik wybiera zdjęcie (image_picker)
2. Aplikacja upload do Cloudinary/S3
3. Otrzymuje URL
4. Zapisuje URL w bazie danych

---

### 16.7.4. SendGrid / Mailgun (Email)

**Cel:** Email notifications (potwierdzenie rejestracji, reset hasła).

**Typy emaili:**
- Potwierdzenie rejestracji
- Reset hasła
- Powiadomienie o akceptacji aplikacji
- Newsletter z nowymi wydarzeniami

---

### 16.7.5. Google Analytics / Mixpanel

**Cel:** Tracking zachowań użytkowników, analityka.

**Events do trackowania:**
- Rejestracja
- Logowanie
- Przeglądanie wydarzenia
- Aplikowanie na wydarzenie
- Pobieranie certyfikatu PDF

---

## 16.8. Rate Limiting (Planowane)

### 16.8.1. Limity

| Endpoint | Limit |
|----------|-------|
| POST /auth/login | 5 prób / 15 min |
| POST /auth/register | 3 rejestracje / godzinę |
| GET /events | 100 żądań / minutę |
| POST /applications | 10 aplikacji / godzinę |

### 16.8.2. Headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1633430400
```

---

## 16.9. Versioning API

### 16.9.1. URL Versioning

```
https://api.smokpomaga.pl/v1/events
https://api.smokpomaga.pl/v2/events  (future)
```

### 16.9.2. Deprecation

Stare wersje będą wspierane przez min. 6 miesięcy po wprowadzeniu nowej wersji.

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga
