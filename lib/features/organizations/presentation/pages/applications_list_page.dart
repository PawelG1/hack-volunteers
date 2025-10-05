import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/volunteer_application.dart';
import '../bloc/organization_bloc.dart';

class ApplicationsListPage extends StatefulWidget {
  final String organizationId;
  final String? eventId;

  const ApplicationsListPage({
    Key? key,
    required this.organizationId,
    this.eventId,
  }) : super(key: key);

  @override
  State<ApplicationsListPage> createState() => _ApplicationsListPageState();
}

class _ApplicationsListPageState extends State<ApplicationsListPage> {
  @override
  void initState() {
    super.initState();
    print('🚀 APPLICATIONS_PAGE: initState called');
    print('   organizationId: ${widget.organizationId}');
    print('   eventId: ${widget.eventId}');
    _loadApplications();
  }

  void _loadApplications() {
    print('🔄 APPLICATIONS_PAGE: Loading applications...');
    if (widget.eventId != null) {
      print('   Loading for specific event: ${widget.eventId}');
      context.read<OrganizationBloc>().add(
            LoadEventApplications(eventId: widget.eventId!),
          );
    } else {
      print('   Loading for organization: ${widget.organizationId}');
      context.read<OrganizationBloc>().add(
            LoadOrganizationApplications(organizationId: widget.organizationId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventId != null ? 'Zgłoszenia na wydarzenie' : 'Wszystkie zgłoszenia',
        ),
        backgroundColor: AppColors.primaryMagenta,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<OrganizationBloc, OrganizationState>(
        listener: (context, state) {
          if (state is OrganizationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ApplicationAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Zgłoszenie zaakceptowane'),
                backgroundColor: Colors.green,
              ),
            );
            _loadApplications();
          } else if (state is ApplicationRejected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Zgłoszenie odrzucone'),
                backgroundColor: Colors.orange,
              ),
            );
            _loadApplications();
          }
        },
        builder: (context, state) {
          if (state is ApplicationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApplicationsLoaded) {
            if (state.applications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Brak zgłoszeń',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadApplications(),
              child: ListView.builder(
                itemCount: state.applications.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final application = state.applications[index];
                  return ApplicationCard(
                    application: application,
                    onAccept: () => _acceptApplication(application.id),
                    onReject: () => _rejectApplication(application.id),
                    onMarkAttendance: () => _navigateToAttendance(application),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Załaduj zgłoszenia'));
        },
      ),
    );
  }

  void _acceptApplication(String applicationId) {
    print('✅ PAGE: _acceptApplication called for $applicationId');
    
    // WAŻNE: Pobierz BLoC PRZED otwarciem dialogu!
    final bloc = context.read<OrganizationBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Zaakceptować zgłoszenie?'),
        content: const Text('Wolontariusz zostanie poinformowany o akceptacji.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              print('✅ DIALOG: Confirm button pressed for $applicationId');
              Navigator.pop(dialogContext);
              print('✅ DIALOG: Sending AcceptVolunteerApplication event');
              bloc.add(AcceptVolunteerApplication(applicationId: applicationId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Zaakceptuj'),
          ),
        ],
      ),
    );
  }

  void _rejectApplication(String applicationId) {
    final reasonController = TextEditingController();
    
    // WAŻNE: Pobierz BLoC PRZED otwarciem dialogu!
    final bloc = context.read<OrganizationBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Odrzucić zgłoszenie?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Podaj powód odrzucenia (opcjonalnie):'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Powód odrzucenia...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(
                    RejectVolunteerApplication(
                      applicationId: applicationId,
                      reason: reasonController.text.isEmpty
                          ? null
                          : reasonController.text,
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Odrzuć'),
          ),
        ],
      ),
    );
  }

  void _navigateToAttendance(VolunteerApplication application) {
    Navigator.pushNamed(
      context,
      '/mark-attendance',
      arguments: application,
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final VolunteerApplication application;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMarkAttendance;

  const ApplicationCard({
    Key? key,
    required this.application,
    required this.onAccept,
    required this.onReject,
    required this.onMarkAttendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Wolontariusz ${application.volunteerId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(application.status),
              ],
            ),
            const SizedBox(height: 12),

            // Application info
            _buildInfoRow(
              Icons.event,
              'Wydarzenie: ${application.eventId}',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.calendar_today,
              'Zgłoszono: ${_formatDate(application.appliedAt)}',
            ),

            if (application.message != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  application.message!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],

            if (application.hoursWorked != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.access_time,
                'Przepracowane godziny: ${application.hoursWorked}h',
              ),
            ],

            if (application.rating != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.star,
                'Ocena: ${application.rating}/5.0',
              ),
            ],

            const SizedBox(height: 16),

            // Actions
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ApplicationStatus status) {
    Color color;
    String label;

    switch (status) {
      case ApplicationStatus.pending:
        color = Colors.orange;
        label = 'Oczekujące';
        break;
      case ApplicationStatus.accepted:
        color = Colors.green;
        label = 'Zaakceptowane';
        break;
      case ApplicationStatus.rejected:
        color = Colors.red;
        label = 'Odrzucone';
        break;
      case ApplicationStatus.attended:
        color = Colors.blue;
        label = 'Obecny';
        break;
      case ApplicationStatus.notAttended:
        color = Colors.grey;
        label = 'Nieobecny';
        break;
      case ApplicationStatus.approved:
        color = Colors.purple;
        label = 'Zatwierdzone';
        break;
      case ApplicationStatus.completed:
        color = Colors.teal;
        label = 'Ukończone';
        break;
      case ApplicationStatus.cancelled:
        color = Colors.black;
        label = 'Anulowane';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    if (application.status == ApplicationStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                print('🔴 CARD: Reject button pressed for ${application.id}');
                onReject();
              },
              icon: const Icon(Icons.close),
              label: const Text('Odrzuć'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                print('🟢 CARD: Accept button pressed for ${application.id}');
                onAccept();
              },
              icon: const Icon(Icons.check),
              label: const Text('Zaakceptuj'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else if (application.status == ApplicationStatus.accepted) {
      return ElevatedButton.icon(
        onPressed: () {
          print('📋 CARD: Mark attendance button pressed for ${application.id}');
          onMarkAttendance();
        },
        icon: const Icon(Icons.fact_check),
        label: const Text('Oznacz obecność'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 40),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
