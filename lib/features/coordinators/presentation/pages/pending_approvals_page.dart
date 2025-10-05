import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../bloc/coordinator_bloc.dart';

class PendingApprovalsPage extends StatefulWidget {
  const PendingApprovalsPage({Key? key}) : super(key: key);

  @override
  State<PendingApprovalsPage> createState() => _PendingApprovalsPageState();
}

class _PendingApprovalsPageState extends State<PendingApprovalsPage> {
  @override
  void initState() {
    super.initState();
    _loadPendingApprovals();
  }

  void _loadPendingApprovals() {
    // TODO: Get coordinatorId from authentication/context
    const coordinatorId = 'current-coordinator-id';
    context.read<CoordinatorBloc>().add(
      const LoadPendingApprovals(coordinatorId: coordinatorId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oczekujące zgłoszenia'),
        backgroundColor: AppColors.primaryMagenta,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingApprovals,
          ),
        ],
      ),
      body: BlocConsumer<CoordinatorBloc, CoordinatorState>(
        listener: (context, state) {
          if (state is ParticipationApproved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Udział zatwierdzony'),
                backgroundColor: Colors.green,
              ),
            );
            _loadPendingApprovals();
          } else if (state is CoordinatorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CoordinatorLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PendingApprovalsLoaded) {
            final applications = state.applications;

            if (applications.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadPendingApprovals();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return ApprovalCard(
                    application: applications[index],
                    onApprove: (notes) => _approveApplication(
                      applications[index].id,
                      notes,
                    ),
                  );
                },
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Brak oczekujących zgłoszeń',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wszystkie zgłoszenia zostały przetworzone',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _approveApplication(String applicationId, String? notes) {
    // TODO: Get coordinatorId from authentication/context
    const coordinatorId = 'current-coordinator-id';
    context.read<CoordinatorBloc>().add(
          ApproveVolunteerParticipation(
            applicationId: applicationId,
            coordinatorId: coordinatorId,
            notes: notes,
          ),
        );
  }
}

class ApprovalCard extends StatefulWidget {
  final VolunteerApplication application;
  final Function(String? notes) onApprove;

  const ApprovalCard({
    Key? key,
    required this.application,
    required this.onApprove,
  }) : super(key: key);

  @override
  State<ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<ApprovalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              'Wolontariusz: ${widget.application.volunteerId}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Wydarzenie: ${widget.application.eventId}'),
                const SizedBox(height: 4),
                Text(
                  'Godziny: ${widget.application.hoursWorked ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (widget.application.rating != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('Ocena: '),
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < widget.application.rating!
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                      Text(' (${widget.application.rating!.toStringAsFixed(1)})'),
                    ],
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() => _isExpanded = !_isExpanded);
              },
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.application.feedback != null &&
                      widget.application.feedback!.isNotEmpty) ...[
                    const Text(
                      'Opinia organizacji:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.application.feedback!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Data zgłoszenia: ${_formatDate(widget.application.appliedAt)}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.application.attendanceMarkedAt != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Obecność: ${_formatDate(widget.application.attendanceMarkedAt!)}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showApprovalDialog(context),
                          icon: const Icon(Icons.check),
                          label: const Text('Zatwierdź'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _navigateToGenerateCertificate(),
                          icon: const Icon(Icons.workspace_premium),
                          label: const Text('Certyfikat'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryBlue,
                            side: BorderSide(color: AppColors.primaryBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showApprovalDialog(BuildContext context) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Zatwierdź udział'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Czy na pewno chcesz zatwierdzić udział wolontariusza?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notatki koordynatora (opcjonalnie)',
                hintText: 'Dodaj uwagi...',
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
              widget.onApprove(
                notesController.text.isEmpty ? null : notesController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Zatwierdź'),
          ),
        ],
      ),
    );
  }

  void _navigateToGenerateCertificate() {
    Navigator.pushNamed(
      context,
      '/generate-certificate',
      arguments: widget.application,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
