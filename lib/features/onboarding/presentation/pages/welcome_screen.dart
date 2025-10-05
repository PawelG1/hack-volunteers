import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const WelcomeScreen({super.key, required this.onComplete});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedCookies = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (!_acceptedTerms || !_acceptedPrivacy || !_acceptedCookies) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Musisz zaakceptować wszystkie zgody aby kontynuować'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save that user has completed onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await prefs.setBool('accepted_terms', true);
    await prefs.setBool('accepted_privacy', true);
    await prefs.setBool('accepted_cookies', true);
    await prefs.setString('acceptance_date', DateTime.now().toIso8601String());

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryMagenta,
              AppColors.primaryBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentPage >= index
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildPrivacyPage(),
                    _buildConsentPage(),
                  ],
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          'Wstecz',
                          style: TextStyle(
                            color: AppColors.primaryMagenta,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 80),
                    
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == 2
                            ? (_acceptedTerms && _acceptedPrivacy && _acceptedCookies
                                ? AppColors.primaryMagenta
                                : Colors.grey)
                            : AppColors.primaryMagenta,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      child: Text(
                        _currentPage == 2 ? 'Rozpocznij' : 'Dalej',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.volunteer_activism,
              size: 60,
              color: AppColors.primaryMagenta,
            ),
          ),
          const SizedBox(height: 32),

          // Title
          const Text(
            'Witaj w HackVolunteers!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          const Text(
            'Platforma łącząca młodych wolontariuszy z organizacjami potrzebującymi pomocy',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Features
          _buildFeatureCard(
            icon: Icons.search,
            title: 'Znajdź wydarzenia',
            description: 'Przeglądaj i filtruj wydarzenia wolontariackie w Twojej okolicy',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: Icons.calendar_today,
            title: 'Zarządzaj kalendarzem',
            description: 'Śledź swoje wydarzenia i godziny wolontariatu',
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            icon: Icons.workspace_premium,
            title: 'Zdobywaj certyfikaty',
            description: 'Otrzymuj potwierdzenia za swoją pracę wolontariacką',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.privacy_tip_outlined,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 24),

          const Text(
            'Ochrona Twoich danych',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          _buildInfoSection(
            icon: Icons.lock_outline,
            title: 'Bezpieczeństwo danych',
            content: 'Twoje dane osobowe są przechowywane lokalnie na Twoim urządzeniu i chronione zgodnie z najlepszymi praktykami bezpieczeństwa.',
          ),
          const SizedBox(height: 20),

          _buildInfoSection(
            icon: Icons.storage_outlined,
            title: 'Przetwarzanie danych',
            content: 'Gromadzimy tylko niezbędne informacje: imię, nazwisko, email, szkołę i zainteresowania. Dane są używane wyłącznie do funkcjonowania aplikacji.',
          ),
          const SizedBox(height: 20),

          _buildInfoSection(
            icon: Icons.share_outlined,
            title: 'Udostępnianie danych',
            content: 'Twoje dane nie są sprzedawane ani udostępniane osobom trzecim. Organizacje widzą tylko podstawowe informacje podczas aplikowania na wydarzenia.',
          ),
          const SizedBox(height: 20),

          _buildInfoSection(
            icon: Icons.delete_outline,
            title: 'Prawo do usunięcia',
            content: 'Masz prawo do usunięcia swojego konta i wszystkich powiązanych danych w dowolnym momencie z poziomu ustawień aplikacji.',
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Działamy zgodnie z RODO i polskim prawem ochrony danych osobowych',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Icon(
            Icons.verified_user_outlined,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 24),

          const Text(
            'Wymagane zgody',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aby korzystać z aplikacji, musisz zaakceptować poniższe warunki:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // Terms checkbox
          _buildConsentCheckbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            title: 'Regulamin i Warunki Użytkowania',
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                children: [
                  const TextSpan(text: 'Akceptuję '),
                  TextSpan(
                    text: 'Regulamin',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showTermsDialog('Regulamin i Warunki Użytkowania', _getTermsText());
                      },
                  ),
                  const TextSpan(text: ' aplikacji HackVolunteers'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Privacy policy checkbox
          _buildConsentCheckbox(
            value: _acceptedPrivacy,
            onChanged: (value) {
              setState(() {
                _acceptedPrivacy = value ?? false;
              });
            },
            title: 'Polityka Prywatności',
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                children: [
                  const TextSpan(text: 'Akceptuję '),
                  TextSpan(
                    text: 'Politykę Prywatności',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showTermsDialog('Polityka Prywatności', _getPrivacyPolicyText());
                      },
                  ),
                  const TextSpan(text: ' i wyrażam zgodę na przetwarzanie moich danych osobowych'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Cookies checkbox
          _buildConsentCheckbox(
            value: _acceptedCookies,
            onChanged: (value) {
              setState(() {
                _acceptedCookies = value ?? false;
              });
            },
            title: 'Cookies i Dane Lokalne',
            content: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                children: [
                  const TextSpan(
                    text: 'Wyrażam zgodę na przechowywanie danych lokalnie na moim urządzeniu (cookies/local storage) w celu prawidłowego działania aplikacji. ',
                  ),
                  TextSpan(
                    text: 'Dowiedz się więcej',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showTermsDialog('Informacje o Cookies', _getCookiesText());
                      },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Musisz zaakceptować wszystkie zgody, aby korzystać z aplikacji',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryMagenta.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryMagenta, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConsentCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColors.primaryMagenta : Colors.grey.shade300,
          width: value ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primaryMagenta,
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: content,
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }

  String _getTermsText() {
    return '''
REGULAMIN I WARUNKI UŻYTKOWANIA APLIKACJI HACKVOLUNTEERS

1. POSTANOWIENIA OGÓLNE
1.1. Niniejszy regulamin określa zasady korzystania z aplikacji mobilnej HackVolunteers.
1.2. Użytkownikiem aplikacji może być osoba fizyczna posiadająca pełną zdolność do czynności prawnych.
1.3. Korzystanie z aplikacji jest równoznaczne z akceptacją niniejszego regulaminu.

2. ZAKRES USŁUG
2.1. Aplikacja umożliwia:
   - Przeglądanie wydarzeń wolontariackich
   - Aplikowanie na wydarzenia
   - Zarządzanie kalendarzem wolontariatu
   - Śledzenie godzin wolontariatu
   - Otrzymywanie certyfikatów

3. REJESTRACJA I KONTO
3.1. Rejestracja wymaga podania prawdziwych danych osobowych.
3.2. Użytkownik zobowiązuje się do zachowania hasła w tajemnicy.
3.3. Użytkownik odpowiada za wszelkie działania wykonane z jego konta.

4. PRAWA I OBOWIĄZKI UŻYTKOWNIKA
4.1. Użytkownik zobowiązuje się do:
   - Przestrzegania regulaminu
   - Podawania prawdziwych informacji
   - Nieudostępniania swojego konta osobom trzecim
   - Informowania o zmianach danych osobowych

5. ODPOWIEDZIALNOŚĆ
5.1. Operator nie ponosi odpowiedzialności za:
   - Szkody wynikłe z nieprawidłowego korzystania z aplikacji
   - Działania osób trzecich (organizatorów wydarzeń)
   - Tymczasową niedostępność usług

6. POSTANOWIENIA KOŃCOWE
6.1. Regulamin może ulec zmianie.
6.2. Użytkownik zostanie poinformowany o zmianach.
6.3. W sprawach nieuregulowanych stosuje się przepisy prawa polskiego.
''';
  }

  String _getPrivacyPolicyText() {
    return '''
POLITYKA PRYWATNOŚCI APLIKACJI HACKVOLUNTEERS

1. ADMINISTRATOR DANYCH
Administrator danych osobowych: [Nazwa organizacji]
Kontakt: privacy@hackvolunteers.pl

2. JAKIE DANE GROMADZIMY
2.1. Dane rejestracyjne:
   - Imię i nazwisko
   - Adres email
   - Numer telefonu (opcjonalnie)
   - Nazwa szkoły
   - Data urodzenia

2.2. Dane profilowe:
   - Zainteresowania
   - Zdjęcie profilowe (opcjonalnie)
   - Historia wolontariatu

3. CEL PRZETWARZANIA DANYCH
3.1. Dane są przetwarzane w celu:
   - Świadczenia usług aplikacji
   - Łączenia z organizatorami wydarzeń
   - Generowania certyfikatów
   - Komunikacji z użytkownikiem
   - Poprawy jakości usług

4. PODSTAWA PRAWNA
4.1. Zgoda użytkownika (art. 6 ust. 1 lit. a RODO)
4.2. Niezbędność do wykonania umowy (art. 6 ust. 1 lit. b RODO)
4.3. Prawnie uzasadniony interes administratora (art. 6 ust. 1 lit. f RODO)

5. UDOSTĘPNIANIE DANYCH
5.1. Dane mogą być udostępniane:
   - Organizatorom wydarzeń (po aplikowaniu)
   - Organom państwowym (na żądanie prawne)
   - Partnerom technologicznym (hosting, analityka)

5.2. Dane NIE SĄ sprzedawane osobom trzecim.

6. OKRES PRZECHOWYWANIA
6.1. Dane przechowywane są przez okres:
   - Korzystania z aplikacji
   - + 3 lata po usunięciu konta (wymogi prawne)

7. PRAWA UŻYTKOWNIKA
7.1. Masz prawo do:
   - Dostępu do swoich danych
   - Sprostowania danych
   - Usunięcia danych ("prawo do bycia zapomnianym")
   - Ograniczenia przetwarzania
   - Przenoszenia danych
   - Sprzeciwu wobec przetwarzania
   - Cofnięcia zgody

8. BEZPIECZEŃSTWO
8.1. Stosujemy środki techniczne i organizacyjne zabezpieczające dane:
   - Szyfrowanie danych
   - Kontrola dostępu
   - Regularne audyty bezpieczeństwa
   - Kopie zapasowe

9. ZMIANY POLITYKI
9.1. Polityka może ulec zmianie.
9.2. Użytkownik zostanie poinformowany o istotnych zmianach.

10. KONTAKT
W sprawach dotyczących przetwarzania danych osobowych:
Email: privacy@hackvolunteers.pl
Telefon: +48 XXX XXX XXX
''';
  }

  String _getCookiesText() {
    return '''
INFORMACJE O COOKIES I DANYCH LOKALNYCH

1. CZYM SĄ COOKIES/DANE LOKALNE?
Cookies (ciasteczka) oraz dane lokalne to małe pliki lub informacje przechowywane na Twoim urządzeniu, które umożliwiają aplikacji zapamiętanie Twoich preferencji i ustawień.

2. JAKIE DANE PRZECHOWUJEMY LOKALNIE?
2.1. Dane niezbędne:
   - Token sesji (zalogowanie)
   - Preferencje językowe
   - Ustawienia aplikacji
   - Cache zdjęć i danych

2.2. Dane profilowe:
   - Informacje o koncie
   - Historia wolontariatu
   - Zapisane wydarzenia

3. CEL PRZECHOWYWANIA
3.1. Dane lokalne służą do:
   - Utrzymania sesji logowania
   - Szybszego działania aplikacji
   - Offline mode (podstawowe funkcje bez internetu)
   - Personalizacji doświadczenia

4. RODZAJE DANYCH LOKALNYCH
4.1. Cookies niezbędne:
   - Wymagane do działania aplikacji
   - Nie można ich wyłączyć
   - Usuwane po wylogowaniu

4.2. Cookies funkcjonalne:
   - Zapamiętywanie preferencji
   - Ustawienia języka
   - Ustawienia powiadomień

5. ZARZĄDZANIE COOKIES
5.1. Możesz zarządzać cookies poprzez:
   - Ustawienia aplikacji
   - Wylogowanie (usuwa sesję)
   - Odinstalowanie aplikacji (usuwa wszystko)

6. BEZPIECZEŃSTWO
6.1. Dane lokalne są:
   - Przechowywane tylko na Twoim urządzeniu
   - Zabezpieczone szyfrowaniem
   - Niedostępne dla innych aplikacji
   - Automatycznie usuwane przy odinstalowaniu

7. TWOJE PRAWA
7.1. Masz prawo do:
   - Przeglądu danych lokalnych
   - Usunięcia wszystkich danych
   - Cofnięcia zgody (wylogowanie)

8. AKTUALIZACJE
Aplikacja może aktualizować sposób przechowywania danych lokalnych. Zostaniesz poinformowany o istotnych zmianach.

9. PYTANIA
W razie pytań dotyczących cookies:
Email: privacy@hackvolunteers.pl
''';
  }
}
