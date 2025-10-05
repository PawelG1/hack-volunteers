import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/volunteer_event.dart';
import '../../domain/repositories/events_repository.dart';
import '../../../../injection_container.dart' as di;
import 'event_details_page.dart';
import '../../domain/usecases/remove_interested_event.dart';

/// Calendar view for interested events
class EventsCalendarPage extends StatefulWidget {
  final bool showAppBar;
  
  const EventsCalendarPage({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<EventsCalendarPage> createState() => _EventsCalendarPageState();
}

class _EventsCalendarPageState extends State<EventsCalendarPage> {
  final EventsRepository _repository = di.sl<EventsRepository>();
  final RemoveInterestedEvent _removeInterestedEvent = di.sl<RemoveInterestedEvent>();
  
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  List<VolunteerEvent>? _allEvents;
  Map<DateTime, List<VolunteerEvent>> _eventsByDate = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
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
        setState(() {
          _allEvents = events;
          _eventsByDate = _groupEventsByDate(events);
          _isLoading = false;
        });
      },
    );
  }

  /// Group events by date (ignoring time)
  Map<DateTime, List<VolunteerEvent>> _groupEventsByDate(List<VolunteerEvent> events) {
    final Map<DateTime, List<VolunteerEvent>> grouped = {};
    
    for (final event in events) {
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(event);
    }
    
    return grouped;
  }

  /// Get events for a specific day
  List<VolunteerEvent> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _eventsByDate[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kalendarz wydarzeń'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadInterestedEvents,
              tooltip: 'Odśwież',
            ),
          ],
        ),
        body: _buildBody(),
      );
    } else {
      return _buildBody();
    }
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

    if (_allEvents == null || _allEvents!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Brak zapisanych wydarzeń',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Przejrzyj wydarzenia i swipe w prawo aby dodać do kalendarza',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Calendar widget
        Card(
          margin: const EdgeInsets.all(8),
          elevation: 2,
          child: TableCalendar<VolunteerEvent>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            locale: 'pl_PL',
            
            // Styling
            calendarStyle: CalendarStyle(
              // Today
              todayDecoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              
              // Selected day
              selectedDecoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              
              // Days with events
              markerDecoration: const BoxDecoration(
                color: AppColors.primaryMagenta,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
              
              // Weekend days
              weekendTextStyle: const TextStyle(color: AppColors.error),
            ),
            
            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              formatButtonDecoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Events list for selected day
        Expanded(
          child: _buildEventsListForSelectedDay(),
        ),
      ],
    );
  }

  Widget _buildEventsListForSelectedDay() {
    final eventsForDay = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    
    if (eventsForDay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Brak wydarzeń w dniu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (_selectedDay != null)
              Text(
                DateFormat('dd MMMM yyyy', 'pl_PL').format(_selectedDay!),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Wydarzenia - ${DateFormat('dd MMMM yyyy', 'pl_PL').format(_selectedDay!)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: eventsForDay.length,
            itemBuilder: (context, index) {
              final event = eventsForDay[index];
              return _buildEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(VolunteerEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                event: event,
                onRemoveFromInterested: () async {
                  final result = await _removeInterestedEvent(event.id);
                  result.fold(
                    (failure) => _loadInterestedEvents(),
                    (_) => _loadInterestedEvents(),
                  );
                },
              ),
            ),
          );
          _loadInterestedEvents();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time indicator
              Container(
                width: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(event.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Icon(
                          Icons.business,
                          size: 14,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.organization,
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    // Categories
                    if (event.categories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: event.categories.take(2).map((category) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.getCategoryColor(category)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.getCategoryColor(category)
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.getCategoryColor(category),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
