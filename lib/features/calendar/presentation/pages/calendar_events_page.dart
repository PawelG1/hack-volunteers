import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Calendar Events Page with timeline view and notifications
class CalendarEventsPage extends StatefulWidget {
  const CalendarEventsPage({super.key});

  @override
  State<CalendarEventsPage> createState() => _CalendarEventsPageState();
}

class _CalendarEventsPageState extends State<CalendarEventsPage> {
  DateTime _selectedDate = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  
  // Mock calendar events
  final Map<DateTime, List<CalendarEvent>> _events = {
    DateTime(2025, 10, 5): [
      CalendarEvent('Sprzątanie parku', '10:00', 'EkoKraków', AppColors.primaryGreen),
      CalendarEvent('Warsztat edukacyjny', '14:00', 'Fundacja Edukacja+', AppColors.primaryBlue),
    ],
    DateTime(2025, 10, 7): [
      CalendarEvent('Pomoc w schronisku', '09:00', 'Na Paluchu', AppColors.accentOrange),
    ],
    DateTime(2025, 10, 12): [
      CalendarEvent('Festiwal kultury', '16:00', 'Kraków Kultura', AppColors.accentPurple),
      CalendarEvent('Maraton programowania', '10:00', 'Code for Kraków', AppColors.primaryBlue),
    ],
    DateTime(2025, 10, 15): [
      CalendarEvent('Zbiórka żywności', '12:00', 'Caritas', AppColors.accentOrange),
    ],
    DateTime(2025, 10, 20): [
      CalendarEvent('Dzień sportu', '08:00', 'Sport dla Wszystkich', AppColors.primaryGreen),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendarz wydarzeń'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _selectedMonth = DateTime.now().month;
                _selectedYear = DateTime.now().year;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _showNotificationSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryMagenta.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                GestureDetector(
                  onTap: _showMonthYearPicker,
                  child: Text(
                    _getMonthYearText(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // Calendar grid
          Expanded(
            flex: 2,
            child: _buildCalendarGrid(),
          ),
          
          // Events for selected day
          Expanded(
            flex: 3,
            child: _buildSelectedDayEvents(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        backgroundColor: AppColors.primaryMagenta,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    final lastDayOfMonth = DateTime(_selectedYear, _selectedMonth + 1, 0);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: ['Pon', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Ndz']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          
          // Calendar days
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42, // 6 weeks
              itemBuilder: (context, index) {
                final dayNumber = index - firstWeekdayOfMonth + 1;
                final isValidDay = dayNumber > 0 && dayNumber <= daysInMonth;
                final date = DateTime(_selectedYear, _selectedMonth, dayNumber);
                final hasEvents = _events.containsKey(date);
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());

                if (!isValidDay) {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryMagenta
                          : isToday
                              ? AppColors.primaryMagenta.withOpacity(0.2)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                      border: hasEvents && !isSelected
                          ? Border.all(color: AppColors.primaryMagenta, width: 1)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            dayNumber.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isToday || isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? AppColors.primaryMagenta
                                      : Colors.black,
                            ),
                          ),
                        ),
                        if (hasEvents && !isSelected)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryMagenta,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayEvents() {
    final selectedEvents = _events[_selectedDate] ?? [];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  _getSelectedDateText(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (selectedEvents.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMagenta.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${selectedEvents.length} wydarzeń',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryMagenta,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: selectedEvents.isEmpty
                ? _buildNoEventsView()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: event.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: event.color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 40,
                              decoration: BoxDecoration(
                                color: event.color,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
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
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event.organization,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        event.time,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showEventOptions(event),
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoEventsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Brak wydarzeń',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nie masz zaplanowanych wydarzeń\nna ten dzień',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddEventDialog,
            icon: const Icon(Icons.add),
            label: const Text('Dodaj wydarzenie'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMagenta,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  void _showMonthYearPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wybierz miesiąc i rok'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Funkcja wyboru daty w przygotowaniu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ustawienia powiadomień'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Powiadomienia push'),
              subtitle: const Text('Przypomnienia o wydarzeniach'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Email'),
              subtitle: const Text('Podsumowanie tygodniowe'),
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Text(
              'Przypominaj mi o wydarzeniach:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('1h wcześniej'),
                    selected: true,
                    onSelected: (value) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('1 dzień'),
                    selected: false,
                    onSelected: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dodaj przypomnienie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tytuł wydarzenia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Czas (np. 10:00)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Data: ${_getSelectedDateText()}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Przypomnienie dodane!'),
                  backgroundColor: AppColors.primaryMagenta,
                ),
              );
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  void _showEventOptions(CalendarEvent event) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Szczegóły'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Otwieranie: ${event.title}'),
                    backgroundColor: AppColors.primaryMagenta,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Zmień przypomnienie'),
              onTap: () {
                Navigator.pop(context);
                _showNotificationSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Usuń', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Usunięto: ${event.title}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getMonthYearText() {
    const months = [
      'Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec',
      'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'
    ];
    return '${months[_selectedMonth - 1]} $_selectedYear';
  }

  String _getSelectedDateText() {
    const months = [
      'stycznia', 'lutego', 'marca', 'kwietnia', 'maja', 'czerwca',
      'lipca', 'sierpnia', 'września', 'października', 'listopada', 'grudnia'
    ];
    return '${_selectedDate.day} ${months[_selectedDate.month - 1]} ${_selectedDate.year}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

// Model for calendar events
class CalendarEvent {
  final String title;
  final String time;
  final String organization;
  final Color color;

  CalendarEvent(this.title, this.time, this.organization, this.color);
}