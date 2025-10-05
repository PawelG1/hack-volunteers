import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/mlody_krakow_footer.dart';
import '../bloc/coordinator_bloc.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../../../organizations/domain/entities/certificate.dart';

/// Mock data classes for fallback
class _MockApplication {
  final String id;
  final String volunteerId;
  final String eventId;
  final int hoursWorked;

  _MockApplication({
    required this.id,
    required this.volunteerId,
    required this.eventId,
    required this.hoursWorked,
  });
}

class _MockCertificate {
  final String id;
  final String volunteerName;
  final String eventTitle;
  final int hoursWorked;
  final DateTime issuedDate;
  final String status;
  final String? certificateNumber;

  _MockCertificate({
    required this.id,
    required this.volunteerName,
    required this.eventTitle,
    required this.hoursWorked,
    required this.issuedDate,
    this.status = 'issued',
    this.certificateNumber,
  });
}

/// Coordinator Dashboard with bottom navigation
class CoordinatorDashboard extends StatefulWidget {
  const CoordinatorDashboard({super.key});

  @override
  State<CoordinatorDashboard> createState() => _CoordinatorDashboardState();
}

class _CoordinatorDashboardState extends State<CoordinatorDashboard> {
  int _selectedIndex = 0;
  final String _coordinatorId = 'sample-coordinator-id';

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<CoordinatorBloc>().add(LoadPendingApprovals(coordinatorId: _coordinatorId));
    context.read<CoordinatorBloc>().add(LoadIssuedCertificates(coordinatorId: _coordinatorId));
    context.read<CoordinatorBloc>().add(LoadCoordinatorStatistics(coordinatorId: _coordinatorId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koordynator Szkolny'),
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
                value: 'school',
                child: Row(
                  children: [
                    Icon(Icons.school_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Moja szkoła'),
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
        selectedItemColor: AppColors.primaryGreen,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Uczniowie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_outlined),
            activeIcon: Icon(Icons.card_membership),
            label: 'Certyfikaty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Kalendarz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
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
        return _buildStudentsTab();
      case 2:
        return _buildCertificatesTab();
      case 3:
        return _buildCalendarTab();
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreen.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [AppColors.cardShadow],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dzień dobry! 📚',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Szkoła: Liceum Ogólnokształcące Nr 1',
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
            'Podsumowanie',
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
                icon: Icons.people,
                label: 'Aktywni uczniowie',
                value: '28',
                color: AppColors.primaryGreen,
              ),
              _buildStatCard(
                icon: Icons.pending_actions,
                label: 'Do zatwierdzenia',
                value: '5',
                color: AppColors.accentOrange,
              ),
              _buildStatCard(
                icon: Icons.card_membership,
                label: 'Certyfikaty',
                value: '12',
                color: AppColors.accentPurple,
              ),
              _buildStatCard(
                icon: Icons.access_time,
                label: 'Godziny łącznie',
                value: '420',
                color: AppColors.primaryBlue,
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
            icon: Icons.check_circle_outline,
            label: 'Zatwierdź certyfikaty',
            color: AppColors.primaryGreen,
            badge: '5',
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.people_outline,
            label: 'Zarządzaj uczniami',
            color: AppColors.primaryBlue,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.assessment_outlined,
            label: 'Wygeneruj raport',
            color: AppColors.accentPurple,
            onTap: () {
              setState(() {
                _selectedIndex = 4;
              });
            },
          ),
          const SizedBox(height: 32),
          
          // Footer z informacją o wsparciu
          const MlodyKrakowFooter(),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Lista uczniów',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStudentCard('Anna Kowalska', '3A', 42, 3),
        _buildStudentCard('Jan Nowak', '3A', 28, 2),
        _buildStudentCard('Maria Wiśniewska', '3B', 35, 2),
        _buildStudentCard('Piotr Lewandowski', '3B', 21, 1),
        _buildStudentCard('Katarzyna Dąbrowska', '3A', 14, 1),
      ],
    );
  }
  
  Widget _buildStudentCard(String name, String className, int hours, int certificates) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryGreen,
          child: Text(
            name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(name),
        subtitle: Text('Klasa: $className • $hours godz. • $certificates cert.'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to student details
        },
      ),
    );
  }

  Widget _buildCertificatesTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.primaryGreen,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryGreen,
              tabs: [
                Tab(text: 'Do zatwierdzenia'),
                Tab(text: 'Wydane certyfikaty'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPendingApprovalsTab(),
                _buildIssuedCertificatesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalsTab() {
    return BlocBuilder<CoordinatorBloc, CoordinatorState>(
      builder: (context, state) {
        if (state is CoordinatorLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Mock data jako fallback
        final mockPendingApplications = [
          _MockApplication(
            id: 'app-001',
            volunteerId: 'Anna Kowalska',
            eventId: 'Sprzątanie Parku Jordana',
            hoursWorked: 4,
          ),
          _MockApplication(
            id: 'app-002',
            volunteerId: 'Jan Nowak',
            eventId: 'Warsztaty Ekologiczne',
            hoursWorked: 3,
          ),
          _MockApplication(
            id: 'app-003',
            volunteerId: 'Maria Wiśniewska',
            eventId: 'Pomoc w Schronisku',
            hoursWorked: 5,
          ),
        ];
        
        if (state is PendingApprovalsLoaded && state.applications.isNotEmpty) {
          final pending = state.applications;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final application = pending[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.accentOrange,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text('Wolontariusz: ${application.volunteerId}'),
                  subtitle: Text('Wydarzenie: ${application.eventId}\n${application.hoursWorked ?? 0} godzin'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: AppColors.primaryGreen),
                        onPressed: () => _approveCertificate(application.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: AppColors.primaryBlue),
                        onPressed: () => _showApplicationDetails(application),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        
        // Show mock data
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockPendingApplications.length,
          itemBuilder: (context, index) {
            final app = mockPendingApplications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accentOrange,
                  child: Text(
                    app.volunteerId[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(app.volunteerId),
                subtitle: Text('${app.eventId}\n${app.hoursWorked} godzin • Oczekuje na zatwierdzenie'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: AppColors.primaryGreen),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Zatwierdzono: ${app.volunteerId}'),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      },
                      tooltip: 'Zatwierdź',
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: AppColors.primaryBlue),
                      onPressed: () => _showMockApplicationDetails(app),
                      tooltip: 'Szczegóły',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIssuedCertificatesTab() {
    return BlocBuilder<CoordinatorBloc, CoordinatorState>(
      builder: (context, state) {
        if (state is CoordinatorLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Mock certificates jako fallback
        final mockCertificates = [
          _MockCertificate(
            id: 'cert-001',
            volunteerName: 'Anna Kowalska',
            eventTitle: 'Sprzątanie Parku Jordana',
            hoursWorked: 4,
            issuedDate: DateTime.now().subtract(const Duration(days: 5)),
            status: 'issued',
            certificateNumber: 'CERT/2025/001',
          ),
          _MockCertificate(
            id: 'cert-002',
            volunteerName: 'Jan Nowak',
            eventTitle: 'Warsztaty Ekologiczne',
            hoursWorked: 3,
            issuedDate: DateTime.now().subtract(const Duration(days: 12)),
            status: 'issued',
            certificateNumber: 'CERT/2025/002',
          ),
          _MockCertificate(
            id: 'cert-003',
            volunteerName: 'Maria Wiśniewska',
            eventTitle: 'Pomoc w Schronisku dla Zwierząt',
            hoursWorked: 5,
            issuedDate: DateTime.now().subtract(const Duration(days: 18)),
            status: 'issued',
            certificateNumber: 'CERT/2025/003',
          ),
          _MockCertificate(
            id: 'cert-004',
            volunteerName: 'Piotr Lewandowski',
            eventTitle: 'Zbiórka Żywności',
            hoursWorked: 6,
            issuedDate: DateTime.now().subtract(const Duration(days: 25)),
            status: 'issued',
            certificateNumber: 'CERT/2025/004',
          ),
          _MockCertificate(
            id: 'cert-005',
            volunteerName: 'Katarzyna Dąbrowska',
            eventTitle: 'Malowanie Przedszkola',
            hoursWorked: 8,
            issuedDate: DateTime.now().subtract(const Duration(days: 32)),
            status: 'issued',
            certificateNumber: 'CERT/2025/005',
          ),
        ];
        
        if (state is IssuedCertificatesLoaded && state.certificates.isNotEmpty) {
          final certificates = state.certificates;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: certificates.length,
            itemBuilder: (context, index) {
              final certificate = certificates[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: certificate.status == CertificateStatus.issued 
                        ? AppColors.primaryGreen 
                        : AppColors.accentOrange,
                    child: const Icon(Icons.card_membership, color: Colors.white),
                  ),
                  title: Text(certificate.volunteerName),
                  subtitle: Text(
                    '${certificate.eventTitle}\n'
                    '${certificate.hoursWorked} godz. • ${_formatDate(certificate.issuedAt ?? certificate.createdAt)}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (certificate.status == CertificateStatus.issued)
                        IconButton(
                          icon: const Icon(Icons.download, color: AppColors.primaryBlue),
                          onPressed: () => _downloadCertificate(certificate),
                          tooltip: 'Pobierz PDF',
                        ),
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, color: AppColors.primaryBlue),
                        onPressed: () => _showCertificateDetails(certificate),
                        tooltip: 'Szczegóły',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        
        // Show mock data
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockCertificates.length,
          itemBuilder: (context, index) {
            final cert = mockCertificates[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryGreen,
                  child: Text(
                    cert.volunteerName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                title: Text(
                  cert.volunteerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${cert.eventTitle}\n'
                  '${cert.hoursWorked} godz. • ${_formatDate(cert.issuedDate)}',
                  style: const TextStyle(fontSize: 13),
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download, color: AppColors.primaryBlue, size: 22),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pobieranie: ${cert.certificateNumber}'),
                            backgroundColor: AppColors.primaryBlue,
                            action: SnackBarAction(
                              label: 'OK',
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                      tooltip: 'Pobierz PDF',
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, color: AppColors.primaryBlue, size: 22),
                      onPressed: () => _showMockCertificateDetails(cert),
                      tooltip: 'Szczegóły',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  void _approveCertificate(String applicationId) {
    context.read<CoordinatorBloc>().add(
      GenerateVolunteerCertificate(
        applicationId: applicationId,
        coordinatorId: _coordinatorId,
        coordinatorName: 'Jan Kowalski', // TODO: Get from auth
      ),
    );
  }
  
  void _showApplicationDetails(VolunteerApplication application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Szczegóły zgłoszenia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wolontariusz: ${application.volunteerId}'),
            const SizedBox(height: 8),
            Text('Wydarzenie: ${application.eventId}'),
            const SizedBox(height: 8),
            Text('Godzin przepracowanych: ${application.hoursWorked ?? 0}'),
            const SizedBox(height: 8),
            Text('Status: ${_getStatusText(application.status)}'),
          ],
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
  
  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Oczekujące';
      case ApplicationStatus.accepted:
        return 'Zaakceptowane';
      case ApplicationStatus.attended:
        return 'Obecny - do zatwierdzenia';
      case ApplicationStatus.notAttended:
        return 'Nieobecny';
      case ApplicationStatus.approved:
        return 'Zatwierdzone';
      case ApplicationStatus.completed:
        return 'Zakończone';
      case ApplicationStatus.rejected:
        return 'Odrzucone';
      case ApplicationStatus.cancelled:
        return 'Anulowane';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Dzisiaj';
    } else if (difference.inDays == 1) {
      return 'Wczoraj';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dni temu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'tydzień' : 'tygodni'} temu';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }

  void _downloadCertificate(Certificate certificate) {
    // TODO: Implement PDF download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pobieranie certyfikatu: ${certificate.volunteerName}'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showCertificateDetails(Certificate certificate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Szczegóły certyfikatu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Wolontariusz', certificate.volunteerName),
              const Divider(height: 16),
              _buildDetailRow('Organizacja', certificate.organizationName),
              const Divider(height: 16),
              _buildDetailRow('Wydarzenie', certificate.eventTitle),
              const Divider(height: 16),
              _buildDetailRow('Data wydarzenia', DateFormat('dd.MM.yyyy').format(certificate.eventDate)),
              const Divider(height: 16),
              _buildDetailRow('Godziny', '${certificate.hoursWorked} godz.'),
              const Divider(height: 16),
              _buildDetailRow('Status', certificate.status == CertificateStatus.issued ? 'Wydany' : 'Oczekujący'),
              if (certificate.issuedAt != null) ...[
                const Divider(height: 16),
                _buildDetailRow('Data wydania', DateFormat('dd.MM.yyyy HH:mm').format(certificate.issuedAt!)),
              ],
              if (certificate.approvedBy != null) ...[
                const Divider(height: 16),
                _buildDetailRow('Zatwierdził', certificate.approvedBy!),
              ],
              if (certificate.certificateNumber != null) ...[
                const Divider(height: 16),
                _buildDetailRow('Numer certyfikatu', certificate.certificateNumber!),
              ],
              if (certificate.description != null) ...[
                const Divider(height: 16),
                _buildDetailRow('Opis', certificate.description!),
              ],
              if (certificate.skills != null) ...[
                const Divider(height: 16),
                _buildDetailRow('Nabyte umiejętności', certificate.skills!),
              ],
            ],
          ),
        ),
        actions: [
          if (certificate.status == CertificateStatus.issued && certificate.pdfUrl != null)
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _downloadCertificate(certificate);
              },
              icon: const Icon(Icons.download),
              label: const Text('Pobierz PDF'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Nadchodzące wydarzenia',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          'Sprzątanie Parku',
          DateTime.now().add(const Duration(days: 3)),
          5,
          AppColors.primaryGreen,
        ),
        _buildEventCard(
          'Warsztaty Ekologiczne',
          DateTime.now().add(const Duration(days: 7)),
          3,
          AppColors.primaryBlue,
        ),
        _buildEventCard(
          'Pomoc w schronisku',
          DateTime.now().add(const Duration(days: 14)),
          8,
          AppColors.accentOrange,
        ),
      ],
    );
  }
  
  Widget _buildEventCard(String title, DateTime date, int volunteers, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            '${date.day}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(title),
        subtitle: Text(
          '${date.day}.${date.month}.${date.year} • $volunteers wolontariuszy',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Show event details
        },
      ),
    );
  }

  Widget _buildReportsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Raporty szkolne',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildReportCard(
          'Raport miesięczny - Październik 2025',
          'Wygenerowano: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
          Icons.description,
          AppColors.primaryBlue,
        ),
        _buildReportCard(
          'Raport miesięczny - Wrzesień 2025',
          '28 uczniów • 420 godzin',
          Icons.description,
          AppColors.primaryGreen,
        ),
        _buildReportCard(
          'Raport roczny 2024/2025',
          'Łącznie: 156 uczniów',
          Icons.insert_chart,
          AppColors.accentPurple,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Generate new report
          },
          icon: const Icon(Icons.add),
          label: const Text('Wygeneruj nowy raport'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
  
  Widget _buildReportCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            // TODO: Download report
          },
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
    String? badge,
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
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                if (badge != null)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
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

  void _showMockApplicationDetails(_MockApplication app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Szczegóły zgłoszenia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Wolontariusz', app.volunteerId),
            const Divider(height: 16),
            _buildDetailRow('Wydarzenie', app.eventId),
            const Divider(height: 16),
            _buildDetailRow('Godziny', '${app.hoursWorked} godz.'),
            const Divider(height: 16),
            _buildDetailRow('Status', 'Oczekuje na zatwierdzenie'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Zatwierdzono: ${app.volunteerId}'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            icon: const Icon(Icons.check_circle, color: AppColors.primaryGreen),
            label: const Text('Zatwierdź', style: TextStyle(color: AppColors.primaryGreen)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }

  void _showMockCertificateDetails(_MockCertificate cert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Szczegóły certyfikatu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Wolontariusz', cert.volunteerName),
              const Divider(height: 16),
              _buildDetailRow('Wydarzenie', cert.eventTitle),
              const Divider(height: 16),
              _buildDetailRow('Godziny', '${cert.hoursWorked} godz.'),
              const Divider(height: 16),
              _buildDetailRow('Data wydania', DateFormat('dd.MM.yyyy').format(cert.issuedDate)),
              const Divider(height: 16),
              _buildDetailRow('Status', 'Wydany'),
              if (cert.certificateNumber != null) ...[
                const Divider(height: 16),
                _buildDetailRow('Numer certyfikatu', cert.certificateNumber!),
              ],
              const Divider(height: 16),
              _buildDetailRow('Organizacja', 'SmokPomaga'),
              const Divider(height: 16),
              _buildDetailRow('Zatwierdził', 'Koordynator Jan Kowalski'),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pobieranie: ${cert.certificateNumber}'),
                  backgroundColor: AppColors.primaryBlue,
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Pobierz PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }
}
