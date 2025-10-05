import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../events/presentation/widgets/event_card.dart';
import '../../../events/data/datasources/events_remote_data_source.dart';


/// Search Events Page with advanced filtering
class SearchEventsPage extends StatefulWidget {
  const SearchEventsPage({super.key});

  @override
  State<SearchEventsPage> createState() => _SearchEventsPageState();
}

class _SearchEventsPageState extends State<SearchEventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Wszystkie';
  List<VolunteerEvent> _filteredEvents = [];
  List<VolunteerEvent> _allEvents = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'Wszystkie',
    'Edukacja',
    'Środowisko',
    'Pomoc społeczna',
    'Kultura',
    'Sport',
    'Zdrowie',
    'Technologia'
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Replace with proper BLoC call
      final remoteDataSource = EventsRemoteDataSourceImpl();
      final eventsResult = await remoteDataSource.getEvents();
      
      setState(() {
        _allEvents = eventsResult.map((model) => VolunteerEvent(
          id: model.id,
          title: model.title,
          description: model.description,
          organization: model.organization,
          organizationId: model.organizationId,
          location: model.location,
          latitude: model.latitude,
          longitude: model.longitude,
          date: model.date,
          endDate: model.endDate,
          requiredVolunteers: model.requiredVolunteers,
          currentVolunteers: model.currentVolunteers,
          categories: model.categories,
          imageUrl: model.imageUrl,
          contactEmail: model.contactEmail,
          contactPhone: model.contactPhone,
          status: model.status,
          createdAt: model.createdAt,
          updatedAt: model.updatedAt,
        )).toList();
        _filteredEvents = _allEvents;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading events in search: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd ładowania wydarzeń: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredEvents = _allEvents.where((event) {
        // Filter by category
        bool matchesCategory = _selectedCategory == 'Wszystkie' || 
            event.categories.contains(_selectedCategory.toLowerCase());
        
        // Filter by search query (organization name, title, description)
        bool matchesQuery = query.isEmpty ||
            event.organization.toLowerCase().contains(query) ||
            event.title.toLowerCase().contains(query) ||
            event.description.toLowerCase().contains(query);
        
        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyszukaj wydarzenia'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Szukaj po nazwie organizatora, tytule...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryMagenta),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryMagenta),
                ),
              ),
            ),
          ),
          
          // Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (bool value) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _performSearch();
                    },
                    selectedColor: AppColors.primaryMagenta.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryMagenta,
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primaryMagenta : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Results count
          if (!_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                'Znaleziono ${_filteredEvents.length} wydarzeń',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          
          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEvents.isEmpty
                    ? _buildNoResultsView()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = _filteredEvents[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                // TODO: Navigate to event details
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Otwieranie: ${event.title}'),
                                    backgroundColor: AppColors.primaryMagenta,
                                  ),
                                );
                              },
                              child: EventCard(
                                event: event,
                                height: 300, // Compact height for search list
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

  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Brak wyników',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'Spróbuj zmienić filtr kategorii'
                : 'Spróbuj użyć innych słów kluczowych',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedCategory = 'Wszystkie';
              });
              _performSearch();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Wyczyść filtry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryMagenta,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dodatkowe filtry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Funkcja w przygotowaniu...'),
            const SizedBox(height: 16),
            Text(
              'Wkrótce będziesz mógł filtrować wydarzenia według:\n'
              '• Daty i czasu\n'
              '• Lokalizacji\n'
              '• Liczby wymaganych wolontariuszy\n'
              '• Poziomu trudności',
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
}