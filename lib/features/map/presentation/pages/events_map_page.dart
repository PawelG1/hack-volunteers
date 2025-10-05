import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart' as di;
import '../../../events/domain/entities/volunteer_event.dart';
import '../../../events/domain/repositories/events_repository.dart';

/// Events Map Page with OpenStreetMap
class EventsMapPage extends StatefulWidget {
  const EventsMapPage({super.key});

  @override
  State<EventsMapPage> createState() => _EventsMapPageState();
}

class _EventsMapPageState extends State<EventsMapPage> {
  final MapController _mapController = MapController();
  final EventsRepository _repository = di.sl<EventsRepository>();
  
  List<VolunteerEvent> _events = [];
  bool _isLoading = true;
  bool _showList = false;
  
  // Kraków center coordinates
  static const LatLng _krakow = LatLng(50.0647, 19.9450);

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    
    final result = await _repository.getEvents();
    
    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (events) {
        setState(() {
          _events = events.where((e) => e.latitude != null && e.longitude != null).toList();
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa wydarzeń'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(_showList ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                _showList = !_showList;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(_krakow, 13.0);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wycentrowano na Kraków'),
                  backgroundColor: AppColors.primaryMagenta,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _showList
              ? _buildListView()
              : _buildMapView(),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _krakow,
            initialZoom: 13.0,
            minZoom: 10.0,
            maxZoom: 18.0,
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.hack_volunteers',
              maxZoom: 19,
              // Additional headers for better compatibility
              additionalOptions: const {
                'User-Agent': 'SmokPomaga/1.0',
              },
              // Error tile placeholder
              errorImage: const AssetImage('assets/images/logo.png'),
              // Tile loading configuration
              tileProvider: NetworkTileProvider(),
            ),
            
            // Event markers
            MarkerLayer(
              markers: _events.map((event) {
                return Marker(
                  point: LatLng(event.latitude!, event.longitude!),
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () => _showEventBottomSheet(event),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shadow
                        Positioned(
                          bottom: 2,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Marker
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(event.categories.firstOrNull ?? ''),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getCategoryIcon(event.categories.firstOrNull ?? ''),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        
        // Top info bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryMagenta.withOpacity(0.9),
                  AppColors.primaryMagenta.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Kraków, Polska',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_events.length} wydarzeń',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Brak wydarzeń na mapie',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _showEventBottomSheet(event),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(event.categories.firstOrNull ?? ''),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(event.categories.firstOrNull ?? ''),
                          color: Colors.white,
                          size: 24,
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
                            Text(
                              event.organization,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        '${event.currentVolunteers}/${event.requiredVolunteers} wolontariuszy',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _showEventBottomSheet(event),
                        child: const Text('Szczegóły'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEventBottomSheet(VolunteerEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(event.categories.firstOrNull ?? ''),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(event.categories.firstOrNull ?? ''),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event.organization,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildInfoRow(Icons.location_on, 'Lokalizacja', event.location),
                    _buildInfoRow(
                      Icons.category, 
                      'Kategorie', 
                      event.categories.join(', ')
                    ),
                    _buildInfoRow(
                      Icons.people, 
                      'Wolontariusze', 
                      '${event.currentVolunteers}/${event.requiredVolunteers}'
                    ),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Data',
                      '${event.date.day}.${event.date.month}.${event.date.year}',
                    ),
                    
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Opis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _mapController.move(
                                LatLng(event.latitude!, event.longitude!),
                                15.0,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Wycentrowano na: ${event.title}'),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            },
                            icon: const Icon(Icons.center_focus_strong),
                            label: const Text('Pokaż'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Zapisano: ${event.title}'),
                                  backgroundColor: AppColors.primaryMagenta,
                                ),
                              );
                            },
                            icon: const Icon(Icons.favorite),
                            label: const Text('Zapisz'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryMagenta,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('edukacja')) return AppColors.primaryBlue;
    if (lowerCategory.contains('środowisko')) return AppColors.primaryGreen;
    if (lowerCategory.contains('pomoc') || lowerCategory.contains('społeczna')) {
      return AppColors.accentOrange;
    }
    if (lowerCategory.contains('technologia')) return const Color(0xFF9C27B0);
    if (lowerCategory.contains('kultura') || lowerCategory.contains('muzyka')) {
      return const Color(0xFFE91E63);
    }
    if (lowerCategory.contains('zwierzęta')) return const Color(0xFF795548);
    return AppColors.primaryMagenta;
  }

  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('edukacja')) return Icons.school;
    if (lowerCategory.contains('środowisko')) return Icons.eco;
    if (lowerCategory.contains('pomoc') || lowerCategory.contains('społeczna')) {
      return Icons.favorite;
    }
    if (lowerCategory.contains('technologia')) return Icons.engineering;
    if (lowerCategory.contains('kultura') || lowerCategory.contains('muzyka')) {
      return Icons.music_note;
    }
    if (lowerCategory.contains('zwierzęta')) return Icons.pets;
    return Icons.event;
  }
}
