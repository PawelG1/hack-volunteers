import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../bloc/organization_bloc.dart';
import 'add_event_page.dart';

/// Manage Events Page - for creating and editing events
class ManageEventsPage extends StatefulWidget {
  const ManageEventsPage({super.key});

  @override
  State<ManageEventsPage> createState() => _ManageEventsPageState();
}

class _ManageEventsPageState extends State<ManageEventsPage> {
  @override
  void initState() {
    super.initState();
    // Load events when page opens
    Future.microtask(() {
      print('🔵 ManageEventsPage: Loading events on init');
      context.read<OrganizationBloc>().add(
        const LoadOrganizationEvents(organizationId: 'sample-org'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: BlocConsumer<OrganizationBloc, OrganizationState>(
        listener: (context, state) {
          if (state is OrganizationEventCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event created successfully')),
            );
            // Don't reload here - BLoC already reloads automatically
          } else if (state is OrganizationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          print('🔵 ManageEventsPage: Building with state ${state.runtimeType}');
          
          if (state is OrganizationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrganizationEventsLoaded) {
            print('🔵 ManageEventsPage: Loaded ${state.events.length} events');
            if (state.events.isEmpty) {
              return _buildEmptyState();
            }
            return _buildEventsList(state.events);
          }

          // For all other states, show empty state
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_note,
            size: 80,
            color: Color(0xFF757575),
          ),
          const SizedBox(height: 16),
          const Text(
            'Brak wydarzeń',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dodaj pierwsze wydarzenie, aby zacząć zarządzać wolontariatem',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF757575)),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<VolunteerEvent> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(event.status),
              child: Icon(_getStatusIcon(event.status), color: Colors.white),
            ),
            title: Text(event.title),
            subtitle: Text('${event.location} • ${event.date}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${event.currentVolunteers}/${event.requiredVolunteers}'),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showEventDetails(context, event),
          ),
        );
      },
    );
  }

  IconData _getStatusIcon(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return Icons.edit;
      case EventStatus.published:
        return Icons.public;
      case EventStatus.inProgress:
        return Icons.play_arrow;
      case EventStatus.cancelled:
        return Icons.cancel;
      case EventStatus.completed:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return Colors.orange;
      case EventStatus.published:
        return AppColors.primaryGreen;
      case EventStatus.inProgress:
        return Colors.blue;
      case EventStatus.cancelled:
        return AppColors.error;
      case EventStatus.completed:
        return Colors.green;
    }
  }

  void _showAddEventDialog(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<OrganizationBloc>(),
          child: const AddEventPage(),
        ),
      ),
    );
    
    if (result == true && context.mounted) {
      // Reload events after successful creation
      context.read<OrganizationBloc>().add(
        const LoadOrganizationEvents(organizationId: 'sample-org')
      );
    }
  }

  void _showEventDetails(BuildContext context, event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Organizacja: ${event.organization}'),
            const SizedBox(height: 8),
            Text('Lokalizacja: ${event.location}'),
            const SizedBox(height: 8),
            Text('Data: ${event.date.day}/${event.date.month}/${event.date.year}'),
            const SizedBox(height: 8),
            Text('Opis: ${event.description}'),
            const SizedBox(height: 8),
            Text('Wolontariusze: ${event.currentVolunteers}/${event.requiredVolunteers}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zamknij'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement edit functionality
            },
            child: const Text('Edytuj'),
          ),
        ],
      ),
    );
  }
}