import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../organizations/domain/entities/volunteer_application.dart';
import '../bloc/coordinator_bloc.dart';

class GenerateCertificatePage extends StatefulWidget {
  final VolunteerApplication application;

  const GenerateCertificatePage({
    Key? key,
    required this.application,
  }) : super(key: key);

  @override
  State<GenerateCertificatePage> createState() =>
      _GenerateCertificatePageState();
}

class _GenerateCertificatePageState extends State<GenerateCertificatePage> {
  final _formKey = GlobalKey<FormState>();
  final _coordinatorNameController = TextEditingController();

  @override
  void dispose() {
    _coordinatorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wygeneruj certyfikat'),
        backgroundColor: AppColors.primaryMagenta,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CoordinatorBloc, CoordinatorState>(
        listener: (context, state) {
          if (state is CertificateGenerated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Certyfikat wygenerowany'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is CoordinatorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Certificate preview card
                Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryBlue.withOpacity(0.1),
                          AppColors.primaryMagenta.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          size: 60,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'CERTYFIKAT WOLONTARIUSZA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildCertificateField(
                          'Wolontariusz',
                          widget.application.volunteerId,
                        ),
                        const SizedBox(height: 12),
                        _buildCertificateField(
                          'Wydarzenie',
                          widget.application.eventId,
                        ),
                        const SizedBox(height: 12),
                        _buildCertificateField(
                          'Przepracowane godziny',
                          '${widget.application.hoursWorked ?? 0} godzin',
                        ),
                        const SizedBox(height: 12),
                        if (widget.application.rating != null)
                          _buildCertificateField(
                            'Ocena',
                            '${widget.application.rating!.toStringAsFixed(1)}/5.0',
                          ),
                        const SizedBox(height: 12),
                        _buildCertificateField(
                          'Data ukończenia',
                          _formatDate(widget.application.completedAt ?? DateTime.now()),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          'Potwierdzam uczestnictwo w wolontariacie',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Application details
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Szczegóły zgłoszenia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Data zgłoszenia',
                          _formatDate(widget.application.appliedAt),
                        ),
                        const SizedBox(height: 8),
                        if (widget.application.attendanceMarkedAt != null) ...[
                          _buildDetailRow(
                            Icons.check_circle,
                            'Obecność oznaczona',
                            _formatDate(widget.application.attendanceMarkedAt!),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (widget.application.approvedAt != null) ...[
                          _buildDetailRow(
                            Icons.verified,
                            'Zatwierdzone',
                            _formatDate(widget.application.approvedAt!),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (widget.application.feedback != null &&
                            widget.application.feedback!.isNotEmpty) ...[
                          const Divider(height: 24),
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
                        ],
                        if (widget.application.coordinatorNotes != null &&
                            widget.application.coordinatorNotes!.isNotEmpty) ...[
                          const Divider(height: 24),
                          const Text(
                            'Notatki koordynatora:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.application.coordinatorNotes!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Coordinator name input
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dane koordynatora',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _coordinatorNameController,
                          decoration: const InputDecoration(
                            labelText: 'Imię i nazwisko koordynatora',
                            hintText: 'np. Jan Kowalski',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj imię i nazwisko';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Dane koordynatora zostaną umieszczone na certyfikacie',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Generate button
                BlocBuilder<CoordinatorBloc, CoordinatorState>(
                  builder: (context, state) {
                    final isLoading = state is CoordinatorLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _generateCertificate,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.workspace_premium),
                        label: Text(
                          isLoading
                              ? 'Generowanie...'
                              : 'Wygeneruj certyfikat',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Info text
                Center(
                  child: Text(
                    'Certyfikat zostanie zapisany i będzie dostępny do pobrania',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateField(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void _generateCertificate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: Get coordinatorId from authentication/context
    const coordinatorId = 'current-coordinator-id';

    context.read<CoordinatorBloc>().add(
          GenerateVolunteerCertificate(
            applicationId: widget.application.id,
            coordinatorId: coordinatorId,
            coordinatorName: _coordinatorNameController.text,
          ),
        );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
