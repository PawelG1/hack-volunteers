import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/volunteer_application.dart';
import '../bloc/organization_bloc.dart';

class AttendanceMarkingPage extends StatefulWidget {
  final VolunteerApplication application;

  const AttendanceMarkingPage({
    Key? key,
    required this.application,
  }) : super(key: key);

  @override
  State<AttendanceMarkingPage> createState() => _AttendanceMarkingPageState();
}

class _AttendanceMarkingPageState extends State<AttendanceMarkingPage> {
  final _formKey = GlobalKey<FormState>();
  final _hoursController = TextEditingController();
  final _feedbackController = TextEditingController();
  double _rating = 3.0;
  bool _isAttended = true;

  @override
  void dispose() {
    _hoursController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oznacz obecność'),
        backgroundColor: AppColors.primaryMagenta,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<OrganizationBloc, OrganizationState>(
        listener: (context, state) {
          if (state is AttendanceMarked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Obecność oznaczona'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is OrganizationError) {
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
                // Application info card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informacje o zgłoszeniu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.person,
                          'Wolontariusz: ${widget.application.volunteerId}',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.event,
                          'Wydarzenie: ${widget.application.eventId}',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Data zgłoszenia: ${_formatDate(widget.application.appliedAt)}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Attendance toggle
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Obecność',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAttendanceOption(
                                'Obecny',
                                Icons.check_circle,
                                Colors.green,
                                _isAttended,
                                () => setState(() => _isAttended = true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildAttendanceOption(
                                'Nieobecny',
                                Icons.cancel,
                                Colors.red,
                                !_isAttended,
                                () => setState(() => _isAttended = false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (_isAttended) ...[
                  const SizedBox(height: 24),

                  // Hours worked
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Przepracowane godziny',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Liczba godzin',
                              hintText: 'np. 4',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Podaj liczbę godzin';
                              }
                              final hours = int.tryParse(value);
                              if (hours == null || hours < 1) {
                                return 'Podaj prawidłową liczbę godzin';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Rating
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ocena wolontariusza',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(5, (index) {
                                final starValue = index + 1.0;
                                return IconButton(
                                  icon: Icon(
                                    starValue <= _rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 40,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () {
                                    setState(() => _rating = starValue);
                                  },
                                );
                              }),
                            ],
                          ),
                          Center(
                            child: Text(
                              '${_rating.toStringAsFixed(1)} / 5.0',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Feedback
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Opinia o wolontariuszu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _feedbackController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              labelText: 'Opinia (opcjonalnie)',
                              hintText: 'Opisz pracę wolontariusza...',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Submit button
                BlocBuilder<OrganizationBloc, OrganizationState>(
                  builder: (context, state) {
                    final isLoading = state is ApplicationsLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _submitAttendance,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.check),
                        label: Text(
                          isLoading ? 'Zapisywanie...' : 'Zapisz obecność',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
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

  Widget _buildAttendanceOption(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? color : Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAttendance() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isAttended) {
      // Mark attendance with hours and feedback
      final hours = int.parse(_hoursController.text);
      
      context.read<OrganizationBloc>().add(
            MarkVolunteerAttendance(
              applicationId: widget.application.id,
              hoursWorked: hours,
              feedback: _feedbackController.text.isEmpty
                  ? null
                  : _feedbackController.text,
            ),
          );

      // Also rate the volunteer if attended
      context.read<OrganizationBloc>().add(
            RateVolunteerPerformance(
              applicationId: widget.application.id,
              rating: _rating,
              comment: _feedbackController.text.isEmpty
                  ? null
                  : _feedbackController.text,
            ),
          );
    } else {
      // Mark as not attended (0 hours)
      context.read<OrganizationBloc>().add(
            MarkVolunteerAttendance(
              applicationId: widget.application.id,
              hoursWorked: 0,
            ),
          );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
