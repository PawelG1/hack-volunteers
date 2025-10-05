import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/mlody_krakow_footer.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/organization_bloc.dart';
import 'manage_events_page.dart';
import 'applications_list_page.dart';

/// Organization Dashboard with bottom navigation
class OrganizationDashboard extends StatefulWidget {
  const OrganizationDashboard({super.key});

  @override
  State<OrganizationDashboard> createState() => _OrganizationDashboardState();
}

class _OrganizationDashboardState extends State<OrganizationDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Organizacji'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                // Clear user role and navigate to login
                AppRouter.logout();
                context.go('/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Profil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Ustawienia'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AppColors.error),
                    SizedBox(width: 12),
                    Text('Wyloguj', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Wydarzenia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Aplikacje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Czat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            activeIcon: Icon(Icons.assessment),
            label: 'Raporty',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildEventsTab();
      case 2:
        return _buildApplicationsTab();
      case 3:
        return _buildChatTab();
      case 4:
        return _buildReportsTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [AppColors.cardShadow],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Witaj! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Organizacja: Bank Żywności',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Statistics
          const Text(
            'Statystyki',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                icon: Icons.event,
                label: 'Aktywne wydarzenia',
                value: '12',
                color: AppColors.primaryBlue,
              ),
              _buildStatCard(
                icon: Icons.people,
                label: 'Wolontariusze',
                value: '45',
                color: AppColors.primaryMagenta,
              ),
              _buildStatCard(
                icon: Icons.pending_actions,
                label: 'Oczekujące',
                value: '8',
                color: AppColors.accentOrange,
              ),
              _buildStatCard(
                icon: Icons.access_time,
                label: 'Godziny pracy',
                value: '340',
                color: AppColors.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Szybkie akcje',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildActionButton(
            icon: Icons.add_circle_outline,
            label: 'Dodaj nowe wydarzenie',
            color: AppColors.primaryBlue,
            onTap: () {
              context.go('/organization/events');
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.check_circle_outline,
            label: 'Zaakceptuj aplikacje',
            color: AppColors.primaryGreen,
            onTap: () {
              context.go('/organization/applications');
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.card_giftcard_outlined,
            label: 'Wystaw certyfikat',
            color: AppColors.accentPurple,
            onTap: () {
              context.go('/organization/certificates');
            },
          ),
          const SizedBox(height: 32),
          
          // Footer z informacją o wsparciu
          const MlodyKrakowFooter(),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Zarządzanie wydarzeniami',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Wkrótce dostępne',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => di.sl<OrganizationBloc>(),
                    child: const ManageEventsPage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Zarządzaj wydarzeniami'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab() {
    return BlocProvider(
      create: (context) => di.sl<OrganizationBloc>(),
      child: const ApplicationsListPage(
        organizationId: 'sample-org',
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // Header with search
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Szukaj konwersacji...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        
        // Conversations list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildChatTile(
                name: 'Anna Kowalska',
                lastMessage: 'Dzień dobry! Czy mogę zadać pytanie odnośnie wydarzenia?',
                time: '10:30',
                unreadCount: 2,
                avatar: 'AK',
                color: AppColors.primaryGreen,
              ),
              _buildChatTile(
                name: 'Jan Nowak',
                lastMessage: 'Dziękuję za informacje! Do zobaczenia w sobotę 👋',
                time: 'Wczoraj',
                unreadCount: 0,
                avatar: 'JN',
                color: AppColors.primaryBlue,
              ),
              _buildChatTile(
                name: 'Maria Wiśniewska',
                lastMessage: 'Czy mogę przyjść z kolegą?',
                time: '2 dni temu',
                unreadCount: 1,
                avatar: 'MW',
                color: AppColors.accentOrange,
              ),
              _buildChatTile(
                name: 'Piotr Lewandowski',
                lastMessage: 'Super, zapisałem się na wydarzenie!',
                time: '3 dni temu',
                unreadCount: 0,
                avatar: 'PL',
                color: AppColors.accentPurple,
              ),
              _buildChatTile(
                name: 'Katarzyna Dąbrowska',
                lastMessage: 'O której godzinie mam się stawić?',
                time: 'Tydzień temu',
                unreadCount: 0,
                avatar: 'KD',
                color: AppColors.primaryMagenta,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildChatTile({
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required String avatar,
    required Color color,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(
          avatar,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: unreadCount > 0 ? AppColors.primaryBlue : AppColors.textSecondary,
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unreadCount > 0 ? Colors.black87 : AppColors.textSecondary,
                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () => _showChatDialog(name, avatar, color),
    );
  }
  
  void _showChatDialog(String name, String avatar, Color color) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      avatar,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              
              // Messages
              Expanded(
                child: ListView(
                  children: [
                    _buildMessage(
                      'Dzień dobry! Interesuje mnie wydarzenie "Sprzątanie Parku"',
                      true,
                      '10:15',
                    ),
                    _buildMessage(
                      'Witam! Oczywiście, chętnie odpowiem na pytania.',
                      false,
                      '10:20',
                    ),
                    _buildMessage(
                      'Czy mogę przyjść z kolegą? Ma 16 lat.',
                      true,
                      '10:25',
                    ),
                    _buildMessage(
                      'Tak, zapraszamy! Wystarczy że się zarejestruje w aplikacji.',
                      false,
                      '10:30',
                    ),
                  ],
                ),
              ),
              
              // Input
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Wpisz wiadomość...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMessage(String text, bool isUser, String time) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Header
        Row(
          children: [
            const Expanded(
              child: Text(
                'Raporty i statystyki',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            ElevatedButton.icon(
              onPressed: () => _showGenerateReportDialog(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Nowy', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Statistics Overview
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBlue,
                AppColors.primaryBlue.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [AppColors.cardShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Podsumowanie miesiąca',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildStatItem('Wydarzenia', '8', Icons.event)),
                  Expanded(child: _buildStatItem('Wolontariusze', '42', Icons.people)),
                  Expanded(child: _buildStatItem('Godziny', '336', Icons.access_time)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Recent Reports
        const Text(
          'Ostatnie raporty',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        _buildReportCard(
          title: 'Raport miesięczny - Październik 2025',
          date: '01.10.2025 - 31.10.2025',
          type: 'Miesięczny',
          stats: {
            'Wydarzenia': '8',
            'Wolontariusze': '42',
            'Godziny wolontariatu': '336 h',
            'Średnia frekwencja': '89%',
          },
          color: AppColors.primaryGreen,
          icon: Icons.calendar_month,
        ),
        
        _buildReportCard(
          title: 'Raport miesięczny - Wrzesień 2025',
          date: '01.09.2025 - 30.09.2025',
          type: 'Miesięczny',
          stats: {
            'Wydarzenia': '12',
            'Wolontariusze': '56',
            'Godziny wolontariatu': '448 h',
            'Średnia frekwencja': '92%',
          },
          color: AppColors.primaryBlue,
          icon: Icons.calendar_month,
        ),
        
        _buildReportCard(
          title: 'Raport roczny 2024/2025',
          date: '01.09.2024 - 31.08.2025',
          type: 'Roczny',
          stats: {
            'Wydarzenia': '96',
            'Wolontariusze': '312',
            'Godziny wolontariatu': '3,840 h',
            'Średnia ocena': '4.7/5.0',
          },
          color: AppColors.accentPurple,
          icon: Icons.calendar_today,
        ),
        
        _buildReportCard(
          title: 'Raport wydarzenia - Sprzątanie Parku',
          date: '15.09.2025',
          type: 'Wydarzenie',
          stats: {
            'Zapisani': '28',
            'Obecni': '25',
            'Godziny': '100 h',
            'Frekwencja': '89%',
          },
          color: AppColors.accentOrange,
          icon: Icons.event,
        ),
      ],
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
  
  Widget _buildReportCard({
    required String title,
    required String date,
    required String type,
    required Map<String, String> stats,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Statistics
                ...stats.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )),
                const Divider(height: 24),
                
                // Actions
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showReportPreview(title),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Podgląd', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _downloadReport(title),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('PDF', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _shareReport(title),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Udostępnij', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.accentOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showGenerateReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generuj nowy raport'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_month, color: AppColors.primaryBlue),
              title: const Text('Raport miesięczny'),
              subtitle: const Text('Podsumowanie aktywności za miesiąc'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Generowanie raportu miesięcznego...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: AppColors.accentPurple),
              title: const Text('Raport roczny'),
              subtitle: const Text('Podsumowanie całego roku szkolnego'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Generowanie raportu rocznego...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: AppColors.accentOrange),
              title: const Text('Raport wydarzenia'),
              subtitle: const Text('Szczegóły konkretnego wydarzenia'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Wybierz wydarzenie do raportu...');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
        ],
      ),
    );
  }
  
  void _showReportPreview(String title) {
    _showSuccessSnackBar('Otwieranie podglądu: $title');
  }
  
  void _downloadReport(String title) {
    _showSuccessSnackBar('Pobieranie: $title');
  }
  
  void _shareReport(String title) {
    _showSuccessSnackBar('Udostępnianie: $title');
  }
  
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
