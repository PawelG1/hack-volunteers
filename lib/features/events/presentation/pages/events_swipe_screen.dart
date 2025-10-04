import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';
import '../widgets/swipeable_card.dart';

/// Main screen for swiping through events
class EventsSwipeScreen extends StatelessWidget {
  const EventsSwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo "Młody Kraków"
            Image.asset(
              'assets/images/mlody_krakow_horizontal.png',
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if logo is not available
                return Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volunteer_activism,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Młody Kraków',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EventsInitial) {
            // Load events on init
            context.read<EventsBloc>().add(LoadEventsEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EventsBloc>().add(LoadEventsEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Spróbuj ponownie'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is EventsLoaded) {
            final currentEvent = state.currentEvent;

            if (currentEvent == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Obejrzałeś wszystkie wydarzenia!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<EventsBloc>().add(LoadEventsEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Załaduj ponownie'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Minimalist progress dots
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.events.length > 5 ? 5 : state.events.length,
                      (index) {
                        final isActive = index == state.currentIndex;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isActive ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive 
                                ? Colors.red.shade400 
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Swipeable card stack
                Expanded(
                  child: Stack(
                    children: [
                      // Background card (next event preview)
                      if (state.currentIndex + 1 < state.events.length)
                        Positioned.fill(
                          child: SwipeableCard(
                            key: ValueKey(
                              'background_${state.events[state.currentIndex + 1].id}',
                            ),
                            event: state.events[state.currentIndex + 1],
                            onSwipeLeft: () {},
                            onSwipeRight: () {},
                            isFront: false,
                          ),
                        ),

                      // Front card (current event)
                      Positioned.fill(
                        child: SwipeableCard(
                          key: ValueKey('front_${currentEvent.id}'),
                          event: currentEvent,
                          onSwipeLeft: () {
                            context.read<EventsBloc>().add(
                              SwipeLeftEvent(currentEvent.id),
                            );
                          },
                          onSwipeRight: () {
                            context.read<EventsBloc>().add(
                              SwipeRightEvent(currentEvent.id),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons - Tinder style
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 32.0,
                    top: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Dislike button
                      _buildActionButton(
                        onPressed: () {
                          context.read<EventsBloc>().add(
                            SwipeLeftEvent(currentEvent.id),
                          );
                        },
                        icon: Icons.close,
                        color: AppColors.error,
                        size: 65,
                      ),

                      // Info button (middle)
                      _buildActionButton(
                        onPressed: () {
                          // Could show more details or info modal
                        },
                        icon: Icons.info_outline,
                        color: AppColors.primaryBlue,
                        size: 50,
                      ),

                      // Like button
                      _buildActionButton(
                        onPressed: () {
                          context.read<EventsBloc>().add(
                            SwipeRightEvent(currentEvent.id),
                          );
                        },
                        icon: Icons.favorite,
                        color: AppColors.primaryMagenta,
                        size: 65,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Build Tinder-style action button
  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Icon(
            icon,
            color: color,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
