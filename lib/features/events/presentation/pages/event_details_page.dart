import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/mlody_krakow_footer.dart';
import '../../domain/entities/volunteer_event.dart';

/// Event Details Page - shows full event information before applying
class EventDetailsPage extends StatelessWidget {
  final VolunteerEvent event;
  final VoidCallback? onRemoveFromInterested;

  const EventDetailsPage({
    super.key,
    required this.event,
    this.onRemoveFromInterested,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: event.imageUrl != null
                  ? Image.network(
                      event.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Organization
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 18,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.organization,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Info Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        title: 'Data',
                        value: DateFormat('dd.MM.yyyy, HH:mm')
                            .format(event.date),
                        color: AppColors.primaryMagenta,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Lokalizacja',
                        value: event.location,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.people,
                        title: 'Potrzebni wolontariusze',
                        value:
                            '${event.currentVolunteers}/${event.requiredVolunteers}',
                        color: AppColors.accentOrange,
                      ),
                      if (event.contactEmail != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.email,
                          title: 'Kontakt email',
                          value: event.contactEmail!,
                          color: AppColors.primaryBlue,
                        ),
                      ],
                      if (event.contactPhone != null) ...[
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.phone,
                          title: 'Kontakt telefon',
                          value: event.contactPhone!,
                          color: AppColors.accentPurple,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Categories
                if (event.categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategorie',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: event.categories.map((category) {
                            return Chip(
                              label: Text(category),
                              backgroundColor: AppColors.getCategoryColor(category)
                                  .withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: AppColors.getCategoryColor(category),
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: AppColors.getCategoryColor(category)
                                    .withOpacity(0.3),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Opis wydarzenia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer z informacją o wsparciu
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MlodyKrakowFooter(
                    padding: EdgeInsets.zero,
                  ),
                ),

                const SizedBox(height: 100), // Space for button
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: const Center(
        child: Icon(
          Icons.volunteer_activism,
          size: 80,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Remove from interested button (if callback provided)
            if (onRemoveFromInterested != null) ...[
              OutlinedButton(
                onPressed: () {
                  _showRemoveDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.close, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      'Usuń z zainteresowań',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Anuluj',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Apply button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primaryMagenta,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Potwierdź udział',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Potwierdź udział'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Czy na pewno chcesz zgłosić się jako wolontariusz na to wydarzenie?',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Wiadomość do organizatora (opcjonalna)',
                hintText: 'Np. Dlaczego chcesz wziąć udział...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Apply for event with BLoC
              Navigator.pop(context); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Zgłoszenie wysłane! Organizator otrzymał Twoją aplikację.'),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 3),
                ),
              );
              context.pop(); // Go back to list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMagenta,
            ),
            child: const Text('Potwierdź'),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń z zainteresowań'),
        content: Text(
          'Czy na pewno chcesz usunąć to wydarzenie z listy zainteresowań?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (onRemoveFromInterested != null) {
                onRemoveFromInterested!();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Wydarzenie usunięte z zainteresowań'),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 2),
                ),
              );
              context.pop(); // Go back to list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
  }
}
