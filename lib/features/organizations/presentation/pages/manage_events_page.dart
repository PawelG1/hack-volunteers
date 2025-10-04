import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Manage Events Page - for creating and editing events
class ManageEventsPage extends StatelessWidget {
  const ManageEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzanie wydarzeniami'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_note,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Lista twoich wydarzeń',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Wkrótce będziesz mógł dodawać, edytować i usuwać wydarzenia',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open add event dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funkcja dodawania wydarzeń będzie wkrótce dostępna'),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Dodaj wydarzenie'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }
}
