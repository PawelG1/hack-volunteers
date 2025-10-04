import 'package:flutter/material.dart';
import '../../domain/entities/volunteer_event.dart';
import 'package:intl/intl.dart';

/// Tinder-style event card with large image and gradient overlay
class EventCard extends StatefulWidget {
  final VolunteerEvent event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image/gradient (full card)
            Positioned.fill(
              child: _buildBackgroundImage(),
            ),

            // Dark gradient overlay for better text readability
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Content at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  constraints: BoxConstraints(
                    maxHeight: _isExpanded 
                        ? screenHeight * 0.5 
                        : screenHeight * 0.3,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title and age-style info
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.event.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Expand indicator
                            Icon(
                              _isExpanded 
                                  ? Icons.keyboard_arrow_down 
                                  : Icons.keyboard_arrow_up,
                              color: Colors.white,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Organization with icon
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.business,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.event.organization,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Location and Date in compact row
                        _buildInfoRow(
                          Icons.location_on,
                          widget.event.location,
                          Colors.red.shade300,
                        ),
                        const SizedBox(height: 8),
                        
                        _buildInfoRow(
                          Icons.calendar_today,
                          DateFormat('dd MMM yyyy, HH:mm').format(widget.event.date),
                          Colors.blue.shade300,
                        ),
                        const SizedBox(height: 8),

                        _buildInfoRow(
                          Icons.people,
                          '${widget.event.requiredVolunteers} wolontariuszy',
                          Colors.green.shade300,
                        ),

                        // Expandable description
                        if (_isExpanded) ...[
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white38),
                          const SizedBox(height: 12),
                          
                          Text(
                            widget.event.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Categories
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.event.categories.map((category) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    // For now using gradient placeholder - in future use widget.event.imageUrl
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(widget.event.categories.firstOrNull),
            _getCategoryColor(widget.event.categories.firstOrNull).withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getCategoryIcon(widget.event.categories.firstOrNull),
          size: 120,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'zwierzęta':
        return Colors.orange.shade400;
      case 'środowisko':
        return Colors.green.shade500;
      case 'edukacja':
        return Colors.blue.shade500;
      case 'sport':
        return Colors.red.shade400;
      case 'kultura':
        return Colors.purple.shade400;
      case 'pomoc społeczna':
        return Colors.teal.shade400;
      default:
        return Colors.indigo.shade400;
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'zwierzęta':
        return Icons.pets;
      case 'środowisko':
        return Icons.park;
      case 'edukacja':
        return Icons.school;
      case 'sport':
        return Icons.sports_soccer;
      case 'kultura':
        return Icons.palette;
      case 'pomoc społeczna':
        return Icons.volunteer_activism;
      default:
        return Icons.volunteer_activism;
    }
  }
}
