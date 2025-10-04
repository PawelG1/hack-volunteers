import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Map Events Page with location-based event discovery
class MapEventsPage extends StatefulWidget {
  const MapEventsPage({super.key});

  @override
  State<MapEventsPage> createState() => _MapEventsPageState();
}

class _MapEventsPageState extends State<MapEventsPage> {
  bool _showList = false;
  
  // Mock data for demonstration
  final List<MapEvent> _mapEvents = [
    MapEvent(
      id: '1',
      title: 'Sprzątanie Parku Jordana',
      organization: 'EkoKraków',
      location: 'Park Jordana, Kraków',
      latitude: 50.0647,
      longitude: 19.9450,
      category: 'Środowisko',
      participantsCount: 12,
    ),
    MapEvent(
      id: '2',
      title: 'Pomoc w Schronisku',
      organization: 'Na Paluchu',
      location: 'ul. Kosocicka 25, Kraków',
      latitude: 50.0755,
      longitude: 19.9932,
      category: 'Pomoc społeczna',
      participantsCount: 8,
    ),
    MapEvent(
      id: '3',
      title: 'Warsztat Programowania',
      organization: 'Code for Kraków',
      location: 'AGH, al. Mickiewicza 30',
      latitude: 50.0648,
      longitude: 19.9237,
      category: 'Edukacja',
      participantsCount: 25,
    ),
  ];

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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Centrowanie na Twojej lokalizacji...'),
                  backgroundColor: AppColors.primaryMagenta,
                ),
              );
            },
          ),
        ],
      ),
      body: _showList ? _buildListView() : _buildMapView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: "search",
            onPressed: _showSearchDialog,
            backgroundColor: Colors.white,
            child: const Icon(Icons.search, color: AppColors.primaryMagenta),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            heroTag: "filter",
            onPressed: _showFilterDialog,
            backgroundColor: Colors.white,
            child: const Icon(Icons.filter_list, color: AppColors.primaryMagenta),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        // Map placeholder with pins
        Container(
          color: Colors.grey.shade200,
          child: Stack(
            children: [
              // Background pattern to simulate map
              Positioned.fill(
                child: CustomPaint(
                  painter: MapPatternPainter(),
                ),
              ),
              
              // Event pins
              ..._mapEvents.map((event) => Positioned(
                left: (event.longitude - 19.9000) * 2000,
                top: (50.1000 - event.latitude) * 2000,
                child: GestureDetector(
                  onTap: () => _showEventBottomSheet(event),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category),
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
                      _getCategoryIcon(event.category),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )),
              
              // Center info
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Mapa Krakowa',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Google Maps integration\nwkrótce dostępna',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_mapEvents.length} wydarzeń w okolicy',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryMagenta,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Top info bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryMagenta.withOpacity(0.9),
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
                  Text(
                    '${_mapEvents.length} wydarzeń',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mapEvents.length,
      itemBuilder: (context, index) {
        final event = _mapEvents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(event.category),
                      color: Colors.white,
                      size: 20,
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
                    '${event.participantsCount} uczestników',
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
        );
      },
    );
  }

  void _showEventBottomSheet(MapEvent event) {
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(event.category),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(event.category),
                            color: Colors.white,
                            size: 24,
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
                    _buildInfoRow(Icons.category, 'Kategoria', event.category),
                    _buildInfoRow(Icons.people, 'Uczestnicy', '${event.participantsCount} osób'),
                    
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Nawigacja do: ${event.title}'),
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                              );
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Nawiguj'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
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
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Szukaj w okolicy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Wpisz adres lub miejsce',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Funkcja geolokalizacji w przygotowaniu',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wyszukiwanie lokalizacji...'),
                  backgroundColor: AppColors.primaryMagenta,
                ),
              );
            },
            child: const Text('Szukaj'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtry mapy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Edukacja'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Środowisko'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Pomoc społeczna'),
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Text(
              'Promień wyszukiwania: 5 km',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Zastosuj'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'edukacja':
        return AppColors.primaryBlue;
      case 'środowisko':
        return AppColors.primaryGreen;
      case 'pomoc społeczna':
        return AppColors.accentOrange;
      default:
        return AppColors.primaryMagenta;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'edukacja':
        return Icons.school;
      case 'środowisko':
        return Icons.eco;
      case 'pomoc społeczna':
        return Icons.favorite;
      default:
        return Icons.event;
    }
  }
}

// Model for map events
class MapEvent {
  final String id;
  final String title;
  final String organization;
  final String location;
  final double latitude;
  final double longitude;
  final String category;
  final int participantsCount;

  MapEvent({
    required this.id,
    required this.title,
    required this.organization,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.participantsCount,
  });
}

// Custom painter for map background pattern
class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    // Draw grid pattern to simulate map
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}