# 17. Konta Techniczne

**Dokument:** 17_Konta_Techniczne.md  
**Wersja:** 1.0.0  
**Data:** 5 października 2025

## 17.1. Przegląd

Niniejszy dokument zawiera listę wszystkich kont technicznych używanych przez aplikację SmokPomaga oraz instrukcje zarządzania nimi.

---

## 17.2. Stan obecny

### 17.2.1. Brak kont technicznych

Obecnie aplikacja **nie wykorzystuje żadnych kont technicznych** ani zewnętrznych serwisów wymagających uwierzytelnienia (poza OpenStreetMap, który jest publiczny i nie wymaga konta).

Wszystkie dane są przechowywane lokalnie w bazie danych Isar na urządzeniu użytkownika.

---

## 17.3. Planowane konta techniczne (Future)

### 17.3.1. Backend API (Serwer aplikacji)

#### 17.3.1.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Usługa** | Backend REST API (Node.js/Django/FastAPI) |
| **URL** | https://api.smokpomaga.pl |
| **Środowisko** | Production, Development, Staging |
| **Właściciel** | Zespół deweloperski SmokPomaga |

#### 17.3.1.2. Dostęp do serwera

| Typ dostępu | Szczegóły | Kto ma dostęp |
|-------------|-----------|---------------|
| **SSH** | ssh admin@api.smokpomaga.pl | DevOps Team |
| **Database** | PostgreSQL (port 5432) | Backend Developers |
| **Logs** | CloudWatch / ELK Stack | DevOps, Backend Developers |

#### 17.3.1.3. Zmienne środowiskowe

```bash
# .env (przykład)
DATABASE_URL=postgresql://user:pass@localhost:5432/smokpomaga_db
JWT_SECRET=super_secret_key_change_in_production
API_KEY=api_key_for_external_services
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASSWORD=SG.xxx
```

**⚠️ UWAGA:** Nigdy nie commituj pliku `.env` do repozytorium Git!

---

### 17.3.2. Baza danych (PostgreSQL/MySQL)

#### 17.3.2.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Typ bazy** | PostgreSQL 15 |
| **Host** | db.smokpomaga.pl |
| **Port** | 5432 |
| **Nazwa bazy** | smokpomaga_production |

#### 17.3.2.2. Konta użytkowników

| Użytkownik | Hasło | Uprawnienia | Cel |
|------------|-------|-------------|-----|
| `postgres` | [vault] | Superuser | Administracja |
| `smokpomaga_app` | [vault] | Read/Write | Aplikacja backend |
| `smokpomaga_readonly` | [vault] | Read Only | Raporty, analytics |
| `backup_user` | [vault] | Read Only | Backupy |

**⚠️ Hasła przechowywane w:** AWS Secrets Manager / HashiCorp Vault

#### 17.3.2.3. Rotacja haseł

- **Częstotliwość:** Co 90 dni
- **Procedura:** Dokumentowana w `04_Kopie_Zapasowe.md`
- **Odpowiedzialny:** DevOps Team

---

### 17.3.3. Firebase (Authentication, FCM, Crashlytics)

#### 17.3.3.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Projekt** | smokpomaga-prod |
| **Project ID** | smokpomaga-12345 |
| **Console** | https://console.firebase.google.com |

#### 17.3.3.2. Konta z dostępem

| Email | Rola | Uprawnienia |
|-------|------|-------------|
| admin@smokpomaga.pl | Owner | Pełny dostęp |
| devops@smokpomaga.pl | Editor | Konfiguracja, deploy |
| developer@smokpomaga.pl | Viewer | Odczyt logów, crashlytics |

#### 17.3.3.3. API Keys

```
// Firebase config (public - może być w kodzie)
{
  "apiKey": "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "authDomain": "smokpomaga-12345.firebaseapp.com",
  "projectId": "smokpomaga-12345",
  "storageBucket": "smokpomaga-12345.appspot.com",
  "messagingSenderId": "123456789",
  "appId": "1:123456789:android:abcdef123456"
}
```

**⚠️ UWAGA:** `apiKey` Firebase jest publiczny i nie stanowi zagrożenia bezpieczeństwa.

---

### 17.3.4. Cloudinary (Image Hosting)

#### 17.3.4.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Cloud Name** | smokpomaga |
| **Console** | https://cloudinary.com/console |

#### 17.3.4.2. Credentials

| Typ | Wartość | Użycie |
|-----|---------|--------|
| **API Key** | 123456789012345 | Publiczne (upload widget) |
| **API Secret** | [vault] | Backend (secure operations) |

#### 17.3.4.3. Upload Presets

| Preset Name | Folder | Transformacje |
|-------------|--------|---------------|
| `event_images` | /events/ | Resize 1200x800, Quality 80% |
| `avatars` | /avatars/ | Crop 300x300, Circle |
| `certificates` | /certificates/ | Watermark, PDF |

---

### 17.3.5. SendGrid / Mailgun (Email Service)

#### 17.3.5.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Provider** | SendGrid |
| **Plan** | Pro (100k emails/month) |
| **Console** | https://app.sendgrid.com |

#### 17.3.5.2. API Keys

| Nazwa | Scope | Użycie |
|-------|-------|--------|
| `smokpomaga-prod` | Full Access | Production backend |
| `smokpomaga-dev` | Full Access | Development/Testing |

#### 17.3.5.3. Email Templates

| ID | Nazwa | Cel |
|----|-------|-----|
| d-abc123 | welcome_email | Powitanie po rejestracji |
| d-def456 | application_approved | Akceptacja aplikacji |
| d-ghi789 | password_reset | Reset hasła |

---

### 17.3.6. Google Cloud Platform (Maps, Analytics)

#### 17.3.6.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Projekt** | smokpomaga-gcp |
| **Project ID** | smokpomaga-gcp-12345 |
| **Console** | https://console.cloud.google.com |

#### 17.3.6.2. API Keys (jeśli używamy Google Maps zamiast OSM)

| Nazwa | Restrictions | Użycie |
|-------|--------------|--------|
| `Android App Key` | Restricted to package name | Aplikacja Android |
| `iOS App Key` | Restricted to bundle ID | Aplikacja iOS (future) |

**Ograniczenia:**
- Android: `com.mlodykrakow.hack_volunteers`
- API: Maps SDK for Android, Places API

---

### 17.3.7. AWS (Hosting, S3, CloudFront)

#### 17.3.7.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Account ID** | 123456789012 |
| **Region** | eu-central-1 (Frankfurt) |
| **Console** | https://console.aws.amazon.com |

#### 17.3.7.2. IAM Users

| Username | Access Type | Uprawnienia | Cel |
|----------|-------------|-------------|-----|
| `smokpomaga-deploy` | Programmatic | EC2, S3, CloudFront | CI/CD deployment |
| `smokpomaga-backup` | Programmatic | S3 Read/Write | Backupy bazy danych |
| `smokpomaga-admin` | Console + API | Administrator | Administracja |

#### 17.3.7.3. S3 Buckets

| Bucket Name | Region | Cel | Public? |
|-------------|--------|-----|---------|
| `smokpomaga-uploads` | eu-central-1 | Uploaded files | Tak (read-only) |
| `smokpomaga-backups` | eu-central-1 | Database backups | Nie |
| `smokpomaga-logs` | eu-central-1 | Application logs | Nie |

---

### 17.3.8. GitHub (Repozytorium kodu)

#### 17.3.8.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Organization** | PawelG1 |
| **Repository** | hack-volunteers |
| **URL** | https://github.com/PawelG1/hack-volunteers |
| **Visibility** | Private |

#### 17.3.8.2. Użytkownicy z dostępem

| Username | Role | Uprawnienia |
|----------|------|-------------|
| PawelG1 | Owner | Full access |
| [developer2] | Maintainer | Push, PR review |
| [developer3] | Write | Push, PR |

#### 17.3.8.3. Deploy Keys

| Nazwa | Typ | Użycie |
|-------|-----|--------|
| `CI/CD Server` | Read-only | GitHub Actions pull |
| `Production Deploy` | Read-only | Deployment script |

#### 17.3.8.4. Secrets (GitHub Actions)

| Secret Name | Wartość | Użycie |
|-------------|---------|--------|
| `FIREBASE_TOKEN` | [encrypted] | Firebase deploy |
| `GOOGLE_SERVICES_JSON` | [encrypted] | Android build |
| `KEYSTORE_PASSWORD` | [encrypted] | Release signing |

---

### 17.3.9. Google Play Console (Android Publishing)

#### 17.3.9.1. Podstawowe informacje

| Parametr | Wartość |
|----------|---------|
| **Package Name** | com.mlodykrakow.hack_volunteers |
| **Console** | https://play.google.com/console |
| **Developer Account** | dev@smokpomaga.pl |

#### 17.3.9.2. Użytkownicy z dostępem

| Email | Role | Uprawnienia |
|-------|------|-------------|
| admin@smokpomaga.pl | Admin | Pełny dostęp |
| developer@smokpomaga.pl | Developer | Release management |

#### 17.3.9.3. Signing Keys

| Typ | Keystore | Użycie |
|-----|----------|--------|
| **Debug** | debug.keystore | Development |
| **Release** | release.keystore | Production (managed by Google Play) |

**⚠️ Keystore password:** Przechowywany w Vault/Secrets Manager

---

### 17.3.10. Analytics (Mixpanel / Google Analytics)

#### 17.3.10.1. Mixpanel

| Parametr | Wartość |
|----------|---------|
| **Project** | SmokPomaga |
| **Token** | abc123def456 |
| **Console** | https://mixpanel.com |

#### 17.3.10.2. Google Analytics

| Parametr | Wartość |
|----------|---------|
| **Property ID** | G-XXXXXXXXXX |
| **Console** | https://analytics.google.com |

---

## 17.4. Zarządzanie hasłami

### 17.4.1. Password Manager (Zalecane)

Wszystkie hasła i klucze API powinny być przechowywane w:

- **1Password Teams** (zalecane)
- **LastPass Enterprise**
- **AWS Secrets Manager**
- **HashiCorp Vault**

**⚠️ NIE przechowuj haseł w:**
- Plikach tekstowych na dysku
- Repozytorium Git
- Email/Slack
- Google Docs

### 17.4.2. Wymagania dotyczące haseł

| Typ konta | Min. długość | Wymagania | Rotacja |
|-----------|--------------|-----------|---------|
| **Database** | 32 znaków | Losowe (a-zA-Z0-9!@#$) | Co 90 dni |
| **API Keys** | 32 znaków | Losowe | Co 180 dni |
| **Admin accounts** | 16 znaków | 2FA wymagane | Co 90 dni |
| **Service accounts** | 32 znaków | Losowe | Co 180 dni |

### 17.4.3. Generowanie silnych haseł

```bash
# Linux/Mac
openssl rand -base64 32

# Python
import secrets
secrets.token_urlsafe(32)

# Node.js
require('crypto').randomBytes(32).toString('base64')
```

---

## 17.5. Bezpieczeństwo

### 17.5.1. Two-Factor Authentication (2FA)

Wszystkie konta z dostępem produkcyjnym **MUSZĄ** mieć włączone 2FA:

- ✅ GitHub
- ✅ Firebase Console
- ✅ AWS Console
- ✅ Google Play Console
- ✅ Cloudinary
- ✅ SendGrid

**Metody 2FA (w kolejności preferencji):**
1. Hardware token (YubiKey)
2. Authenticator app (Google Authenticator, Authy)
3. SMS (tylko jako backup)

### 17.5.2. IP Whitelisting

Dostęp do produkcyjnych serwisów powinien być ograniczony do znanych IP:

```
# Dozwolone IP
Office IP: 203.0.113.0/24
VPN IP: 198.51.100.0/24
CI/CD Server: 192.0.2.50
```

### 17.5.3. Audit Logs

Wszystkie operacje na kontach technicznych powinny być logowane:

- Logowanie/wylogowanie
- Zmiana haseł
- Dodanie/usunięcie użytkowników
- Zmiana uprawnień
- Deploy do produkcji

**Przechowywanie:** Min. 1 rok

---

## 17.6. Procedury awaryjne

### 17.6.1. Podejrzenie wycieku klucza API

**Natychmiastowe kroki:**

1. **Zablokuj klucz** w konsoli usługi
2. **Wygeneruj nowy klucz**
3. **Zaktualizuj aplikację/backend** z nowym kluczem
4. **Sprawdź logi** pod kątem nieautoryzowanego użycia
5. **Powiadom zespół** przez Slack/Email
6. **Dokumentuj incident** w wiki

### 17.6.2. Kompromitacja konta użytkownika

**Natychmiastowe kroki:**

1. **Zresetuj hasło** dla konta
2. **Unieważnij wszystkie sesje** (logout everywhere)
3. **Sprawdź logi aktywności** (ostatnie 30 dni)
4. **Włącz 2FA** jeśli nie było włączone
5. **Powiadom właściciela konta**
6. **Raport do security team**

### 17.6.3. Kontakty awaryjne

| Rola | Imię | Email | Telefon |
|------|------|-------|---------|
| **DevOps Lead** | [Imię] | devops@smokpomaga.pl | +48 XXX XXX XXX |
| **Security Officer** | [Imię] | security@smokpomaga.pl | +48 XXX XXX XXX |
| **CTO** | [Imię] | cto@smokpomaga.pl | +48 XXX XXX XXX |

---

## 17.7. Onboarding nowego dewelopera

### 17.7.1. Checklist dostępów

- [ ] GitHub - dodaj do organizacji
- [ ] Firebase Console - dodaj jako Viewer/Editor
- [ ] AWS Console - utwórz IAM user (jeśli potrzebne)
- [ ] 1Password/Vault - dodaj do shared vault
- [ ] Slack - dodaj do kanałów #dev, #alerts
- [ ] Email - utwórz konto @smokpomaga.pl (opcjonalne)

### 17.7.2. Dokumentacja dla dewelopera

Udostępnij:
- README.md projektu
- Dokumenty 01-19 z folderu `documents/`
- Invite do Slack/Teams
- Credentials w password manager

---

## 17.8. Offboarding dewelopera

### 17.8.1. Checklist usuwania dostępów

- [ ] GitHub - usuń z organizacji
- [ ] Firebase Console - usuń użytkownika
- [ ] AWS Console - usuń/disable IAM user
- [ ] 1Password/Vault - usuń z shared vault
- [ ] Zrotuj wszystkie współdzielone hasła
- [ ] Google Workspace - usuń konto email (jeśli było)
- [ ] Slack - deactivate account

**⚠️ Wykonaj w ciągu 24 godzin od odejścia pracownika!**

---

## 17.9. Monitoring i alerty

### 17.9.1. Narzędzia monitoringu

| Usługa | Narzędzie | Alerty |
|--------|-----------|--------|
| **Serwer backend** | CloudWatch / Datadog | CPU > 80%, Memory > 90% |
| **Baza danych** | AWS RDS Monitoring | Connections > 90%, Storage < 10% |
| **API uptime** | UptimeRobot | Downtime > 5 min |
| **Logs** | ELK Stack / CloudWatch | Error rate > 5% |

### 17.9.2. Kanały alertów

- **Critical:** PagerDuty → SMS/Phone call
- **High:** Slack channel #alerts
- **Medium:** Email do dev@smokpomaga.pl
- **Low:** Dashboard (passive monitoring)

---

## 17.10. Compliance i audyty

### 17.10.1. Audyt kwartalny

**Co kwartał sprawdź:**
- [ ] Czy wszyscy użytkownicy mają włączone 2FA
- [ ] Czy hasła zostały zrotowane zgodnie z polityką
- [ ] Czy nieaktywne konta zostały usunięte
- [ ] Czy logi są archiwizowane poprawnie
- [ ] Czy backupy działają

### 17.10.2. Dokumentacja zmian

Wszystkie zmiany w kontach technicznych dokumentuj w:
- **Change log:** `CHANGELOG_INFRASTRUCTURE.md`
- **Confluence/Notion:** Strona "Infrastructure Changes"
- **Slack:** Kanał #infrastructure

---

**Ostatnia aktualizacja:** 5 października 2025  
**Autor:** Zespół deweloperski SmokPomaga  
**Odpowiedzialny:** DevOps Team
