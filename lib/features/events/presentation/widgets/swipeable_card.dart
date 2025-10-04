import 'package:flutter/material.dart';
import '../../domain/entities/volunteer_event.dart';
import 'event_card.dart';

/// Swipeable card widget with Tinder-like animations
class SwipeableCard extends StatefulWidget {
  final VolunteerEvent event;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final bool isFront;

  const SwipeableCard({
    super.key,
    required this.event,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.isFront = true,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _isSwipedOff = false;
  bool _hasTriggeredCallback = false; // Prevent multiple callbacks

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_dragOffset.dx.abs() > threshold) {
      // Swipe detected
      final direction = _dragOffset.dx > 0 ? 1 : -1;
      _animateSwipe(direction);
    } else {
      // Return to center
      _resetPosition();
    }
  }

  void _animateSwipe(int direction) {
    if (_hasTriggeredCallback) {
      print('🚫 WIDGET BLOCKED: Callback already triggered for ${widget.event.id}');
      return; // Prevent duplicate swipes
    }
    
    print('📱 WIDGET: Starting swipe animation for ${widget.event.id}');
    
    final screenWidth = MediaQuery.of(context).size.width;
    final endOffset = Offset(screenWidth * 1.5 * direction, _dragOffset.dy);

    setState(() {
      _isSwipedOff = true;
      _hasTriggeredCallback = true; // Mark as triggered
    });

    _animation = Tween<Offset>(
      begin: _dragOffset,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rotationAnimation = Tween<double>(
      begin: _getRotation(),
      end: direction * 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Fade out animation
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) {
      if (!mounted) return; // Check if widget is still mounted
      
      print('📱 WIDGET: Calling callback for ${widget.event.id}');
      if (direction > 0) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    });
  }

  void _resetPosition() {
    _animation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotationAnimation = Tween<double>(
      begin: _getRotation(),
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward().then((_) {
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
      _controller.reset();
    });
  }

  double _getRotation() {
    const maxRotation = 0.3;
    final screenWidth = MediaQuery.of(context).size.width;
    final rotation = (_dragOffset.dx / screenWidth) * maxRotation;
    return rotation.clamp(-maxRotation, maxRotation);
  }

  double _getScale() {
    if (widget.isFront) {
      return 1.0;
    }
    // Background card slightly smaller
    return 0.95;
  }

  Color _getOverlayColor() {
    if (!_isDragging) return Colors.transparent;

    final screenWidth = MediaQuery.of(context).size.width;
    final progress = (_dragOffset.dx.abs() / screenWidth).clamp(0.0, 1.0);

    if (_dragOffset.dx > 0) {
      // Swiping right - green overlay
      return Colors.green.withValues(alpha: progress * 0.3);
    } else {
      // Swiping left - red overlay
      return Colors.red.withValues(alpha: progress * 0.3);
    }
  }

  IconData _getOverlayIcon() {
    return _dragOffset.dx > 0 ? Icons.favorite : Icons.close;
  }

  bool _showOverlay() {
    final screenWidth = MediaQuery.of(context).size.width;
    return _isDragging && _dragOffset.dx.abs() > screenWidth * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    if (_isSwipedOff && !_controller.isAnimating) {
      // Card has been swiped off and animation is complete - don't render
      return const SizedBox.shrink();
    }

    final offset = _controller.isAnimating ? _animation.value : _dragOffset;
    final rotation = _controller.isAnimating
        ? _rotationAnimation.value
        : _getRotation();
    final scale = _getScale();
    final opacity = _controller.isAnimating ? _opacityAnimation.value : 1.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: offset,
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: GestureDetector(
                  onPanStart: widget.isFront ? _onPanStart : null,
                  onPanUpdate: widget.isFront ? _onPanUpdate : null,
                  onPanEnd: widget.isFront ? _onPanEnd : null,
                  child: Stack(
                    children: [
                      // The card itself
                      EventCard(event: widget.event),

                      // Overlay with icon
                      if (_showOverlay())
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getOverlayColor(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Icon(
                                _getOverlayIcon(),
                                size: 120,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
