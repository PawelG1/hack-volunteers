import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/mlody_krakow_footer.dart';
import '../../../organizations/domain/entities/certificate.dart';
import '../bloc/volunteer_certificates_bloc.dart';

class MyCertificatesPage extends StatefulWidget {
  final String volunteerId;

  const MyCertificatesPage({
    Key? key,
    required this.volunteerId,
  }) : super(key: key);

  @override
  State<MyCertificatesPage> createState() => _MyCertificatesPageState();
}

class _MyCertificatesPageState extends State<MyCertificatesPage> {
  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  void _loadCertificates() {
    context.read<VolunteerCertificatesBloc>().add(
          LoadVolunteerCertificates(volunteerId: widget.volunteerId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje Certyfikaty'),
        backgroundColor: AppColors.primaryMagenta,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCertificates,
          ),
        ],
      ),
      body: BlocBuilder<VolunteerCertificatesBloc, VolunteerCertificatesState>(
        builder: (context, state) {
          if (state is VolunteerCertificatesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is VolunteerCertificatesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Błąd podczas ładowania certyfikatów',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadCertificates,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Spróbuj ponownie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is VolunteerCertificatesLoaded) {
            final certificates = state.certificates;

            if (certificates.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadCertificates();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: certificates.length + 1, // +1 dla stopki
                itemBuilder: (context, index) {
                  // Ostatni element to stopka
                  if (index == certificates.length) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 24, bottom: 16),
                      child: MlodyKrakowFooter(
                        padding: EdgeInsets.zero,
                      ),
                    );
                  }
                  
                  return CertificateCard(
                    certificate: certificates[index],
                    onTap: () => _showCertificateDetails(certificates[index]),
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
            Icons.workspace_premium,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Brak certyfikatów',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Ukończ wydarzenia wolontariackie, aby otrzymać certyfikaty potwierdzające Twoje zaangażowanie',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.explore),
            label: const Text('Odkryj wydarzenia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showCertificateDetails(Certificate certificate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CertificateDetailsSheet(certificate: certificate),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final Certificate certificate;
  final VoidCallback onTap;

  const CertificateCard({
    Key? key,
    required this.certificate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBlue.withOpacity(0.1),
                AppColors.primaryMagenta.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Certyfikat Wolontariusza',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nr ${certificate.certificateNumber ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Courier',
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(certificate.status),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.event,
                  'Wydarzenie',
                  certificate.eventId,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.access_time,
                  'Godziny',
                  '${certificate.hoursWorked} godz.',
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Data wystawienia',
                  certificate.issuedAt != null
                      ? _formatDate(certificate.issuedAt!)
                      : 'Oczekuje',
                ),
                if (certificate.approvedBy != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.person,
                    'Koordynator',
                    certificate.approvedBy!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(CertificateStatus status) {
    Color color;
    String label;

    switch (status) {
      case CertificateStatus.pending:
        color = Colors.orange;
        label = 'Oczekuje';
        break;
      case CertificateStatus.issued:
        color = Colors.green;
        label = 'Wystawiony';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}

class CertificateDetailsSheet extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailsSheet({
    Key? key,
    required this.certificate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Certificate preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryBlue.withOpacity(0.1),
                              AppColors.primaryMagenta.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryBlue.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              size: 80,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'CERTYFIKAT WOLONTARIUSZA',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),
                            _buildCertificateField(
                              'Numer certyfikatu',
                              certificate.certificateNumber ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            _buildCertificateField(
                              'Wolontariusz',
                              certificate.volunteerId,
                            ),
                            const SizedBox(height: 12),
                            _buildCertificateField(
                              'Wydarzenie',
                              certificate.eventId,
                            ),
                            const SizedBox(height: 12),
                            _buildCertificateField(
                              'Przepracowane godziny',
                              '${certificate.hoursWorked} godzin',
                            ),
                            const SizedBox(height: 12),
                            _buildCertificateField(
                              'Data wystawienia',
                              certificate.issuedAt != null
                                  ? _formatDate(certificate.issuedAt!)
                                  : 'Oczekuje',
                            ),
                            if (certificate.approvedBy != null) ...[
                              const SizedBox(height: 12),
                              _buildCertificateField(
                                'Koordynator',
                                certificate.approvedBy!,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Additional details
                      const Text(
                        'Szczegóły',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Status',
                        _getStatusText(certificate.status),
                        _getStatusColor(certificate.status),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Organizacja',
                        certificate.organizationId,
                        Colors.grey[700]!,
                      ),
                      if (certificate.certificateNumber != null) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Numer certyfikatu',
                          certificate.certificateNumber!,
                          Colors.grey[700]!,
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Share certificate
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Funkcja udostępniania w przygotowaniu'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Udostępnij'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                side: BorderSide(color: AppColors.primaryBlue),
                                foregroundColor: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Download PDF
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Funkcja pobierania PDF w przygotowaniu'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Pobierz PDF'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _getStatusText(CertificateStatus status) {
    switch (status) {
      case CertificateStatus.pending:
        return 'Oczekuje';
      case CertificateStatus.issued:
        return 'Wystawiony';
    }
  }

  Color _getStatusColor(CertificateStatus status) {
    switch (status) {
      case CertificateStatus.pending:
        return Colors.orange;
      case CertificateStatus.issued:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'pl').format(date);
  }
}
