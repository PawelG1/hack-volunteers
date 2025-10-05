import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/mlody_krakow_footer.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../events/presentation/bloc/events_bloc.dart';
import '../../../events/presentation/pages/events_swipe_screen.dart';
import '../../../events/presentation/pages/interested_events_page.dart';
import '../../../events/presentation/pages/events_calendar_page.dart';
import '../../../events/domain/repositories/events_repository.dart';
import '../../../search/presentation/pages/search_events_page.dart';
import '../../../map/presentation/pages/events_map_page.dart';
import '../../../../injection_container.dart' as di;
import 'edit_profile_page.dart';
import 'my_certificates_page.dart';
import '../bloc/volunteer_certificates_bloc.dart';
import '../../domain/entities/volunteer_profile.dart';
import '../../data/services/profile_storage_service.dart';
import 'dart:io';

/// Volunteer Dashboard with bottom navigation
class VolunteerDashboard extends StatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  State<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends State<VolunteerDashboard> {
  int _selectedIndex = 0;
  final _profileStorage = ProfileStorageService();
  VolunteerProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileStorage.loadProfile();
    if (mounted) {
      setState(() {
        _profile = profile;
      });
    }
  }

  Future<int> _getInterestedEventsCount() async {
    try {
      final repository = di.sl<EventsRepository>();
      final result = await repository.getInterestedEvents();
      return result.fold(
        (failure) => 0,
        (events) => events.length,
      );
    } catch (e) {
      print('❌ Error getting interested events count: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryMagenta,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Odkrywaj',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Moje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Szukaj',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return BlocProvider(
          create: (context) => di.sl<EventsBloc>(),
          child: const EventsSwipeScreen(),
        );
      case 1:
        return _buildMyEventsTab();
      case 2:
        return _buildSearchTab();
      case 3:
        return _buildMapTab();
      case 4:
        return _buildProfileTab();
      default:
        return BlocProvider(
          create: (context) => di.sl<EventsBloc>(),
          child: const EventsSwipeScreen(),
        );
    }
  }

  Widget _buildMyEventsTab() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Moje wydarzenia'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: 'Lista',
              ),
              Tab(
                icon: Icon(Icons.calendar_month),
                text: 'Kalendarz',
              ),
            ],
            indicatorColor: AppColors.primaryMagenta,
            labelColor: AppColors.primaryMagenta,
          ),
        ),
        body: const TabBarView(
          children: [
            InterestedEventsPage(showAppBar: false),
            EventsCalendarPage(showAppBar: false),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTab() {
    return const SearchEventsPage();
  }

  Widget _buildMapTab() {
    return const EventsMapPage();
  }

  Widget _buildProfileTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [AppColors.cardShadow],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _profile?.profileImagePath != null
                            ? FileImage(File(_profile!.profileImagePath!))
                            : null,
                        child: _profile?.profileImagePath == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primaryMagenta,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryMagenta, width: 2),
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _profile?.name ?? 'Jan Kowalski',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _profile?.email ?? 'jan.kowalski@example.com',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                      
                      // Reload profile if changes were saved
                      if (result == true) {
                        _loadProfile();
                      }
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edytuj profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryMagenta,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    label: 'Godziny',
                    value: '0',
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FutureBuilder<int>(
                    future: _getInterestedEventsCount(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.toString() ?? '0';
                      return _buildStatCard(
                        icon: Icons.event_available,
                        label: 'Wydarzenia',
                        value: count,
                        color: AppColors.primaryGreen,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Achievements Section
            _buildSectionHeader('Osiągnięcia', Icons.emoji_events),
            const SizedBox(height: 12),
            Container(
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
                children: [
                  Row(
                    children: [
                      _buildAchievementBadge(
                        icon: Icons.star,
                        color: AppColors.accentOrange,
                        label: 'Nowicjusz',
                        isUnlocked: true,
                      ),
                      const SizedBox(width: 12),
                      _buildAchievementBadge(
                        icon: Icons.favorite,
                        color: Colors.red,
                        label: '10 wydarzeń',
                        isUnlocked: false,
                      ),
                      const SizedBox(width: 12),
                      _buildAchievementBadge(
                        icon: Icons.workspace_premium,
                        color: AppColors.primaryBlue,
                        label: 'Ekspert',
                        isUnlocked: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Zdobądź więcej odznak uczestnicząc w wydarzeniach!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Options
            _buildSectionHeader('Informacje', Icons.info_outline),
            const SizedBox(height: 12),
            _buildProfileOption(
              icon: Icons.school_outlined,
              title: 'Szkoła',
              subtitle: _profile?.school ?? 'Nie ustawiono',
              onTap: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
                if (result == true) _loadProfile();
              },
            ),
            _buildProfileOption(
              icon: Icons.star_outline,
              title: 'Ocena',
              subtitle: 'Brak ocen',
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.workspace_premium,
              title: 'Moje Certyfikaty',
              subtitle: 'Zobacz swoje osiągnięcia',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => di.sl<VolunteerCertificatesBloc>(),
                      child: MyCertificatesPage(
                        volunteerId: 'current-volunteer-id', // TODO: Get from auth
                      ),
                    ),
                  ),
                );
              },
            ),
            _buildProfileOption(
              icon: Icons.interests_outlined,
              title: 'Zainteresowania',
              subtitle: _profile?.interests.isNotEmpty == true
                  ? _profile!.interests.join(', ')
                  : 'Dodaj swoje zainteresowania',
              onTap: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
                if (result == true) _loadProfile();
              },
            ),
            
            const SizedBox(height: 16),
            
            // Logout button
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Wyloguj się',
              subtitle: 'Zakończ sesję',
              onTap: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Wyloguj się'),
                      content: const Text('Czy na pewno chcesz się wylogować?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Anuluj'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            context.read<AuthBloc>().add(LogoutEvent());
                            context.go('/login');
                          },
                          child: const Text('Wyloguj'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Sponsor Section
            // Footer z informacją o wsparciu
            const MlodyKrakowFooter(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            ),
          ],
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
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryMagenta),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.primaryMagenta),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required Color color,
    required String label,
    required bool isUnlocked,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnlocked ? color : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isUnlocked ? Colors.white : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade400,
              fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
