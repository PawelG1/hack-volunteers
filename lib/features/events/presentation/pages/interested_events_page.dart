import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/volunteer_event.dart';
import '../../domain/repositories/events_repository.dart';
import '../../domain/usecases/remove_interested_event.dart';
import '../../domain/usecases/clear_all_interested_events.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../injection_container.dart' as di;
import 'event_details_page.dart';

/// Interested Events List - shows events user swiped right on
class InterestedEventsPage extends StatefulWidget {
  const InterestedEventsPage({super.key});

  @override
  State<InterestedEventsPage> createState() => _InterestedEventsPageState();
}

class _InterestedEventsPageState extends State<InterestedEventsPage> {
  final EventsRepository _repository = di.sl<EventsRepository>();
  final RemoveInterestedEvent _removeInterestedEvent = di.sl<RemoveInterestedEvent>();
  final ClearAllInterestedEvents _clearAllInterestedEvents = di.sl<ClearAllInterestedEvents>();
  List<VolunteerEvent>? _events;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInterestedEvents();
  }

  Future<void> _loadInterestedEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _repository.getInterestedEvents();

    result.fold(
      (failure) {
        setState(() {
          _error = failure.message;
          _isLoading = false;
        });
      },
      (events) {
        // Debug: Check for UI duplicates
        final eventIds = events.map((e) => e.id).toList();
        final uniqueIds = eventIds.toSet();
        
        if (eventIds.length != uniqueIds.length) {
          print('🚨 UI DUPLICATES: Found ${eventIds.length - uniqueIds.length} duplicate events in UI!');
          print('📋 All event IDs: $eventIds');
          print('📋 Unique event IDs: ${uniqueIds.toList()}');
        } else {
          print('✅ UI OK: ${eventIds.length} unique events in interested list');
        }
        
        setState(() {
          _events = events;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje zainteresowania'),
        actions: [
          if (_events != null && _events!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _showClearAllDialog,
              tooltip: 'Usuń wszystkie',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInterestedEvents,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInterestedEvents,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    if (_events == null || _events!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Brak zainteresowań',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Przejrzyj wydarzenia i swipe w prawo aby dodać do listy',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInterestedEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events!.length,
        itemBuilder: (context, index) {
          final event = _events![index];
          return _buildEventCard(event, key: ValueKey('event_${event.id}'));
        },
      ),
    );
  }

  Widget _buildEventCard(VolunteerEvent event, {Key? key}) {
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                event: event,
                onRemoveFromInterested: () async {
                  // Remove event from interested
                  final result = await _removeInterestedEvent(event.id);
                  result.fold(
                    (failure) {
                      // Error handled by dialog, just refresh list
                      _loadInterestedEvents();
                    },
                    (_) {
                      // Success - refresh list
                      _loadInterestedEvents();
                    },
                  );
                },
              ),
            ),
          );
          // Refresh after coming back
          _loadInterestedEvents();
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or gradient header
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: event.imageUrl == null
                    ? AppColors.primaryGradient
                    : null,
              ),
              child: event.imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.volunteer_activism,
                              size: 50,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.volunteer_activism,
                        size: 50,
                        color: Colors.white70,
                      ),
                    ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Organization
                  Row(
                    children: [
                      const Icon(
                        Icons.business,
                        size: 16,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.organization,
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Date and Location
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd.MM.yyyy').format(event.date),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Categories
                  if (event.categories.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: event.categories.take(3).map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getCategoryColor(category)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.getCategoryColor(category)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.getCategoryColor(category),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(
                              event: event,
                              onRemoveFromInterested: () async {
                                // Remove event from interested
                                final result = await _removeInterestedEvent(event.id);
                                result.fold(
                                  (failure) {
                                    // Error handled by dialog, just refresh list
                                    _loadInterestedEvents();
                                  },
                                  (_) {
                                    // Success - refresh list
                                    _loadInterestedEvents();
                                  },
                                );
                              },
                            ),
                          ),
                        );
                        // Refresh after coming back
                        _loadInterestedEvents();
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Zobacz szczegóły i potwierdź'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMagenta,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog before clearing all interested events
  Future<void> _showClearAllDialog() async {
    final bool? shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuń wszystkie zainteresowania'),
          content: const Text(
            'Czy na pewno chcesz usunąć wszystkie wydarzenia z listy zainteresowań? '
            'Ta operacja jest nieodwracalna.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Usuń wszystkie'),
            ),
          ],
        );
      },
    );

    if (shouldClear == true) {
      await _clearAllInterests();
    }
  }

  /// Clear all interested events
  Future<void> _clearAllInterests() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _clearAllInterestedEvents(NoParams());

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (_) {
        setState(() {
          _events = [];
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wszystkie zainteresowania zostały usunięte'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }
}
